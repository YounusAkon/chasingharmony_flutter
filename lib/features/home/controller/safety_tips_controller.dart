import 'package:chasingharmony_fluttere/features/home/model/safety_tips_model.dart';
import 'package:chasingharmony_fluttere/features/home/services/safety_services/saftey_interface.dart';
import 'package:get/get.dart';

class SafetyTipsController extends GetxController {
  SafetyTipsController({required this.safetyInterface});

  final SafetyInterface safetyInterface;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<SafetyTipModel> items = <SafetyTipModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSafetyTips();
  }

  Future<void> loadSafetyTips({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
    }
    error.value = '';

    final response = await safetyInterface.getAllSafetyTips();
    response.fold(
      (failure) {
        items.clear();
        error.value = failure.uiMessage;
      },
      (success) {
        items.assignAll(success.data ?? const <SafetyTipModel>[]);
      },
    );

    if (showLoader) {
      isLoading.value = false;
    }
  }

  Future<SafetyTipModel?> getSafetyTipById(String id) async {
    final response = await safetyInterface.getSafetyTipById(id);

    SafetyTipModel? detail;
    response.fold(
      (failure) {
        detail = null;
      },
      (success) {
        detail = success.data;
      },
    );

    return detail;
  }
}
