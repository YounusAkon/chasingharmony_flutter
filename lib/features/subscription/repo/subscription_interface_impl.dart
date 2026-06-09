import 'package:app_pigeon/app_pigeon.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/constants/api_endpoints.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import 'package:chasingharmony_fluttere/core/network/app_language_options.dart';
import '../model/subscription_models.dart';
import 'subscription_interface.dart';

final class SubscriptionInterfaceImpl extends SubscriptionInterface {
  SubscriptionInterfaceImpl({required this.appPigeon});

  final AppPigeon appPigeon;

  Map<String, dynamic> _asMap(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    throw Exception('Invalid subscription response format');
  }

  String _message(Map<String, dynamic> body) {
    return body['message']?.toString() ?? 'Success';
  }

  @override
  FutureRequest<Success<List<SubscriptionPlanModel>>> getPlans() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.subscriptionPlans);
        final body = _asMap(response.data);
        final data = _asMap(body['data']);
        final plans = data['plans'] is List
            ? (data['plans'] as List)
                  .whereType<Map>()
                  .map(
                    (item) => SubscriptionPlanModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
            : <SubscriptionPlanModel>[];

        return Success<List<SubscriptionPlanModel>>(
          data: plans,
          message: _message(body),
        );
      },
    );
  }

  @override
  FutureRequest<Success<SubscriptionStatusModel>> getMySubscription() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.mySubscription);
        final body = _asMap(response.data);
        return Success<SubscriptionStatusModel>(
          data: SubscriptionStatusModel.fromJson(body),
          message: _message(body),
        );
      },
    );
  }

  @override
  FutureRequest<Success<CheckoutSessionModel>> createCheckout(
    String planKey,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.createSubscriptionCheckout,
          data: {
            'planKey': planKey,
            'successUrl': 'celysai://subscribe/success',
            'cancelUrl': 'celysai://subscribe/cancel',
          },
          options: appLanguageOptions(),
        );
        final body = _asMap(response.data);
        return Success<CheckoutSessionModel>(
          data: CheckoutSessionModel.fromJson(body),
          message: _message(body),
        );
      },
    );
  }

  @override
  FutureRequest<Success<SubscriptionStatusModel>> confirmCheckoutSuccess(
    String sessionId,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.confirmSubscriptionSuccess,
          data: {'sessionId': sessionId},
          options: appLanguageOptions(),
        );
        final body = _asMap(response.data);
        return Success<SubscriptionStatusModel>(
          data: SubscriptionStatusModel.fromJson(body),
          message: _message(body),
        );
      },
    );
  }

  @override
  FutureRequest<Success<SubscriptionStatusModel>> cancelSubscription() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.cancelSubscription,
          data: const <String, dynamic>{},
          options: appLanguageOptions(),
        );
        final body = _asMap(response.data);
        return Success<SubscriptionStatusModel>(
          data: SubscriptionStatusModel.fromJson(body),
          message: _message(body),
        );
      },
    );
  }
}
