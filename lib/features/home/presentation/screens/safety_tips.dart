import 'package:chasingharmony_fluttere/features/home/controller/safety_tips_controller.dart';
import 'package:chasingharmony_fluttere/features/home/model/safety_tips_model.dart';
import 'package:chasingharmony_fluttere/features/home/presentation/screens/safety_tips_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafetyTipsScreen extends GetView<SafetyTipsController> {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'nav.safetyTips'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadSafetyTips(showLoader: false),
          child: controller.error.isNotEmpty && controller.items.isEmpty
              ? _buildRefreshableMessageState(controller.error.value)
              : controller.items.isEmpty
              ? _buildRefreshableMessageState('home.noSafetyTips'.tr)
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 250,
                        ),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final tip = controller.items[index];
                      return SafetyTipCard(
                        tip: tip,
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          final tipDetails = await controller.getSafetyTipById(
                            tip.id,
                          );

                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }

                          if (tipDetails == null) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'home.loadSafetyTipFailed'.tr,
                                ),
                              ),
                            );
                            return;
                          }

                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SafetyTipsDetailsScreen(tip: tipDetails),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildRefreshableMessageState(String message) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SafetyTipCard extends StatelessWidget {
  const SafetyTipCard({super.key, required this.tip, required this.onTap});

  final SafetyTipModel tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _TipImage(imagePathOrUrl: tip.displayImageUrl, height: 104),
                    if (tip.featured)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'home.essential'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            tip.summary,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey[700],
                              height: 1.28,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'safetyTip.estimatedRead'.trParams({
                            'minutes': '${tip.estimatedReadMinutes}',
                          }),
                          style: const TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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

class _TipImage extends StatelessWidget {
  const _TipImage({required this.imagePathOrUrl, required this.height});

  final String imagePathOrUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final source = imagePathOrUrl.trim();
    final isNetworkImage =
        source.startsWith('http://') || source.startsWith('https://');

    final isPlaceholder = source.contains('ui-avatars') || 
                          source.contains('placehold') || 
                          source.contains('dummyimage');

    if (source.isEmpty || isPlaceholder) {
      return _fallback();
    }

    if (isNetworkImage) {
      return Image.network(
        source,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    return Image.asset(
      source,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFE8E8E8),
      alignment: Alignment.center,
      child: const Icon(
        Icons.auto_stories,
        size: 90,
        color: Colors.grey,
      ),
    );
  }
}
