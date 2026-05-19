import 'dart:async';
import 'package:chasingharmony_fluttere/features/notification/model/notification_modl.dart';
import 'package:chasingharmony_fluttere/features/notification/services/notification_interface.dart';
import 'package:flutter/material.dart';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  NotificationController({required this.notificationInterface});

  final NotificationInterface notificationInterface;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxSet<String> expandedNotificationKeys = <String>{}.obs;
  final List<StreamSubscription<dynamic>> _socketSubscriptions = [];

  static const List<String> _socketNotificationChannels = [
    'newNotification',
    'notification',
    'new_notification',
    'userNotification',
  ];

  @override
  void onInit() {
    super.onInit();
    getNotifications();
    _bindSocket();
  }

  Future<void> getNotifications({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
      error.value = '';
    }

    final response = await notificationInterface.getNotifications();
    response.fold(
      (failure) {
        if (showLoader) {
          notifications.clear();
          error.value = failure.uiMessage;
        } else {
          debugPrint(
            'Notification refresh failed from socket event: ${failure.fullError}',
          );
        }
      },
      (success) {
        final allNotifications = List<NotificationModel>.from(
          success.data ?? const <NotificationModel>[],
        );
        allNotifications.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        notifications.assignAll(allNotifications);
        expandedNotificationKeys.clear();
      },
    );

    if (showLoader) {
      isLoading.value = false;
    }
  }

  List<NotificationModel> get newNotifications =>
      notifications.where((e) => e.isUnread).toList();

  List<NotificationModel> get earlierNotifications =>
      notifications.where((e) => !e.isUnread).toList();

  int get unreadCount => notifications.where((e) => e.isUnread).length;

  Future<void> onNotificationTap(NotificationModel notification) async {
    _toggleExpanded(notification);
    if (!notification.isUnread) return;

    _setReadStateLocally(notification: notification, isRead: true);

    final id = (notification.id ?? '').trim();
    if (id.isEmpty) return;

    final response = await notificationInterface.markNotificationAsRead(
      notificationId: id,
    );

    response.fold((failure) {
      debugPrint(
        'Failed to mark notification as read for id=$id: ${failure.fullError}',
      );
    }, (_) {});
  }

  void _bindSocket() {
    if (!Get.isRegistered<AppPigeon>()) return;

    _cancelSocketSubscriptions();
    final appPigeon = Get.find<AppPigeon>();

    for (final channel in _socketNotificationChannels) {
      final sub = appPigeon.listen(channel).listen(_handleSocketPayload);
      _socketSubscriptions.add(sub);
    }
  }

  void _handleSocketPayload(dynamic payload) {
    final notification = _extractNotificationFromSocketPayload(payload);

    if (notification != null) {
      _upsertIncomingNotification(notification);
      return;
    }

    // Fallback to API refresh when payload shape is unknown
    getNotifications(showLoader: false);
  }

  NotificationModel? _extractNotificationFromSocketPayload(dynamic payload) {
    if (payload is! Map) return null;
    final root = Map<String, dynamic>.from(payload);

    Map<String, dynamic>? candidate;

    if (_looksLikeNotificationMap(root)) {
      candidate = root;
    } else if (root['notification'] is Map) {
      candidate = Map<String, dynamic>.from(root['notification']);
    } else if (root['data'] is Map) {
      final data = Map<String, dynamic>.from(root['data']);
      if (_looksLikeNotificationMap(data)) {
        candidate = data;
      } else if (data['notification'] is Map) {
        candidate = Map<String, dynamic>.from(data['notification']);
      }
    }

    if (candidate == null) return null;
    return NotificationModel.fromJson(candidate);
  }

  bool _looksLikeNotificationMap(Map<String, dynamic> map) {
    return map.containsKey('id') ||
        map.containsKey('_id') ||
        map.containsKey('title') ||
        map.containsKey('body') ||
        map.containsKey('message') ||
        map.containsKey('read') ||
        map.containsKey('createdAt');
  }

  void _upsertIncomingNotification(NotificationModel incoming) {
    final id = (incoming.id ?? '').trim();

    if (id.isNotEmpty) {
      final index = notifications.indexWhere((item) => item.id == id);
      if (index != -1) {
        notifications[index] = incoming;
      } else {
        notifications.insert(0, incoming);
      }
    } else {
      notifications.insert(0, incoming);
    }

    notifications.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    notifications.refresh();
  }

  bool isNotificationExpanded(NotificationModel notification) {
    return expandedNotificationKeys.contains(_notificationKey(notification));
  }

  void _setReadStateLocally({
    required NotificationModel notification,
    required bool isRead,
  }) {
    final id = (notification.id ?? '').trim();

    final index = notifications.indexWhere((item) {
      if (id.isNotEmpty) {
        return item.id == id;
      }
      return identical(item, notification);
    });

    if (index == -1) return;

    notifications[index].isRead = isRead;
    notifications.refresh();
  }

  void _toggleExpanded(NotificationModel notification) {
    final key = _notificationKey(notification);
    if (expandedNotificationKeys.contains(key)) {
      expandedNotificationKeys.remove(key);
    } else {
      expandedNotificationKeys.add(key);
    }
    expandedNotificationKeys.refresh();
  }

  String _notificationKey(NotificationModel notification) {
    final id = (notification.id ?? '').trim();
    if (id.isNotEmpty) return id;

    return '${notification.createdAt?.millisecondsSinceEpoch ?? 0}-${notification.title ?? ''}-${notification.message ?? ''}';
  }

  String formatNotificationTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final localTime = dateTime.toLocal();
    final now = DateTime.now();
    final diff = now.difference(localTime);

    if (diff.isNegative) {
      return DateFormat('dd MMM').format(localTime);
    }
    if (diff.inMinutes < 1) {
      return 'Just now';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hr';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} d';
    }

    return DateFormat('dd MMM, hh:mm a').format(localTime);
  }

  void _cancelSocketSubscriptions() {
    for (final sub in _socketSubscriptions) {
      sub.cancel();
    }
    _socketSubscriptions.clear();
  }

  @override
  void onClose() {
    _cancelSocketSubscriptions();
    super.onClose();
  }
}
