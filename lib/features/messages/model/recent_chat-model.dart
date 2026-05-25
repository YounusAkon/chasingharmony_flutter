class RecentChatModel {
  final String id;
  final String title;
  final DateTime lastMessageAt;
  final int messageCount;
  final bool crisisFlagged;

  RecentChatModel({
    required this.id,
    required this.title,
    required this.lastMessageAt,
    required this.messageCount,
    required this.crisisFlagged,
  });

  factory RecentChatModel.fromJson(Map<String, dynamic> json) {
    return RecentChatModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      lastMessageAt: _parseDateTime(
        json['lastMessageAt'] ?? json['updatedAt'] ?? json['createdAt'],
      ),
      messageCount: json['messageCount'] ?? json['messagesCount'] ?? 0,
      crisisFlagged: json['crisisFlagged'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'messageCount': messageCount,
      'crisisFlagged': crisisFlagged,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}