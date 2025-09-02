import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/notification_model.dart';
import 'package:game_day_valet/models/pagination_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';

class NotificationService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();

  final ReactiveValue<List<NotificationModel>> _notifications =
      ReactiveValue<List<NotificationModel>>([]);
  final ReactiveValue<PaginationModel?> _pagination =
      ReactiveValue<PaginationModel?>(null);
  final ReactiveValue<bool> _isFetching = ReactiveValue<bool>(false);

  NotificationService() {
    listenToReactiveValues([_notifications, _pagination, _isFetching]);
  }

  List<NotificationModel> get notifications => _notifications.value;
  PaginationModel? get pagination => _pagination.value;
  bool get isFetching => _isFetching.value;
  bool get hasMorePages => pagination?.hasMorePages ?? false;

  Future<void> getUserNotifications({bool refresh = true}) async {
    if (refresh) {
      _notifications.value = [];
      _pagination.value = null;
    }

    final page = refresh ? 1 : (pagination?.currentPage ?? 0) + 1;
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.notificationsEndPoint}?limit=10&page=$page';

    _isFetching.value = true;

    try {
      final response = await _apiService.get(url);

      logger.info("Notifications: $response");

      final newNotifications = (response['data'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();

      if (refresh) {
        _notifications.value = newNotifications;
      } else {
        _notifications.value = [..._notifications.value, ...newNotifications];
      }

      _pagination.value = PaginationModel.fromJson(response['pagination']);
    } on ApiException catch (e) {
      logger.error("Error fetching notifications: ${e.message}");
    } catch (e) {
      logger.error("Error fetching notifications: $e");
    } finally {
      _isFetching.value = false;
    }
  }
}
