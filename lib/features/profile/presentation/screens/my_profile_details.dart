import 'package:chasingharmony_fluttere/core/common/widget/reactive_button/save_button.dart';
import 'package:chasingharmony_fluttere/core/notifiers/snackbar_notifier.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/edit_profile_controller.dart';
import 'package:chasingharmony_fluttere/features/profile/controller/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDetailsScreen extends GetView<ProfileController> {
  const MyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editController = Get.find<ProfileEditController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        surfaceTintColor: const Color(0xFFF5F5F5),
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          'profile.editProfile'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
            fontSize: 22,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    _profileImage(
                      controller.profile.value?.avatar?.url,
                      editController,
                    ),
                    const SizedBox(height: 22),
                    _fieldLabel('profile.userName'.tr),
                    _buildTextField(
                      controller: editController.usernameController,
                      hintText: 'profile.enterName'.tr,
                    ),
                    // const SizedBox(height: 14),
                    // _fieldLabel('Last Name'),
                    // _buildTextField(
                    //   controller: editController.lastNameController,
                    //   hintText: 'Enter your last name',
                    // ),
                    // const SizedBox(height: 14),
                    // _fieldLabel('Phone Number'),
                    // _buildTextField(
                    //   controller: editController.phoneController,
                    //   hintText: 'Enter your phone number',
                    //   keyboardType: TextInputType.phone,
                    // ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: RSaveButton(
                        key: null,
                        width: double.infinity,
                        height: 48,
                        buttonStatusNotifier:
                            editController.processStatusNotifier,
                        saveText: "common.save".tr,
                        loadingText: "language.saving".tr,
                        doneText: "language.saved".tr,
                        errorText: "language.saveFailed".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        onSaveTap: () {
                          if (editController.usernameController.text
                              .trim()
                              .isEmpty) {
                            SnackbarNotifier(
                              context: context,
                            ).notifyError(message: 'User name is required');
                            return;
                          }

                          editController.updateProfile(
                            snackbarNotifier: SnackbarNotifier(
                              context: context,
                            ),
                          );
                        },
                        onDone: () {},
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF303030),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF8F8F8F),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD8DCE0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD8DCE0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBABFC5), width: 1.2),
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF1F1F1F),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _profileImage(String? imageUrl, ProfileEditController editController) {
    final imageFile = editController.pickedImage.value;
    final hasNetworkImage = imageUrl != null && imageUrl.isNotEmpty;
    final ImageProvider<Object>? imageProvider = imageFile != null
        ? FileImage(imageFile)
        : (hasNetworkImage ? NetworkImage(imageUrl) : null);

    return Center(
      child: SizedBox(
        width: 122,
        height: 122,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CircleAvatar(
                backgroundColor: const Color(0xFFE1E1E1),
                backgroundImage: imageProvider,
                child: imageFile == null && !hasNetworkImage
                    ? const Icon(
                        Icons.person,
                        size: 54,
                        color: Color(0xFF8A8A8A),
                      )
                    : null,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 2,
              child: GestureDetector(
                onTap: editController.pickImageFromGallery,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F67C7),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                    size: 17,
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
