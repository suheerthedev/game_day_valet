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

  int lastPageForRecommendedTournaments = 0;
  bool hasMoreRecommendedTournaments = true;

  int lastPageForTournamentsBySport = 0;
  bool hasMoreTournamentsBySport = true;

  Future<void> getTournamentsBySport(int sportId, {int page = 1}) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsBySportEndPoint}/$sportId?limit=10&page=$page';

    try {
      final response = await _apiService.get(url);

      if (response.containsKey('meta')) {
        if (response['meta'].containsKey('last_page')) {
          lastPageForTournamentsBySport = response['meta']['last_page'];
        }
      }

      logger.info("Tournaments by sport: $response");

      final newTournaments = (response['data'] as List)
          .map((e) => TournamentModel.fromJson(e))
          .toList();

      tournamentsBySport.addAll(newTournaments);

      newTournaments.length < 10
          ? hasMoreTournamentsBySport = false
          : hasMoreTournamentsBySport = true;
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments by sport", e);
      rethrow;
    } catch (e) {
      logger.error("Error fetching tournaments by sport", e);
      throw ApiException(e.toString());
    }
  }

  Future<void> getRecommendedTournaments({int page = 1}) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsEndPoint}?limit=10&page=$page';

    try {
      final response = await _apiService.get(url);

      if (response.containsKey('meta')) {
        if (response['meta'].containsKey('last_page')) {
          lastPageForRecommendedTournaments = response['meta']['last_page'];
        }
      }
      logger.info("Recommended tournaments: $response");

      final newTournaments = (response['data'] as List)
          .map((e) => TournamentModel.fromJson(e))
          .toList();

      recommendedTournaments.addAll(newTournaments);

      newTournaments.length < 10
          ? hasMoreRecommendedTournaments = false
          : hasMoreRecommendedTournaments = true;
    } on ApiException catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      rethrow;
    } catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      throw ApiException(e.toString());
    }
  }

  void clearTournaments() {
    tournamentsBySport.clear();
    recommendedTournaments.clear();
  }
}
