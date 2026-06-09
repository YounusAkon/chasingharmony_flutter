class SubscriptionPlanModel {
  const SubscriptionPlanModel({
    required this.key,
    required this.name,
    required this.price,
    required this.priceCents,
    required this.currency,
    required this.interval,
    required this.isFree,
    required this.isPopular,
    required this.features,
    required this.limits,
  });

  final String key;
  final String name;
  final String price;
  final int priceCents;
  final String currency;
  final String interval;
  final bool isFree;
  final bool isPopular;
  final List<String> features;
  final SubscriptionLimits limits;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      key: _asString(json['key']),
      name: _asString(json['name']),
      price: _asString(json['price']),
      priceCents: _asInt(json['priceCents']),
      currency: _asString(json['currency'], fallback: 'usd'),
      interval: _asString(json['interval'], fallback: 'month'),
      isFree: _asBool(json['isFree']),
      isPopular: _asBool(json['isPopular']),
      features: _asStringList(json['features']),
      limits: SubscriptionLimits.fromJson(_asMap(json['limits'])),
    );
  }

  String get displayPrice => isFree ? r'$0' : '\$${price.isEmpty ? (priceCents / 100).toStringAsFixed(2) : price}';
  String get displayInterval => '/$interval';
}

class SubscriptionLimits {
  const SubscriptionLimits({
    required this.dailyMessageLimit,
    required this.moodCheckIn,
    required this.guidedExercises,
    required this.aiJournaling,
    required this.personalizedAI,
    required this.priorityAI,
    required this.wellnessPlans,
  });

  final int? dailyMessageLimit;
  final bool moodCheckIn;
  final bool guidedExercises;
  final bool aiJournaling;
  final bool personalizedAI;
  final bool priorityAI;
  final bool wellnessPlans;

  factory SubscriptionLimits.fromJson(Map<String, dynamic> json) {
    return SubscriptionLimits(
      dailyMessageLimit: json['dailyMessageLimit'] is num
          ? (json['dailyMessageLimit'] as num).toInt()
          : null,
      moodCheckIn: _asBool(json['moodCheckIn']),
      guidedExercises: _asBool(json['guidedExercises']),
      aiJournaling: _asBool(json['aiJournaling']),
      personalizedAI: _asBool(json['personalizedAI']),
      priorityAI: _asBool(json['priorityAI']),
      wellnessPlans: _asBool(json['wellnessPlans']),
    );
  }
}

class SubscriptionRecordModel {
  const SubscriptionRecordModel({
    required this.id,
    required this.plan,
    required this.status,
    required this.stripeSubscriptionId,
    required this.currentPeriodEnd,
    required this.cancelledAt,
  });

  final String id;
  final String plan;
  final String status;
  final String stripeSubscriptionId;
  final DateTime? currentPeriodEnd;
  final DateTime? cancelledAt;

  bool get isActive => status.toLowerCase() == 'active';

  factory SubscriptionRecordModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionRecordModel(
      id: _asString(json['_id'] ?? json['id']),
      plan: _asString(json['plan']),
      status: _asString(json['status']),
      stripeSubscriptionId: _asString(json['stripeSubscriptionId']),
      currentPeriodEnd: _asDate(json['currentPeriodEnd']),
      cancelledAt: _asDate(json['cancelledAt']),
    );
  }
}

class SubscriptionStatusModel {
  const SubscriptionStatusModel({
    required this.plan,
    required this.subscription,
  });

  final SubscriptionPlanModel? plan;
  final SubscriptionRecordModel? subscription;

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    final data = _responseData(json);
    final planJson = data['plan'];
    final subJson = data['subscription'] ?? data['activeSubscription'];
    return SubscriptionStatusModel(
      plan: planJson is Map
          ? SubscriptionPlanModel.fromJson(Map<String, dynamic>.from(planJson))
          : null,
      subscription: subJson is Map
          ? SubscriptionRecordModel.fromJson(Map<String, dynamic>.from(subJson))
          : null,
    );
  }
}

class CheckoutSessionModel {
  const CheckoutSessionModel({
    required this.sessionId,
    required this.checkoutUrl,
    required this.subscriptionId,
    required this.planKey,
  });

  final String sessionId;
  final String checkoutUrl;
  final String subscriptionId;
  final String planKey;

  bool get requiresRedirect => checkoutUrl.trim().isNotEmpty;

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) {
    final data = _responseData(json);
    return CheckoutSessionModel(
      sessionId: _asString(data['sessionId']),
      checkoutUrl: _asString(data['checkoutUrl']),
      subscriptionId: _asString(data['subscriptionId']),
      planKey: _asString(data['plan']),
    );
  }
}

Map<String, dynamic> _responseData(Map<String, dynamic> json) {
  final data = json['data'];
  return data is Map ? Map<String, dynamic>.from(data) : json;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
  return false;
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return const <String>[];
  return value.map((item) => item.toString()).where((item) => item.trim().isNotEmpty).toList();
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
