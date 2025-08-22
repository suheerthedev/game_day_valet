class ItemModel {
  final int id;
  final String? name;
  final String? description;
  final String? price;
  final int? stock;
  final String? imageUrl;
  final String? status;
  int quantity;

  ItemModel({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.imageUrl,
    this.status,
    this.quantity = 0,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? json['item_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      imageUrl: json['image_url'],
      status: json['status'],
    );
  }
}
