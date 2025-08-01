import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';

class UserService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<void> fetchCurrentUser() async {
    final url = ApiConfig.baseUrl + ApiConfig.meEndPoint;

    try {
      final response = await _apiService.get(url);
      _currentUser = UserModel.fromJson(response['user']);
      logger.info("Fetch User Status: ${response['message']}");
    } on ApiException catch (e) {
      logger.error("Fetch User Status failed - API Exception", e);
    } catch (e) {
      logger.error("Fetch User Status failed - Unknown error", e);
    }
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}
