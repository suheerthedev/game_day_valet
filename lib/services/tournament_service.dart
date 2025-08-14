import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';

class TournamentService {
  final _apiService = locator<ApiService>();

  List<TournamentModel> tournamentsBySport = [];
  List<TournamentModel> recommendedTournaments = [];

  Future<void> getTournamentsBySport(int sportId) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsBySportEndPoint}/$sportId';

    try {
      final response = await _apiService.get(url);

      logger.info("Tournaments by sport: $response");

      tournamentsBySport = (response['data'] as List)
          .map((e) => TournamentModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments by sport", e);
      rethrow;
    } catch (e) {
      logger.error("Error fetching tournaments by sport", e);
      throw ApiException(e.toString());
    }
  }

  Future<void> getRecommendedTournaments() async {
    final url = ApiConfig.baseUrl + ApiConfig.tournamentsEndPoint;

    try {
      final response = await _apiService.get(url);

      logger.info("Recommended tournaments: $response");

      recommendedTournaments = (response['data'] as List)
          .map((e) => TournamentModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      rethrow;
    } catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      throw ApiException(e.toString());
    }
  }
}
