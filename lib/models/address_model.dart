class AddressModel {
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  AddressModel({
    this.streetAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
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
