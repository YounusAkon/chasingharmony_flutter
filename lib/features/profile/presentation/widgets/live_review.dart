import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/review_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveReviewBottomSheet extends StatefulWidget {
  final String productId;

  const LeaveReviewBottomSheet({super.key, required this.productId});

  @override
  State<LeaveReviewBottomSheet> createState() => _LeaveReviewBottomSheetState();
}

class _LeaveReviewBottomSheetState extends State<LeaveReviewBottomSheet> {
  int selectedRating = 0;
  final reviewController = TextEditingController();
  final ReviewController controller = Get.put(
    ReviewController(repository: Get.find()),
  );

  @override
  void initState() {
    super.initState();
    controller.setCanSubmit(false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Text(
            "Leave a Review",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            "How was your order?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          const Text(
            "Please give your rating and also your review.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// ⭐ Rating Stars
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 28,
                ),
                onPressed: () {
                  setState(() => selectedRating = index + 1);
                  controller.setCanSubmit(selectedRating > 0);
                },
              );
            }),
          ),

          const SizedBox(height: 8),

          /// ✍️ Review Field
          TextField(
            controller: reviewController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Write your review...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: RSaveButton(
                key: null,
                width: double.infinity,
                height: 48,
                borderRadius: BorderRadius.circular(12),
                buttonStatusNotifier: controller.submitNotifier,
                saveText: "Submit Review",
                loadingText: "Submitting...",
                doneText: "Submitted",
                errorText: "Submit failed",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                enabledBackgroundColor: const Color(0xFFE8A123),
                loadingBackgroundColor: const Color(0xFFE8A123),
                successBackgroundColor: const Color(0xFFE8A123),
                errorBackgroundColor: const Color(0xFFE8A123),
                disabledBackgroundColor: const Color(0xFFCFAE66),
                onSaveTap: () async {
                  if (selectedRating == 0) {
                    Get.snackbar("Error", "Please select a rating.");
                    controller.setCanSubmit(false);
                    return;
                  }

                  final review = ReviewModel(
                    productId: widget.productId,
                    rating: selectedRating,
                    text: reviewController.text.trim(),
                  );

                  final didSucceed = await controller.submitReview(review);
                  if (!mounted) return;
                  if (!didSucceed) {
                    Future.delayed(const Duration(milliseconds: 700), () {
                      if (mounted) {
                        controller.setCanSubmit(selectedRating > 0);
                      }
                    });
                  }
                },
                onDone: () {
                  if (Get.isBottomSheetOpen ?? false) {
                    Get.back();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
