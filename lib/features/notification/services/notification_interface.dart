import 'package:chasingharmony_fluttere/core/api_handler/base_repository.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/features/notification/model/notification_modl.dart';

abstract base class NotificationInterface extends BaseRepository {
  FutureRequest<Success<List<NotificationModel>>> getNotifications();
  FutureRequest<Success<void>> markNotificationAsRead({
    required String notificationId,
  });
}
