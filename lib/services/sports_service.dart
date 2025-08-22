import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/sports_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';

class SportsService {
  final _apiService = locator<ApiService>();

  List<SportsModel> sports = [];

  Future<void> getSports() async {
    final url = ApiConfig.baseUrl + ApiConfig.sportsEndPoint;

    try {
      final response = await _apiService.get(url);

      logger.info("Sports response: $response");

      final data = response['data'];

      for (var item in data) {
        sports.add(SportsModel.fromJson(item));
      }
    } on ApiException catch (e) {
      logger.error("Error fetching sports", e);
      rethrow;
    } catch (e) {
      logger.error("Error fetching sports", e);
      throw ApiException(e.toString());
    }
  }
}
