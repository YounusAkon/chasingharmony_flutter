import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/subscription_models.dart';
import '../repo/subscription_interface.dart';

class SubscriptionController extends GetxController {
  SubscriptionController({required this.repo});

  final SubscriptionInterface repo;

  final RxList<SubscriptionPlanModel> plans = <SubscriptionPlanModel>[].obs;
  final Rxn<SubscriptionStatusModel> status = Rxn<SubscriptionStatusModel>();
  final RxString selectedPlanKey = 'care'.obs;
  final RxString error = ''.obs;
  final RxBool isLoadingPlans = false.obs;
  final RxBool isLoadingStatus = false.obs;
  final RxBool isCheckingOut = false.obs;
  final RxBool isConfirmingCheckout = false.obs;
  final RxBool isCancelling = false.obs;

  String? _lastConfirmedSessionId;

  String get currentPlanKey => status.value?.plan?.key ?? 'basic';

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    await Future.wait([loadPlans(), loadMySubscription()]);
  }

  Future<void> loadPlans() async {
    if (isLoadingPlans.value) return;
    isLoadingPlans.value = true;
    error.value = '';

    final response = await repo.getPlans();
    response.fold(
      (failure) {
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) {
        plans.assignAll(success.data ?? []);
        if (plans.any((plan) => plan.key == currentPlanKey)) {
          selectedPlanKey.value = currentPlanKey;
        } else if (plans.any((plan) => plan.key == 'care')) {
          selectedPlanKey.value = 'care';
        } else if (plans.isNotEmpty) {
          selectedPlanKey.value = plans.first.key;
        }
      },
    );

    isLoadingPlans.value = false;
  }

  Future<void> loadMySubscription() async {
    if (isLoadingStatus.value) return;
    isLoadingStatus.value = true;
    error.value = '';

    final response = await repo.getMySubscription();
    response.fold(
      (failure) {
        error.value = failure.uiMessage;
      },
      (success) {
        status.value = success.data;
        final key = success.data?.plan?.key;
        if (key != null && key.isNotEmpty) selectedPlanKey.value = key;
      },
    );

    isLoadingStatus.value = false;
  }

  Future<void> subscribeToPlan(String planKey) async {
    if (isCheckingOut.value) return;
    selectedPlanKey.value = planKey;
    isCheckingOut.value = true;
    error.value = '';

    final response = await repo.createCheckout(planKey);
    await response.fold(
      (failure) async {
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) async {
        final checkout = success.data;
        if (checkout == null) {
          _showError('Checkout response was empty.');
          return;
        }

        if (!checkout.requiresRedirect) {
          await _refreshAfterSubscriptionChange(success.message);
          return;
        }

        final uri = Uri.tryParse(checkout.checkoutUrl);
        if (uri == null) {
          _showError('Stripe checkout URL is invalid.');
          return;
        }

        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          _showError('Could not open Stripe checkout.');
        }
      },
    );

    isCheckingOut.value = false;
  }

  Future<void> confirmCheckoutSession(String sessionId) async {
    final cleanSessionId = sessionId.trim();
    if (cleanSessionId.isEmpty ||
        isConfirmingCheckout.value ||
        _lastConfirmedSessionId == cleanSessionId) {
      return;
    }

    isConfirmingCheckout.value = true;
    _lastConfirmedSessionId = cleanSessionId;
    error.value = '';

    final response = await repo.confirmCheckoutSuccess(cleanSessionId);
    await response.fold(
      (failure) async {
        error.value = failure.uiMessage;
        _lastConfirmedSessionId = null;
        _showError(failure.uiMessage);
      },
      (success) async {
        status.value = success.data;
        await _refreshProfile();
        _showSuccess(success.message);
      },
    );

    isConfirmingCheckout.value = false;
  }

  Future<void> cancelCurrentSubscription() async {
    if (isCancelling.value) return;
    isCancelling.value = true;
    error.value = '';

    final response = await repo.cancelSubscription();
    await response.fold(
      (failure) async {
        error.value = failure.uiMessage;
        _showError(failure.uiMessage);
      },
      (success) async {
        await _refreshAfterSubscriptionChange(success.message);
      },
    );

    isCancelling.value = false;
  }

  Future<void> _refreshAfterSubscriptionChange(String message) async {
    await loadMySubscription();
    await _refreshProfile();
    _showSuccess(message);
  }

  Future<void> _refreshProfile() async {
    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().getCurrentUserProfile();
    }
  }

  void _showError(String message) {
    if (message.trim().isEmpty) return;
    Get.snackbar(
      'Subscription',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }

  void _showSuccess(String message) {
    if (message.trim().isEmpty) return;
    Get.snackbar(
      'Subscription',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF166534),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }
}
