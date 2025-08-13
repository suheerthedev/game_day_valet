import 'package:game_day_valet/models/user_model.dart';

class MessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String? content;
  final int? isRead;
  final String? createdAt;
  final String? updatedAt;
  final UserModel? sender;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      sender: UserModel.fromJson(json['sender']),
    );
  }
}
