import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';

class TournamentRentalModel {
  final int id;
  final String sportId;
  final String? sportName;
  final String? name;
  final String? image;
  final String? startDate;
  final String? endDate;
  final String? location;
  final String? status;
  final List<ItemModel> items;
  final List<BundleModel> bundles;

  TournamentRentalModel({
    required this.id,
    required this.sportId,
    this.sportName,
    this.name,
    this.image,
    this.startDate,
    this.endDate,
    this.location,
    this.status,
    required this.items,
    required this.bundles,
  });

  factory TournamentRentalModel.fromJson(Map<String, dynamic> json) {
    return TournamentRentalModel(
      id: json['id'],
      sportId: json['sport_id'],
      sportName: json['sport_name'],
      name: json['name'],
      image: json['image'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      location: json['location'],
      status: json['status'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => ItemModel.fromJson(item))
              .toList()
          : [],
      bundles: json['bundles'] != null
          ? (json['bundles'] as List)
              .map((e) => BundleModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
