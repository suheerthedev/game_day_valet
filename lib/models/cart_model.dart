import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';

class CartModel {
  List<ItemModel>? items;
  List<BundleModel>? bundles;

  CartModel({this.items, this.bundles});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList()
          : null,
      bundles: json['bundles'] != null
          ? (json['bundles'] as List)
              .map((e) => BundleModel.fromJson(e))
              .toList()
          : null,
    );
  }
}
