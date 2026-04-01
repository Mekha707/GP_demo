class MessageModel {
  final String id;
  final String chatId;
  final String senderId; // Id الخاص بالمستخدم الذي أرسل
  final String content;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['Id'],
      chatId: json['ChatId'],
      senderId: json['SenderId'],
      content: json['Content'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt']),
      isRead: json['IsRead'] ?? false,
    );
  }
}
