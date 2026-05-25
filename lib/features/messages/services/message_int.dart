
import 'package:chasingharmony_fluttere/core/api_handler/base_repository.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/features/messages/model/create_chat_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/exesting_chat.dart';
import 'package:chasingharmony_fluttere/features/messages/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/mode_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/recent_chat-model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/send_chat_message_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/select_mood_request_model.dart';
import 'package:chasingharmony_fluttere/features/messages/model/select_mood_responces_model.dart';

abstract base class MessageInt extends BaseRepository {
  FutureRequest<Success<MessageResponseModel>> createChat(
    CreateChatRequestModel params,
  );

  FutureRequest<Success<MessageResponseModel>> sendNewMessage(
    SendChatMessageRequestModel params,
  );

  FutureRequest<Success<ModeModel>> getAllMode();
  FutureRequest<Success<SelectMoodResponsesModel>> selectMood(
    SelectMoodRequestModel params,
  );
  FutureRequest<Success<List<RecentChatModel>>> getRecentMessages();
  FutureRequest<Success<MessageResponseModel>> getSession(String sessionId);

  FutureRequest<Success<ExestingChat>> getExistingChat(String sessionId);
}
