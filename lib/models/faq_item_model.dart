class FaqItemModel {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItemModel({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
