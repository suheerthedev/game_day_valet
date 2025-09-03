import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/models/notification_model.dart';
import 'package:game_day_valet/models/pagination_model.dart';
import 'package:game_day_valet/services/notification_service.dart';
import 'package:stacked/stacked.dart';

class NotificationViewModel extends BaseViewModel {
  final _notificationService = locator<NotificationService>();

  List<NotificationModel> get notifications =>
      _notificationService.notifications;

  PaginationModel? get pagination => _notificationService.pagination;
  bool get isFetching => _notificationService.isFetching;
  bool get hasMorePages => _notificationService.hasMorePages;

  Future<void> initialize() async {
    if (notifications.isEmpty) {
      setBusy(true);
      await fetchNotifications(refresh: true);
      setBusy(false);
    }
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    await _notificationService.getUserNotifications(refresh: refresh);
    notifyListeners();
  }

  Future<void> reloadNotifications() async {
    setBusy(true);
    await fetchNotifications(refresh: true);
    setBusy(false);
  }

  Future<void> loadMoreNotifications() async {
    if (isFetching || !hasMorePages) return;

    await fetchNotifications(refresh: false);
  }
}
