import 'package:chasingharmony_fluttere/features/subscription/controller/subscription_controller.dart';
import 'package:chasingharmony_fluttere/features/subscription/model/subscription_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  late final SubscriptionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SubscriptionController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back to Profile',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/Profile.png', fit: BoxFit.cover),
          SafeArea(
            child: Obx(() {
              final isLoading =
                  _controller.isLoadingPlans.value &&
                  _controller.plans.isEmpty;
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return RefreshIndicator(
                onRefresh: _controller.loadInitial,
                color: const Color(0xFF8B5CF6),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    const Text(
                      'CELY AI Subscription Plans',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose Your Peace - support, clarity, and calm whenever you need it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_controller.plans.isEmpty)
                      _EmptyPlans(onRetry: _controller.loadInitial)
                    else
                      ..._controller.plans.map(
                        (plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _PlanCard(
                            plan: plan,
                            isSelected:
                                _controller.selectedPlanKey.value == plan.key,
                            isCurrent:
                                _controller.currentPlanKey == plan.key,
                            isBusy:
                                _controller.isCheckingOut.value ||
                                _controller.isConfirmingCheckout.value,
                            onSelect: () =>
                                _controller.selectedPlanKey.value = plan.key,
                            onSubscribe: () =>
                                _controller.subscribeToPlan(plan.key),
                          ),
                        ),
                      ),
                    if (_canCancelCurrentPlan) ...[
                      const SizedBox(height: 4),
                      _CancelSubscriptionButton(controller: _controller),
                    ],
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  bool get _canCancelCurrentPlan {
    final currentPlan = _controller.currentPlanKey;
    final subscription = _controller.status.value?.subscription;
    return currentPlan != 'basic' && subscription?.isActive == true;
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.isCurrent,
    required this.isBusy,
    required this.onSelect,
    required this.onSubscribe,
  });

  final SubscriptionPlanModel plan;
  final bool isSelected;
  final bool isCurrent;
  final bool isBusy;
  final VoidCallback onSelect;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111111).withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (plan.isPopular) const _MostPopularBadge(),
                if (isCurrent) const _CurrentBadge(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.displayPrice,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    plan.displayInterval,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFF3F3F46), thickness: 0.7),
            const SizedBox(height: 14),
            ...plan.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF22C55E),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isBusy || isCurrent ? null : onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  disabledBackgroundColor: const Color(0xFF3F3F46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isBusy && isSelected
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isCurrent ? 'Current Plan' : 'Subscribe',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelSubscriptionButton extends StatelessWidget {
  const _CancelSubscriptionButton({required this.controller});

  final SubscriptionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OutlinedButton(
        onPressed: controller.isCancelling.value
            ? null
            : controller.cancelCurrentSubscription,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: controller.isCancelling.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Cancel Subscription'),
      ),
    );
  }
}

class _MostPopularBadge extends StatelessWidget {
  const _MostPopularBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEC4899),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Popular',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF166534),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Current',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EmptyPlans extends StatelessWidget {
  const _EmptyPlans({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Plans are unavailable right now.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
