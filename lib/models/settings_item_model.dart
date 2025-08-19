class SettingsItemModel {
  final int id;
  final String label;
  final String price;
  bool isSelected;

  SettingsItemModel({
    required this.id,
    required this.label,
    required this.price,
    this.isSelected = false,
  });

  factory SettingsItemModel.fromJson(Map<String, dynamic> json) {
    return SettingsItemModel(
      id: json['id'],
      label: json['label'],
      price: json['price'],
    );
  }
}
