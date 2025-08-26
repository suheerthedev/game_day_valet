import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/notification_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';

class NotificationService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();

  final ReactiveValue<List<NotificationModel>> _notifications =
      ReactiveValue<List<NotificationModel>>([]);

  List<NotificationModel> get notifications => _notifications.value;

  Future<void> getUserNotifications() async {
    final url = ApiConfig.baseUrl + ApiConfig.notificationsEndPoint;

    try {
      final response = await _apiService.get(url);

      logger.info("Notifications: $response");

      _notifications.value = (response['data'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      logger.error("Error fetching notifications: ${e.message}");
    } catch (e) {
      logger.error("Error fetching notifications: $e");
    }
  }
}
