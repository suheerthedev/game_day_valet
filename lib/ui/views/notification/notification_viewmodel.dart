import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/models/notification_model.dart';
import 'package:game_day_valet/services/notification_service.dart';
import 'package:stacked/stacked.dart';

class NotificationViewModel extends BaseViewModel {
  final _notificationService = locator<NotificationService>();

  List<NotificationModel> get notifications =>
      _notificationService.notifications;
}
