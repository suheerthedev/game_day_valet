class SettingsItemModel {
  final int id;
  final String label;
  final String? description;
  final num price;
  bool isSelected;

  SettingsItemModel({
    required this.id,
    required this.label,
    this.description,
    required this.price,
    this.isSelected = false,
  });

  factory SettingsItemModel.fromJson(Map<String, dynamic> json) {
    return SettingsItemModel(
      id: json['id'],
      label: json['label'],
      description: json['description'],
      price: json['price'],
    );
  }
}
