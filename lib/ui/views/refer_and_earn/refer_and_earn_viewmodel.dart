import 'package:stacked/stacked.dart';

class ReferAndEarnViewModel extends BaseViewModel {
  double progress = 0; // 0 to 1

  double finalValue = 50.00;
  double currentValue = 15.00;

  void calculateProgress() {
    progress = currentValue / finalValue;
    print(progress);
    rebuildUi();
  }
}
