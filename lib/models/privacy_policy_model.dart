class PrivacyPolicyModel {
  final int id;
  final String title;
  final String description;
  final bool status;
  final String type;
  final String createdAt;
  final String updatedAt;

  PrivacyPolicyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
