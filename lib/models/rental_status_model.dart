class RentalStatusModel {
  final int id;
  final int rentalId;
  final String? status;
  final String? statusLabel;
  final String? notes;
  final List<String>? imagePaths;
  final List<String>? imageUrls;
  final String? image;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? formattedCreatedAt;
  final String? formattedUpdatedAt;

  RentalStatusModel({
    required this.id,
    required this.rentalId,
    required this.status,
    required this.statusLabel,
    required this.notes,
    required this.imagePaths,
    required this.imageUrls,
    required this.image,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedCreatedAt,
    required this.formattedUpdatedAt,
  });

  factory RentalStatusModel.fromJson(Map<String, dynamic> json) {
    return RentalStatusModel(
      id: json['id'],
      rentalId: json['rental_id'],
      status: json['status'],
      statusLabel: json['status_label'],
      notes: json['notes'],
      imagePaths: json['image_paths'] != null
          ? (json['image_paths'] as List).map((e) => e.toString()).toList()
          : null,
      imageUrls: json['image_urls'] != null
          ? (json['image_urls'] as List).map((e) => e.toString()).toList()
          : null,
      image: json['image'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      formattedCreatedAt: json['formatted_created_at'],
      formattedUpdatedAt: json['formatted_updated_at'],
    );
  }
}
