import 'package:chasingharmony_fluttere/core/api_handler/base_repository.dart';
import 'package:chasingharmony_fluttere/core/api_handler/success.dart';
import 'package:chasingharmony_fluttere/core/helpers/typedefs.dart';
import '../model/subscription_models.dart';

abstract base class SubscriptionInterface extends BaseRepository {
  FutureRequest<Success<List<SubscriptionPlanModel>>> getPlans();
  FutureRequest<Success<SubscriptionStatusModel>> getMySubscription();
  FutureRequest<Success<CheckoutSessionModel>> createCheckout(String planKey);
  FutureRequest<Success<SubscriptionStatusModel>> confirmCheckoutSuccess(
    String sessionId,
  );
  FutureRequest<Success<SubscriptionStatusModel>> cancelSubscription();
}
