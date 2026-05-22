import 'package:chasingharmony_fluttere/features/messages/model/mode_model.dart';
import 'package:chasingharmony_fluttere/features/messages/services/message_int.dart';
import 'package:get/get.dart';

class ModeSelectController extends GetxController {
  ModeSelectController({required this.messageInt});

  final MessageInt messageInt;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<ModeModel> modeConfig = Rxn<ModeModel>();

  List<String> get feelings => modeConfig.value?.feelings ?? const <String>[];
  List<String> get triggers => modeConfig.value?.triggers ?? const <String>[];
  List<String> get durations => modeConfig.value?.durations ?? const <String>[];
  List<String> get supportTypes =>
      modeConfig.value?.supportTypes ?? const <String>[];
  int get minIntensity => modeConfig.value?.intensity.min ?? 1;
  int get maxIntensity => modeConfig.value?.intensity.max ?? 10;

  @override
  void onInit() {
    super.onInit();
    loadModes();
  }

  Future<void> ensureModesLoaded() async {
    if (isLoading.value) return;
    if (modeConfig.value != null && error.value.isEmpty) return;
    await loadModes(showLoader: modeConfig.value == null);
  }

  Future<void> loadModes({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
    }
    error.value = '';

    final response = await messageInt.getAllMode();
    response.fold(
      (failure) {
        if (modeConfig.value == null) {
          modeConfig.value = null;
        }
        error.value = failure.uiMessage;
      },
      (success) {
        modeConfig.value = success.data;
      },
    );

    if (showLoader) {
      isLoading.value = false;
    }
  }
}
