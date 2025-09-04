class UserModel {
  final int id;
  final String? name;
  final String? profileImage;
  final String? email;
  final String? contactNumber;
  final String? referralCode;
  final String? address;
  final List<String>? roles;
  final List<String>? permissions;
  final bool? isNotification;
  final bool? isEmailNotification;
  final bool? isSmsNotification;
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
    this.isNotification,
    this.isEmailNotification,
    this.isSmsNotification,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      email: json['email'],
      contactNumber: json['contact_number'],
      referralCode: json['referral_code'],
      address: json['address'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
      isNotification: json['is_notification'] ?? false,
      isEmailNotification: json['is_email_notification'] ?? false,
      isSmsNotification: json['is_sms_notification'] ?? false,
    );
  }
}
