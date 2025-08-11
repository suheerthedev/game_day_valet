import 'package:game_day_valet/models/item_model.dart';

class BundleModel {
  final int id;
  final String? name;
  final String? description;
  final String? totalItems;
  final String? price;
  final String? status;
  final List<ItemModel>? items;

  BundleModel({
    required this.id,
    this.name,
    this.description,
    this.totalItems,
    this.price,
    this.status,
    this.items,
  });

  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      totalItems: json['total_items'],
      price: json['price'],
      status: json['status'],
      items: json['items']
          .map((e) => ItemModel.fromJson(e))
          .toList()
          .cast<ItemModel>(),
    );
  }
}
