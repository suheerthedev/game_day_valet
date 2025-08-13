import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';

class UserService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();

  final ReactiveValue<UserModel?> _currentUser =
      ReactiveValue<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;

  UserService() {
    listenToReactiveValues([_currentUser]);
  }

  Future<void> fetchCurrentUser() async {
    final url = ApiConfig.baseUrl + ApiConfig.meEndPoint;

    try {
      final response = await _apiService.get(url);
      _currentUser.value = UserModel.fromJson(response['user']);

      logger.info("Fetch User: $response");
      logger.info("Fetch User Status: ${response['message']}");
    } on ApiException catch (e) {
      logger.error("Fetch User Status failed - API Exception", e);
    } catch (e) {
      logger.error("Fetch User Status failed - Unknown error", e);
    }
    notifyListeners();
  }

  void clearUser() {
    _currentUser.value = null;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _currentUser.value = user;
    notifyListeners();
  }
}
