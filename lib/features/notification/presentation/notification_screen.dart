import 'package:chasingharmony_fluttere/features/notification/model/notification_modl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class NotificationsScreen extends GetView<NotificationController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "notification.title".tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty && controller.notifications.isEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: controller.getNotifications,
          );
        }

        if (controller.notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.getNotifications,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(height: 240),
                Center(
                  child: Text(
                    "notification.none".tr,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getNotifications,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 218, 225),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "notification.readAll".tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...controller.notifications.map(notificationItem),
            ],
          ),
        );
      }),
    );
  }

  /// Notification Item
  Widget notificationItem(NotificationModel data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: data.isUnread ? const Color(0xFFEAF3FF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => controller.onNotificationTap(data),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.displayTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.displayMessage,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        maxLines: controller.isNotificationExpanded(data)
                            ? null
                            : 1,
                        overflow: controller.isNotificationExpanded(data)
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// Time
                Text(
                  controller.formatNotificationTime(data.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: data.isUnread ? Colors.black87 : Colors.black54,
                    fontWeight: data.isUnread
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8A123),
                foregroundColor: Colors.white,
              ),
              child: Text('common.retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
