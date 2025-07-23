import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/models/faq_item_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FaqViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  List<FaqItemModel> faqItems = [
    FaqItemModel(
        question: 'What is GDV?',
        answer:
            'Keep your travel plans flexible - book your spot and pay nothing todayKeep your travel plans flexible - book your spot and pay nothing today'),
    FaqItemModel(
        question: 'Is GDV free to use?',
        answer:
            'Yes, GDV is free to use. You can use it to find a rental gear and book it.'),
    FaqItemModel(
        question: 'How GDV help us for rental gears?',
        answer:
            'GDV is a platform that helps you find a rental gear and book it. You can use it to find a rental gear and book it.'),
  ];

  void toggleExpansion(int index) {
    faqItems[index].isExpanded = !faqItems[index].isExpanded;
    rebuildUi();
  }

  void onChatTap() {
    _navigationService.navigateToChatView();
  }
}
