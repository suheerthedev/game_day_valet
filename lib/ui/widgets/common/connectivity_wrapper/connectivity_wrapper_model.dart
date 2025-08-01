import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/services/connectivity_service.dart';
import 'package:stacked/stacked.dart';

class ConnectivityWrapperModel extends BaseViewModel {
  final _connectivityService = locator<ConnectivityService>();

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void initializeConnectivity() {
    _isOnline = _connectivityService.isOnline;
    _connectivityService.connectivityStream.listen((isOnline) {
      _isOnline = isOnline;
      notifyListeners();
    });
  }
}
