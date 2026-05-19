import 'package:chasingharmony_fluttere/core/api_handler/base_repository.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/features/home/model/safety_tips_model.dart';

abstract base class SafetyInterface extends BaseRepository {
  FutureRequest<Success<List<SafetyTipModel>>> getAllSafetyTips();

  FutureRequest<Success<SafetyTipModel>> getSafetyTipById(String id);
}
