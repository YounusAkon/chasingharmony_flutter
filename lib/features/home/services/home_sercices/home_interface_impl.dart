import 'dart:convert';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/core/network/app_language_options.dart';
import 'package:chasingharmony_fluttere/features/home/model/chat_stream_event.dart';
import 'package:chasingharmony_fluttere/features/home/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/home/model/send_message_model.dart';
import 'package:chasingharmony_fluttere/features/home/services/home_sercices/home_interface.dart';

final class HomeInterfaceImpl extends HomeInterface {
  HomeInterfaceImpl({required this.appPigeon});
  final AppPigeon appPigeon;

  @override
  FutureRequest<Success<MessageResponcesModel>> sendNewMessage(
    SendMessageModel params,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.sendNewMessage,
          data: params.toJson(),
          options: appLanguageOptions(),
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
  Stream<ChatStreamEvent> sendNewMessageStream(SendMessageModel params) async* {
    final languageOptions = appLanguageOptions();
    final response = await appPigeon.post(
      ApiEndpoints.sendNewMessageStream,
      data: params.toJson(),
      options: Options(
        headers: languageOptions?.headers,
        responseType: ResponseType.stream,
      ),
    );

    final body = response.data;
    if (body is! ResponseBody) {
      throw Exception('Invalid streaming response format');
    }

    yield* _decodeServerSentEvents(body);
  }

  Stream<ChatStreamEvent> _decodeServerSentEvents(ResponseBody body) async* {
    var event = 'message';
    final dataLines = <String>[];

    void resetEvent() {
      event = 'message';
      dataLines.clear();
    }

    ChatStreamEvent? buildEvent() {
      if (dataLines.isEmpty) return null;
      final data = dataLines.join('\n');
      final eventName = event;
      resetEvent();
      return ChatStreamEvent.fromSse(event: eventName, data: data);
    }

    await for (final line
        in utf8.decoder.bind(body.stream).transform(const LineSplitter())) {
      if (line.isEmpty) {
        final streamEvent = buildEvent();
        if (streamEvent != null) {
          yield streamEvent;
        }
        continue;
      }

      if (line.startsWith(':')) {
        continue;
      }

      final separatorIndex = line.indexOf(':');
      final field = separatorIndex == -1
          ? line
          : line.substring(0, separatorIndex);
      var value = separatorIndex == -1
          ? ''
          : line.substring(separatorIndex + 1);
      if (value.startsWith(' ')) {
        value = value.substring(1);
      }

      if (field == 'event') {
        event = value;
      } else if (field == 'data') {
        dataLines.add(value);
      }
    }

    final streamEvent = buildEvent();
    if (streamEvent != null) {
      yield streamEvent;
    }
  }
}
