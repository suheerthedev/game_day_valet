class RentalHistoryModel {
  final int id;
  final int userId;
  final int tournamentId;
  final String? tournamentName;
  final String? teamName;
  final String? coachName;
  final String? fieldNumber;
  final String? instructions;
  final String? dropoffTime;
  final String? promoCode;
  final String? insuranceOption;
  final bool? damageWaiver;
  final String? rentalDate;
  final String? deliveryAssignedTo;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? totalAmount;
  final String? status;
  final String? returnInstructions;

  RentalHistoryModel({
    required this.id,
    required this.userId,
    required this.tournamentId,
    this.tournamentName,
    this.teamName,
    this.coachName,
    this.fieldNumber,
    this.instructions,
    this.dropoffTime,
    this.promoCode,
    this.insuranceOption,
    this.damageWaiver,
    this.rentalDate,
    this.deliveryAssignedTo,
    this.paymentMethod,
    this.paymentStatus,
    this.totalAmount,
    this.status,
    this.returnInstructions,
  });

  factory RentalHistoryModel.fromJson(Map<String, dynamic> json) {
    return RentalHistoryModel(
      id: json['id'],
      userId: json['user_id'],
      tournamentId: json['tournament_id'],
      tournamentName: json['tournament_name'],
      teamName: json['team_name'],
      coachName: json['coach_name'],
      fieldNumber: json['field_number'],
      instructions: json['instructions'],
      dropoffTime: json['dropoff_time'],
      promoCode: json['promo_code'],
      insuranceOption: json['insurance_option'],
      damageWaiver: json['damage_waiver'],
      rentalDate: json['rental_date'],
      deliveryAssignedTo: json['delivery_assigned_to'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      totalAmount: json['total_amount'],
      status: json['status'],
      returnInstructions: json['return_instructions'],
    );
  }
}
