

import 'package:chasingharmony_fluttere/core/api_handler/base_repository.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/features/home/model/message_responces_model.dart';
import 'package:chasingharmony_fluttere/features/home/model/send_message_model.dart';

abstract base class MessageInt extends BaseRepository {
  FutureRequest<Success<MessageResponcesModel>> sendMessage(
    SendMessageModel params,
  );
}
