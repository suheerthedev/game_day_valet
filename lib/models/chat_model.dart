import 'package:game_day_valet/models/user_model.dart';

class ChatModel {
  final int id;
  final int userId;
  final int responderId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? messages;
  final UserModel? responder;

  ChatModel({
    required this.id,
    required this.userId,
    required this.responderId,
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
      messages: json['messages'],
      responder: UserModel.fromJson(json['responder']),
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
