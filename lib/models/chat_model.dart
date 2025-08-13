import 'package:game_day_valet/models/message_model.dart';
import 'package:game_day_valet/models/user_model.dart';

class ChatModel {
  final int id;
  final int userId;
  final int? responderId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final List<MessageModel>? messages;
  final UserModel? responder;

  ChatModel({
    required this.id,
    required this.userId,
    this.responderId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.messages,
    this.responder,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      userId: json['user_id'],
      responderId: json['responder_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      messages: json['messages']
          .map((e) => MessageModel.fromJson(e))
          .toList()
          .cast<MessageModel>(),
      responder: json['responder'] != null
          ? UserModel.fromJson(json['responder'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'responder_id': responderId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'messages': messages,
    };
  }
}
