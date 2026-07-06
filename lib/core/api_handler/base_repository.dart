import 'dart:io';

import 'package:app_pigeon/app_pigeon.dart' show AuthorizedPigeon;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;

import '../services/debug/debug_service.dart';
import 'exceptions.dart';
import 'failure.dart';

base class BaseRepository {
  String? _extractDioMessage(dynamic body) {
    if (body is Map) {
      final message = body['message'];
      if (message != null) return message.toString();
    }
    return null;
  }

  String _fallbackMessageForStatus(int? statusCode) {
    switch (statusCode) {
      case 413:
        return 'Upload failed. The image is too large — try a smaller file.';
      case 502:
      case 504:
        return 'Server is unreachable right now. Please try again.';
      case 402:
        return 'Your current plan has reached its limit. Upgrade to continue.';
      default:
        return 'Some error occured.';
    }
  }

  /// A 401 that reaches the repository was NOT recovered by the token-refresh
  /// interceptor, which means the access token is expired/invalid and the
  /// session can no longer be refreshed. 401s on the auth endpoints
  /// (login/refresh/etc.) are bad-credentials responses — not expired
  /// sessions — so they are excluded to keep their own error messages.
  bool _isExpiredSessionError(DioException e) {
    if (e.response?.statusCode != 401) return false;
    final path = e.requestOptions.path.toLowerCase();
    return !path.contains('/auth');
  }

  /// Clears the stored auth record. This fires app_pigeon's auth stream with
  /// [UnAuthenticated], which AppManager listens to and uses to route the user
  /// back to the login screen. Safe to call repeatedly (idempotent).
  void _forceLogoutOnExpiredSession() {
    try {
      if (Get.isRegistered<AuthorizedPigeon>()) {
        Get.find<AuthorizedPigeon>().logOut();
      }
    } catch (_) {
      // Never let logout bookkeeping mask the original failure.
    }
  }

  Future<Either<DataCRUDFailure, T>> asyncTryCatch<T>({
    required Future<T> Function() tryFunc,
  }) async {
    try {
      return await tryFunc().then((value) => Right(value));
    } on ServerException {
      return Left(
        DataCRUDFailure(
          failure: Failure.severFailure,
          fullError: 'Server failed!',
        ),
      );
    } on NoDataException {
      return Left(
        DataCRUDFailure(failure: Failure.noData, fullError: "Doesn't exist!"),
      );
    } on SocketException {
      return Left(
        DataCRUDFailure(
          failure: Failure.socketFailure,
          fullError: 'Internet connection failed!',
        ),
      );
    } on DioException catch (e) {
      //debugger?.dekhao("DioFailure $e");
      // Expired/invalid session that the interceptor could not refresh:
      // clear auth so the app routes back to the login screen.
      if (_isExpiredSessionError(e)) {
        _forceLogoutOnExpiredSession();
        return Left(
          DataCRUDFailure(
            failure: Failure.authFailure,
            uiMessage: 'Your session has expired. Please sign in again.',
            fullError: 'Unauthorized (401): ${e.toString()}',
          ),
        );
      }
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return Left(
            DataCRUDFailure(
              failure: Failure.timeout,
              fullError: 'Connection timeout! Make sure internet is connected!',
            ),
          );
        case DioExceptionType.receiveTimeout:
          return Left(
            DataCRUDFailure(
              failure: Failure.timeout,
              fullError: 'Connection timeout! Make sure internet is connected!',
            ),
          );
        case DioExceptionType.sendTimeout:
          return Left(
            DataCRUDFailure(
              failure: Failure.timeout,
              fullError: 'Connection timeout! Make sure internet is connected!',
            ),
          );
        case DioExceptionType.cancel:
          return Left(
            DataCRUDFailure(
              failure: Failure.unknownFailure,
              uiMessage: "Request cancelled!",
              fullError: 'Some error occured. ${'\n'} Error: ${e.toString()}',
            ),
          );
        case DioExceptionType.connectionError:
          final raw = '${e.message ?? ''} ${e.error ?? ''}'.toLowerCase();
          final isHostLookupIssue =
              raw.contains('failed host lookup') ||
              raw.contains('no address associated with hostname') ||
              raw.contains('name or service not known');
          return Left(
            DataCRUDFailure(
              failure: Failure.socketFailure,
              uiMessage: isHostLookupIssue
                  ? 'Cannot resolve backend host. Check server URL, DNS, or internet connection.'
                  : 'Unable to connect to server. Check internet connection and backend status.',
              fullError: 'Connection error: ${e.toString()}',
            ),
          );
        default:
          if (e.response?.statusCode == 503) {
            return Left(
              DataCRUDFailure(
                failure: Failure.severFailure,
                uiMessage: 'Server is starting up. Please wait a moment and try again.',
                fullError: '503 Service Unavailable: ${e.toString()}',
              ),
            );
          }
          final serverMessage = _extractDioMessage(e.response?.data);
          return Left(
            DataCRUDFailure(
              failure: Failure.unknownFailure,
              uiMessage: serverMessage ??
                  _fallbackMessageForStatus(e.response?.statusCode),
              fullError: 'Some error occured. ${'\n'} Error: ${e.toString()}',
            ),
          );
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      //debugger?.dekhao(e);
      return Left(
        DataCRUDFailure(
          failure: Failure.unknownFailure,
          uiMessage: 'Some error occured.',
          fullError: "Some error occured. ${'\n'} Error: ${e.toString()}",
        ),
      );
    }
  }

  Either<DataCRUDFailure, T> tryCatch<T>({required T Function() tryFunc}) {
    try {
      return Right(tryFunc());
    } on ServerException {
      return Left(
        DataCRUDFailure(failure: Failure.severFailure, fullError: ''),
      );
    } on SocketException {
      return Left(
        DataCRUDFailure(
          failure: Failure.socketFailure,
          fullError: 'Internet connection failed!',
        ),
      );
    } catch (e) {
      return Left(
        DataCRUDFailure(
          failure: Failure.unknownFailure,
          fullError: 'Some error occured. Error: ${e.toString()}',
        ),
      );
    }
  }

  dynamic extractBodyData(Response<dynamic> response) {
    return response.data["data"];
  }

  String? extractSuccessMessage(
    Response<dynamic> response, {
    Debugger? debugger,
  }) {
    debugger?.dekhao(response);
    try {
      return (response.data["success"] as bool) == true
          ? response.data["message"] as String
          : null;
    } catch (e) {
      debugger?.dekhao("Error from parsing success message: $e");
      return null;
    }
  }
}
