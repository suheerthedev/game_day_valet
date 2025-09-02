import 'package:game_day_valet/models/tournament_model.dart';

class FavoriteModel {
  final int id;
  final int userId;
  final TournamentModel? tournament;
  final String? createdAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    this.tournament,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['user_id'],
      tournament: json['tournament'] != null
          ? TournamentModel.fromJson(json['tournament'])
          : null,
      createdAt: json['created_at'],
    );
  }
}
