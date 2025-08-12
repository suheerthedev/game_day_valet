class ItemModel {
  final int id;
  final String? name;
  final String? description;
  final String? price;
  final int? stock;
  final String? image;
  final String? status;
  int quantity;

  ItemModel({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.image,
    this.status,
    this.quantity = 0,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      status: json['status'],
    );
  }
}
