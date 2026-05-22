import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/features/home/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/home/model/send_message_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/mode_model.dart';
import 'package:chasingharmony_fluttere/features/messages/services/message_int.dart';

final class MessageInterfaceImpl extends MessageInt {
  MessageInterfaceImpl({required this.appPigeon});

  final AppPigeon appPigeon;

  @override
  FutureRequest<Success<MessageResponcesModel>> sendMessage(
    SendMessageModel params,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.message,
          data: params.toJson(),
        );
        final body = response.data;
        if (body is! Map) {
          throw Exception('Invalid response format');
        }

        final parsedResponse = MessageResponcesModel.fromJson(
          Map<String, dynamic>.from(body),
        );

        if (!parsedResponse.success) {
          throw Exception(
            parsedResponse.message.trim().isEmpty
                ? 'Failed to process chat message'
                : parsedResponse.message,
          );
        }

        return Success<MessageResponcesModel>(
          data: parsedResponse,
          message: parsedResponse.message,
        );
      },
    );
  }

  @override
  FutureRequest<Success<ModeModel>> getAllMode() async {
    return await asyncTryCatch(tryFunc: () async {
      final response = await appPigeon.get(ApiEndpoints.getAllMode);
      final body = response.data;
      if (body is! Map) {
        throw Exception('Invalid response format');
      }

      final root = Map<String, dynamic>.from(body);
      final message = root['message']?.toString() ?? 'Success';
      if (root['success'] == false) {
        throw Exception(message.isEmpty ? 'Failed to load mode options' : message);
      }

      final data = root['data'];
      if (data is! Map) {
        throw Exception('Invalid mode data format');
      }

      return Success<ModeModel>(
        data: ModeModel.fromJson(Map<String, dynamic>.from(data)),
        message: message,
      );
    });
  }
}
