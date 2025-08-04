import 'package:game_day_valet/models/sports_model.dart';

class TournamentModel {
  final int id;
  final SportsModel sport;
  final String name;
  final String startDate;
  final String endDate;
  final String location;
  final String status;
  bool isFavorite;

  TournamentModel({
    required this.id,
    required this.sport,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.status,
    this.isFavorite = false,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'],
      sport: SportsModel.fromJson(json['sport']),
      name: json['name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      location: json['location'],
      status: json['status'],
      isFavorite: json['is_favorite'],
    );
  }
}
