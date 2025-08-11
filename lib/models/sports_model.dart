class SportsModel {
  final int id;
  final String? name;
  final String? description;
  final String? status;

  SportsModel({
    required this.id,
    this.name,
    this.description,
    this.status,
  });

  factory SportsModel.fromJson(Map<String, dynamic> json) {
    return SportsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }
}
