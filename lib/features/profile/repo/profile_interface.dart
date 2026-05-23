import 'dart:io';

import 'package:chasingharmony_fluttere/core/api_handler/base_repository.dart';
import '../../../core/api_handler/success.dart';
import '../../../core/helpers/typedefs.dart';
import '../model/chnage_password_model.dart';
import '../model/edit_profile_model.dart';
import '../model/profile_model.dart';
import '../model/review_model.dart';

abstract base class ProfilInterface extends BaseRepository {
  FutureRequest<Success<ProfileModel>> getProfile(String id);
  FutureRequest<Success<ProfileModel>> updateProfile(EditProfileModel param);
  FutureRequest<Success<Avatar>> uploadAvatar(File imageFile);
  FutureRequest<Success> changePassword(ChangePasswordModel param);
  // FutureRequest<Success<void>> addReview(ReviewModel review);
}
