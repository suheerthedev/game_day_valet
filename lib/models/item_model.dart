class ItemModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String? image;
  final String status;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.status,
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
