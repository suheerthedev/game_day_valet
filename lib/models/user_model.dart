import 'package:game_day_valet/models/address_model.dart';

class UserModel {
  final int id;
  final String? name;
  final String? profileImage;
  final String? email;
  final String? contactNumber;
  final String? referralCode;
  final AddressModel? address;
  final List<String>? roles;
  final List<String>? permissions;

  UserModel({
    required this.id,
    this.name,
    this.profileImage,
    this.email,
    this.contactNumber,
    this.referralCode,
    this.address,
    this.roles,
    this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      email: json['email'],
      contactNumber: json['contact_number'],
      referralCode: json['referral_code'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
    );
  }
}
