class SportsModel {
  final int id;
  final String? name;
  final String? imageUrl;
  final String? description;
  final String? status;

  SportsModel({
    required this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.status,
  });

  factory SportsModel.fromJson(Map<String, dynamic> json) {
    return SportsModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      description: json['description'],
      status: json['status'],
    );
  }
}
