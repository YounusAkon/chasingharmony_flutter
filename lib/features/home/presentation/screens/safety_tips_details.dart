import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/home/controller/safety_tips_controller.dart';
import 'package:chasingharmony_fluttere/features/home/model/safety_tips_model.dart';
import 'package:chasingharmony_fluttere/features/home/services/home_sercices/home_interface.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/message_controller.dart';
class SafetyTipsDetailsScreen extends StatefulWidget {
  const SafetyTipsDetailsScreen({super.key, required this.tip});

  final SafetyTipModel tip;

  @override
  State<SafetyTipsDetailsScreen> createState() =>
      _SafetyTipsDetailsScreenState();
}

class _SafetyTipsDetailsScreenState extends State<SafetyTipsDetailsScreen> {
  late SafetyTipModel _tip;
  late final SafetyTipsController _safetyTipsController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tip = widget.tip;
    _safetyTipsController = Get.find<SafetyTipsController>();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final detail = await _safetyTipsController.getSafetyTipById(widget.tip.id);

    if (!mounted) return;

    if (detail != null) {
      setState(() {
        _tip = detail;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // MessageController _messageController() {
  //   if (!Get.isRegistered<MessageController>()) {
  //     Get.put<MessageController>(
  //       MessageController(
  //         homeInterface: Get.find<HomeInterface>(),
  //         historyInt: Get.find<HistoryInt>(),
  //       ),
  //       permanent: true,
  //     );
  //   }
  //   return Get.find<MessageController>();
  // }

  @override
  Widget build(BuildContext context) {
    final displayTip = _isLoading ? widget.tip : _tip;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          displayTip.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (displayTip.category.trim().isNotEmpty)
                          _buildMetaChip(displayTip.category),
                        if (displayTip.estimatedReadMinutes > 0)
                          _buildMetaChip(
                            'safetyTip.estimatedRead'.trParams({
                              'minutes': '${displayTip.estimatedReadMinutes}',
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayTip.summary,
                      style: const TextStyle(fontSize: 15, height: 1.45),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildImage(
                        displayTip.coverImageUrl.trim().isNotEmpty
                            ? displayTip.coverImageUrl
                            : displayTip.displayImageUrl,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (displayTip.contentSections.isNotEmpty) ...[
                      ...displayTip.contentSections.map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildContentSection(
                            heading: section.heading,
                            body: section.body,
                          ),
                        ),
                      ),
                    ] else
                      _buildContentSection(
                        heading: 'safetyTip.overview'.tr,
                        body: displayTip.summary,
                      ),
                    if (displayTip.doList.isNotEmpty)
                      _buildChecklistSection(
                        title: 'safetyTip.do'.tr,
                        points: displayTip.doList,
                        accentColor: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    if (displayTip.doList.isNotEmpty &&
                        displayTip.dontList.isNotEmpty)
                      const SizedBox(height: 14),
                    if (displayTip.dontList.isNotEmpty)
                      _buildChecklistSection(
                        title: 'safetyTip.dont'.tr,
                        points: displayTip.dontList,
                        accentColor: Colors.red,
                        icon: Icons.cancel,
                      ),
                    const SizedBox(height: 24),
                    // SafeArea(
                    //   top: false,
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(10),
                    //     onTap: () async {
                    //       final messageController = _messageController();
                    //       showDialog<void>(
                    //         context: context,
                    //         barrierDismissible: false,
                    //         builder: (_) => const Center(
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       );

                    //       await messageController.openSafetyTipChat(
                    //         tipId: displayTip.id,
                    //         tipTitle: displayTip.title,
                    //       );

                    //       if (context.mounted) {
                    //         Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
                    //         Navigator.of(context).pop(); // Close details screen to return to AppGround
                    //         Get.find<AppGroundController>().changeTab(1); // Switch to Chat tab
                    //       }
                    //     },
                    //     child: Container(
                    //       height: 58,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         gradient: const LinearGradient(
                    //           begin: Alignment.topLeft,
                    //           end: Alignment.bottomRight,
                    //           colors: [Color(0xFFB80F1D), Color(0xFFE33A3A)],
                    //         ),
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Image.asset(
                    //             'assets/image/message.png',
                    //             width: 34,
                    //             height: 34,
                    //           ),
                    //           const SizedBox(width: 10),
                    //           Text(
                    //             'safetyTip.askAi'.tr,
                    //             style: const TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 34 * 0.5,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF555555),
        ),
      ),
    );
  }

  Widget _buildImage(String source) {
    final normalized = source.trim();
    final isNetworkImage =
        normalized.startsWith('http://') || normalized.startsWith('https://');

    final isPlaceholder = normalized.contains('ui-avatars') || 
                          normalized.contains('placehold') || 
                          normalized.contains('dummyimage');

    if (normalized.isEmpty || isPlaceholder) return _imageFallback();

    if (isNetworkImage) {
      return Image.network(
        normalized,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imageFallback(),
      );
    }

    return Image.asset(
      normalized,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(
        Icons.auto_stories,
        size: 90,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildContentSection({required String heading, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.trim().isEmpty ? 'safetyTip.section'.tr : heading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202020),
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 14.5, height: 1.35)),
        ],
      ),
    );
  }

  Widget _buildChecklistSection({
    required String title,
    required List<String> points,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: accentColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 14.5, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
