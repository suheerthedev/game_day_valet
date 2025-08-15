class RentalBookingModel {
  final int id;
  final int userId;
  final int tournamentId;
  final String? teamName;
  final String? coachName;
  final String? fieldNumber;

  RentalBookingModel({
    required this.id,
    required this.userId,
    required this.tournamentId,
    required this.teamName,
    required this.coachName,
    required this.fieldNumber,
  });

  factory RentalBookingModel.fromJson(Map<String, dynamic> json) {
    return RentalBookingModel(
      id: json['id'],
      userId: json['user_id'],
      tournamentId: json['tournament_id'],
      teamName: json['team_name'],
      coachName: json['coach_name'],
      fieldNumber: json['field_number'],
    );
  }
}
