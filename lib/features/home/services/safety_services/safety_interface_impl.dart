// import 'package:app_pigeon/app_pigeon.dart';
// import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
// import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
// import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
// import 'package:chasingharmony_fluttere/core/network/app_language_options.dart';
// import 'package:chasingharmony_fluttere/features/home/model/safety_tips_model.dart';
// import 'package:chasingharmony_fluttere/features/home/services/safety_services/saftey_interface.dart';


// final class SafetyInterfaceImpl extends SafetyInterface {
//   SafetyInterfaceImpl({required this.appPigeon});
//   final AppPigeon appPigeon;

//   @override
//   FutureRequest<Success<List<SafetyTipModel>>> getAllSafetyTips() async {
//     return await asyncTryCatch(
//       tryFunc: () async {
//         final response = await appPigeon.get(
//           ApiEndpoints.getAllSafetyTips,
//           queryParameters: appLanguageQueryParameters(),
//         );
//         final body = response.data;
//         if (body is! Map) {
//           return Success(data: const <SafetyTipModel>[], message: 'Success');
//         }

//         final root = Map<String, dynamic>.from(body);
//         final data = root['data'] is List ? root['data'] as List : const [];
//         final safetyTips = data
//             .whereType<Map>()
//             .map((e) => SafetyTipModel.fromJson(Map<String, dynamic>.from(e)))
//             .toList();

//         final message = root['message']?.toString() ?? 'Success';
//         return Success<List<SafetyTipModel>>(
//           data: safetyTips,
//           message: message,
//         );
//       },
//     );
//   }

//   @override
//   FutureRequest<Success<SafetyTipModel>> getSafetyTipById(String id) async {
//     return await asyncTryCatch(
//       tryFunc: () async {
//         final response = await appPigeon.get(
//           ApiEndpoints.getSafetyTipById(id),
//           queryParameters: appLanguageQueryParameters(),
//         );
//         final body = response.data;
//         if (body is! Map) {
//           throw Exception('Invalid response format');
//         }

//         final root = Map<String, dynamic>.from(body);
//         if (root['data'] is! Map) {
//           throw Exception('No data in response');
//         }

//         final data = Map<String, dynamic>.from(root['data'] as Map);
//         final SafetyTipModel safetyTipModel = SafetyTipModel.fromJson(data);
//         final message = root["message"]?.toString() ?? "Success";
//         return Success(data: safetyTipModel, message: message);
//       },
//     );
//   }
// }
