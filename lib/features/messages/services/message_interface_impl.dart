import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/features/messages/model/create_chat_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/mode_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/send_chat_message_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/select_mood_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/select_mood_responces_model.dart';
import 'package:chasingharmony_fluttere/features/messages/services/message_int.dart';

final class MessageInterfaceImpl extends MessageInt {
  MessageInterfaceImpl({required this.appPigeon});

  final AppPigeon appPigeon;

  @override
  FutureRequest<Success<MessageResponseModel>> createChat(
    CreateChatRequestModel params,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.createMessage,
          data: params.toJson(),
        );
        return _parseMessageResponse(
          response.data,
          fallbackMessage: 'Failed to create chat',
        );
      },
    );
  }

  @override
  FutureRequest<Success<MessageResponseModel>> sendNewMessage(
    SendChatMessageRequestModel params,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.sendMessage,
          data: params.toJson(),
        );
        return _parseMessageResponse(
          response.data,
          fallbackMessage: 'Failed to send chat message',
        );
      },
    );
  }

  @override
  FutureRequest<Success<ModeModel>> getAllMode() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getAllMode);
        final body = response.data;
        if (body is! Map) {
          throw Exception('Invalid response format');
        }

        final root = Map<String, dynamic>.from(body);
        final message = root['message']?.toString() ?? 'Success';
        if (root['success'] == false) {
          throw Exception(
            message.isEmpty ? 'Failed to load mode options' : message,
          );
        }

        final data = root['data'];
        if (data is! Map) {
          throw Exception('Invalid mode data format');
        }

        return Success<ModeModel>(
          data: ModeModel.fromJson(Map<String, dynamic>.from(data)),
          message: message,
        );
      },
    );
  }

  @override
  FutureRequest<Success<SelectMoodResponsesModel>> selectMood(
    SelectMoodRequestModel params,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.selectMood,
          data: params.toJson(),
        );
        final body = response.data;
        if (body is! Map) {
          throw Exception('Invalid response format');
        }

        final root = Map<String, dynamic>.from(body);
        final message = root['message']?.toString() ?? 'Success';
        if (root['success'] == false) {
          throw Exception(
            message.isEmpty ? 'Failed to submit mood selection' : message,
          );
        }

        final data = root['data'];
        if (data is! Map) {
          throw Exception('Invalid mood selection response format');
        }

        return Success<SelectMoodResponsesModel>(
          data: SelectMoodResponsesModel.fromJson(root),
          message: message,
        );
      },
    );
  }

  Success<MessageResponseModel> _parseMessageResponse(
    dynamic body, {
    required String fallbackMessage,
  }) {
    if (body is! Map) {
      throw Exception('Invalid response format');
    }

    final parsedResponse = MessageResponseModel.fromJson(
      Map<String, dynamic>.from(body),
    );

    if (!parsedResponse.success) {
      throw Exception(
        parsedResponse.message.trim().isEmpty
            ? fallbackMessage
            : parsedResponse.message,
      );
    }

    return Success<MessageResponseModel>(
      data: parsedResponse,
      message: parsedResponse.message,
    );
  }
}
