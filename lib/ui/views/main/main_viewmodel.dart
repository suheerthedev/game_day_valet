import 'package:flutter/material.dart';
import 'package:game_day_valet/ui/views/profile/profile_view.dart';
import 'package:game_day_valet/ui/views/rental_status/rental_status_view.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<bool> _isTabInitialized = [true, false, false];

  late final List<Widget?> screens;

  void onTabTapped(int index) {
    _currentIndex = index;
    rebuildUi();

    if (!_isTabInitialized[index]) {
      _isTabInitialized[index] = true;
      switch (index) {
        case 1:
          screens[1] = const RentalStatusView();
          break;
        case 2:
          screens[2] = const ProfileView();
          break;
      }
    }
  }
}
