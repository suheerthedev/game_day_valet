class CouponModel {
  final int id;
  final String code;
  final String type;
  final String value;
  final bool isValid;
  final String createdAt;
  final String updatedAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.isValid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'],
      code: json['code'],
      type: json['type'],
      value: json['value'],
      isValid: json['is_valid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
