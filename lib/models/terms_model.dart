class TermsModel {
  final int id;
  final String? title;
  final String? description;
  final bool? status;
  final String? type;
  final String? createdAt;
  final String? updatedAt;
  TermsModel({
    required this.id,
    this.title,
    this.description,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
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
