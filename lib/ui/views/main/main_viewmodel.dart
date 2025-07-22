import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
