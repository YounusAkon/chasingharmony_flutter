// import 'package:chasingharmony_fluttere/features/history/interface/history_int.dart';
// import 'package:chasingharmony_fluttere/features/home/services/home_sercices/home_interface.dart';
// import 'package:chasingharmony_fluttere/features/messages/controller/message_controller.dart';
// import 'package:chasingharmony_fluttere/features/messages/presentation/widget/message_bubble.dart';
// import 'package:chasingharmony_fluttere/features/messages/presentation/widget/message_topic_chip.dart';
// import 'package:chasingharmony_fluttere/features/onbording/common/app_logo.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MessageScreen extends StatelessWidget {
//   const MessageScreen({super.key});

//   // MessageController _controller() {
//   //   if (!Get.isRegistered<MessageController>()) {
//   //     Get.put<MessageController>(
//   //       MessageController(
//   //         homeInterface: Get.find<HomeInterface>(),
//   //         historyInt: Get.find<HistoryInt>(),
//   //       ),
//   //       permanent: true,
//   //     );
//   //   }
//   //   return Get.find<MessageController>();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final controller = _controller();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _MessageHeader(),
//             Obx(
//               () => SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Row(
//                   children: controller.emergencyTopics.map((topic) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: MessageTopicChip(
//                         label: topic.labelKey.tr,
//                         icon: topic.icon,
//                         isSelected:
//                             controller.selectedEmergencyKey.value == topic.key,
//                         onTap: () => controller.selectEmergency(topic.key),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Obx(
//               () => SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Row(
//                   children: controller.quickPrompts.map((prompt) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: ActionChip(
//                         label: Text(
//                           prompt,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         backgroundColor: const Color(0xFFF9E6E7),
//                         side: const BorderSide(color: Color(0xFFE7AEB1)),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         onPressed: controller.isSending.value
//                             ? null
//                             : () => controller.sendQuickPrompt(prompt),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: Obx(
//                 () => ListView.separated(
//                   controller: controller.scrollController,
//                   padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
//                   itemBuilder: (context, index) {
//                     final message = controller.messages[index];
//                     return MessageBubble(
//                       message: message,
//                       onRetry: message.canRetry
//                           ? () => controller.retryMessage(message)
//                           : null,
//                     );
//                   },
//                   separatorBuilder: (_, _) => const SizedBox(height: 8),
//                   itemCount: controller.messages.length,
//                 ),
//               ),
//             ),
//             _ChatInput(controller: controller),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MessageHeader extends StatelessWidget {
//   const _MessageHeader();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AppLogo(height: 32, width: 100),

//           Text(
//             'chat.title'.tr,
//             style: const TextStyle(
//               color: Color(0xFF202020),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ChatInput extends StatelessWidget {
//   const _ChatInput({required this.controller});

//   final MessageController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),

//         child: Row(
//           children: [
//             // Icon(Icons.more_horiz_rounded, color: Colors.grey.shade600),
//             // const SizedBox(width: 8),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: const Color(0xFFD3D3D3)),
//                 ),
//                 child: TextField(
//                   controller: controller.inputController,
//                   onSubmitted: (_) => controller.sendTypedMessage(),
//                   enabled: !controller.isSending.value,
//                   decoration: InputDecoration(
//                     isDense: true,
//                     border: InputBorder.none,
//                     hintText: 'home.typeMessage'.tr,
//                     hintStyle: const TextStyle(
//                       color: Color(0xFF9A9A9A),
//                       fontSize: 14,
//                     ),
//                   ),
//                   style: const TextStyle(
//                     color: Color(0xFF1F1F1F),
//                     fontSize: 14,
//                   ),
//                   textInputAction: TextInputAction.send,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: controller.isSending.value
//                   ? null
//                   : () => controller.sendTypedMessage(),
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFE3E6ED),
//                   shape: BoxShape.circle,
//                 ),
//                 child: controller.isSending.value
//                     ? const Padding(
//                         padding: EdgeInsets.all(9),
//                         child: CircularProgressIndicator(
//                           strokeWidth: 1.6,
//                           color: Color(0xFF5A6472),
//                         ),
//                       )
//                     : const Icon(
//                         Icons.send,
//                         size: 22,
//                         color: Color(0xFF5A6472),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
