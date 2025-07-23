import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Rentals will be delivered in 30 min',
      'description': 'You have a new rental booking',
      'time': '12:00 PM',
    },
    {
      'title': 'Invite you friend & earn referrals',
      'description':
          'Invite your friends to join Game Day Valet and earn referral rewards.',
      'time': '12:00 PM',
    },
  ];

  void onChatTap() {
    _navigationService.navigateToChatView();
  }
}
