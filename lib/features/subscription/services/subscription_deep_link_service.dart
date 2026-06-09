import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';

class SubscriptionDeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<SubscriptionDeepLinkService> init() async {
    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (error) => debugPrint('Subscription deep link error: $error'),
    );
    return this;
  }

  void _handleUri(Uri uri) {
    if (uri.scheme != 'celysai' || uri.host != 'subscribe') return;

    if (uri.path == '/success') {
      final sessionId =
          uri.queryParameters['session_id'] ??
          uri.queryParameters['sessionId'] ??
          '';
      if (sessionId.trim().isNotEmpty &&
          Get.isRegistered<SubscriptionController>()) {
        Get.find<SubscriptionController>().confirmCheckoutSession(sessionId);
      }
      return;
    }

    if (uri.path == '/cancel') {
      Get.snackbar(
        'Subscription',
        'Stripe checkout was cancelled.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF27272A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
