class AddressModel {
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  AddressModel({
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      streetAddress: json['street_address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
    );
  }
}
