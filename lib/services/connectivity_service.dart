import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:stacked_services/stacked_services.dart';

class ConnectivityService {
  // final Connectivity _connectivity = Connectivity();
  // final _snackbarService = locator<SnackbarService>();

  // StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  // bool _isOnline = true;
  // bool _hasShownOfflineMessage = false;

  // bool get isOnline => _isOnline;

  // final StreamController<bool> _connectivityController =
  //     StreamController<bool>.broadcast();

  // Stream<bool> get connectivityStream => _connectivityController.stream;

  // Future<void> initialize() async {
  //   // Check initial connectivity
  //   final results = await _connectivity.checkConnectivity();
  //   _updateConnectionStatus(results);

  //   // Listen to connectivity changes
  //   _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
  //     _updateConnectionStatus,
  //   );
  // }

  // void _updateConnectionStatus(List<ConnectivityResult> results) {
  //   final isConnected =
  //       results.any((result) => result != ConnectivityResult.none);

  //   if (_isOnline != isConnected) {
  //     _isOnline = isConnected;
  //     _connectivityController.add(_isOnline);

  //     if (!_isOnline && !_hasShownOfflineMessage) {
  //       _showOfflineMessage();
  //       _hasShownOfflineMessage = true;
  //     } else if (_isOnline && _hasShownOfflineMessage) {
  //       _showOnlineMessage();
  //       _hasShownOfflineMessage = false;
  //     }
  //   }
  // }

  // void _showOfflineMessage() {
  //   _snackbarService.showCustomSnackBar(
  //     variant: SnackbarType.noInternet,
  //     title: 'No Internet Connection',
  //     message: 'Please check your internet connection and try again.',
  //     duration: const Duration(seconds: 5),
  //   );
  // }

  // void _showOnlineMessage() {
  //   _snackbarService.showCustomSnackBar(
  //     variant: SnackbarType.success,
  //     title: 'Connected',
  //     message: 'Internet connection restored!',
  //     duration: const Duration(seconds: 2),
  //   );
  // }

  // Future<bool> hasInternetConnection() async {
  //   try {
  //     final results = await _connectivity.checkConnectivity();
  //     return results.any((result) => result != ConnectivityResult.none);
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // void dispose() {
  //   _connectivitySubscription?.cancel();
  //   _connectivityController.close();
  // }
}
