import 'package:game_day_valet/models/item_model.dart';

class BundleModel {
  final int id;
  final String? name;
  final String? description;
  final String? image;
  final String? totalItems;
  final String? price;
  final String? status;
  final List<ItemModel>? items;
  bool isSelected;
  int quantity;

  BundleModel({
    required this.id,
    this.name,
    this.description,
    this.image,
    this.totalItems,
    this.price,
    this.status,
    this.items,
    this.isSelected = false,
    this.quantity = 0,
  });

  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      totalItems: json['total_items'],
      price: json['price'],
      status: json['status'],
      items: json['items'] != null
          ? (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList()
          : [],
    );
  }
}
