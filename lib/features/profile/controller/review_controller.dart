// import 'package:chasingharmony_fluttere/core/notifiers/button_status_notifier.dart';
// import 'package:chasingharmony_fluttere/features/profile/model/review_model.dart';
// import 'package:chasingharmony_fluttere/features/profile/repo/profile_interface.dart';
// import 'package:get/get.dart';

// class ReviewController extends GetxController {
//   ReviewController({required this.repository});

//   final ProfilInterface repository;

//   final ProcessStatusNotifier submitNotifier = ProcessStatusNotifier(
//     initialStatus: DisabledStatus(),
//   );

//   var isLoading = false.obs;

//   Future<bool> submitReview(ReviewModel review) async {
//     bool didSucceed = false;
//     try {
//       isLoading.value = true;
//       submitNotifier.setLoading();

//       final result = await repository.addReview(review);

//       result.fold(
//         (failure) {
//           submitNotifier.setError();
//           Get.snackbar("Error", failure.uiMessage);
//         },
//         (success) {
//           didSucceed = true;
//           submitNotifier.setSuccess(message: success.message);
//           Get.snackbar("Success", success.message);
//         },
//       );
//     } finally {
//       isLoading.value = false;
//     }

//     return didSucceed;
//   }

//   void setCanSubmit(bool canSubmit) {
//     if (submitNotifier.status is LoadingStatus) return;
//     if (canSubmit) {
//       submitNotifier.setEnabled();
//     } else {
//       submitNotifier.setDisabled();
//     }
//   }

//   @override
//   void onClose() {
//     submitNotifier.dispose();
//     super.onClose();
//   }
// }
