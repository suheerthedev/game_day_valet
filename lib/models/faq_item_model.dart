class FaqItemModel {
  final int id;
  final String? title;
  final String? description;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;
  bool isExpanded;

  FaqItemModel({
    required this.id,
    this.title,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isExpanded = false,
  });

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isExpanded: false,
    );
  }
}
