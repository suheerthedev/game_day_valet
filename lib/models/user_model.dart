import 'package:game_day_valet/models/address_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? referralCode;
  final AddressModel? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.referralCode,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      referralCode: json['referral_code'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
    );
  }
}
