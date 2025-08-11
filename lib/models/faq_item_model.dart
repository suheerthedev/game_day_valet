class FaqItemModel {
  final int id;
  final String title;
  final String description;
  final bool status;
  final String createdAt;
  final String updatedAt;
  bool isExpanded;

  FaqItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
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
