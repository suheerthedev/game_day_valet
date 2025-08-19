class RentalBookingModel {
  final int id;
  final int userId;
  final int tournamentId;
  final String? teamName;
  final String? coachName;
  final String? fieldNumber;
  final String? paymentMethod;
  final String? paymentStatus;

  RentalBookingModel({
    required this.id,
    required this.userId,
    required this.tournamentId,
    required this.teamName,
    required this.coachName,
    required this.fieldNumber,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory RentalBookingModel.fromJson(Map<String, dynamic> json) {
    return RentalBookingModel(
      id: json['id'],
      userId: json['user_id'],
      tournamentId: json['tournament_id'],
      teamName: json['team_name'],
      coachName: json['coach_name'],
      fieldNumber: json['field_number'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
    );
  }
}
