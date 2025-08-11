import 'package:game_day_valet/models/sports_model.dart';

class TournamentModel {
  final int id;
  final SportsModel? sport;
  final String name;
  final String? image;
  final String startDate;
  final String endDate;
  final String location;
  final String status;
  bool isFavorite;

  TournamentModel({
    required this.id,
    this.sport,
    required this.name,
    this.image,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.status,
    this.isFavorite = false,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'],
      sport: json['sport'] != null ? SportsModel.fromJson(json['sport']) : null,
      name: json['name'],
      image: json['image'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      location: json['location'],
      status: json['status'],
      isFavorite: json['is_favorite'],
    );
  }
}
