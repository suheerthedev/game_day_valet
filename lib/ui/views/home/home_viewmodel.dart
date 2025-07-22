import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  String selectedSport = ''; // Default selected sport

  final List<String> sports = [
    'Soccer',
    'Baseball',
    'Softball',
    'Lacrosse',
    'Football',
  ];
}
