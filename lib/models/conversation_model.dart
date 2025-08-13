class ConversationModel {
  final int id;
  final int userId;
  final int? responderId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  ConversationModel({
    required this.id,
    required this.userId,
    this.responderId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      userId: json['user_id'],
      responderId: json['responder_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
