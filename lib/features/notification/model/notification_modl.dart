class NotificationModel {
  String? id;
  String? userId;
  String? title;
  String? message;
  String? type;
  bool? isRead;
  DateTime? createdAt;

  Actor? actor;
  OrderModel? order;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.actor,
    this.order,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _asString(json['id']) ?? _asString(json['_id']),
      userId: _asString(json['userId']),
      title: _asString(json['title']),
      message: _asString(json['body']) ?? _asString(json['message']),
      type: _asString(json['type']),
      isRead: _asBool(json['read']) ?? _asBool(json['isRead']),
      createdAt: _tryParseDateTime(json['createdAt']),

      actor: json['actor'] is Map<String, dynamic>
          ? Actor.fromJson(json['actor'] as Map<String, dynamic>)
          : null,

      order: json['order'] is Map<String, dynamic>
          ? OrderModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isUnread => !(isRead ?? false);

  String get displayTitle {
    final value = (title ?? '').trim();
    return value.isEmpty ? 'Notification' : value;
  }

  String get displayMessage {
    final value = (message ?? '').trim();
    return value.isEmpty ? 'No details available.' : value;
  }
}

class Actor {
  final String id;
  final String name;
  final String email;
  final Avatar? avatar;

  Actor({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] != null ? Avatar.fromJson(json['avatar']) : null,
    );
  }
}

class Avatar {
  final String publicId;
  final String url;

  Avatar({required this.publicId, required this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(publicId: json['public_id'] ?? '', url: json['url'] ?? '');
  }
}

class OrderModel {
  final String id;
  final String orderId;
  final double totalAmount;
  final String status;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: _asString(json['_id']) ?? '',
      orderId: _asString(json['orderId']) ?? '',
      totalAmount: _asDouble(json['totalAmount']),
      status: _asString(json['status']) ?? '',
    );
  }
}

String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final v = value.toLowerCase().trim();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;
  }
  return null;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

DateTime? _tryParseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
