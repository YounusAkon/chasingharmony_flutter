import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/core/network/app_language_options.dart';
import 'package:chasingharmony_fluttere/core/utils/helpers/format_response_data.dart';
import 'package:chasingharmony_fluttere/features/notification/model/notification_modl.dart';
import 'package:chasingharmony_fluttere/features/notification/services/notification_interface.dart';

final class NotificationInterfaceImpl extends NotificationInterface {
  NotificationInterfaceImpl({required this.appPigeon});
  final AppPigeon appPigeon;

  @override
  FutureRequest<Success<List<NotificationModel>>> getNotifications() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getAllNotifications);
        final notificationsJson = _extractNotifications(response.data);

        final notifications = notificationsJson
            .whereType<Map>()
            .map(
              (e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();

        return Success(
          data: notifications,
          message: extractSuccessMessage(response),
        );
      },
    );
  }

  @override
  FutureRequest<Success<void>> markNotificationAsRead({
    required String notificationId,
  }) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.patch(
          ApiEndpoints.markNotificationAsRead(notificationId: notificationId),
          options: appLanguageOptions(),
        );

        return Success<void>(
          data: null,
          message: extractSuccessMessage(response),
        );
      },
    );
  }

  List<dynamic> _extractNotifications(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return const [];

    final data = body['data'];
    if (data is List) return data;

    if (data is Map) {
      if (data['notifications'] is List) {
        return data['notifications'] as List<dynamic>;
      }
      if (data['notification'] is List) {
        return data['notification'] as List<dynamic>;
      }
    }

    if (body['notifications'] is List) {
      return body['notifications'] as List<dynamic>;
    }

    if (body['notification'] is List) {
      return body['notification'] as List<dynamic>;
    }

    return const [];
  }
}
