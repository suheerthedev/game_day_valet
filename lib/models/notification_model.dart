class NotificationModel {
  final String id;
  final String type;
  final int? rentalId;
  final int? userId;
  final String? tournamentName;
  final String? totalAmount;
  final String? status;
  final String? message;
  final String? timeStamp;
  final String? formattedTimeStamp;

  NotificationModel({
    required this.id,
    required this.type,
    this.userId,
    this.rentalId,
    this.tournamentName,
    this.totalAmount,
    this.status,
    this.message,
    this.timeStamp,
    this.formattedTimeStamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      userId: json['data']['user_id'],
      rentalId: json['data']['rental_id'],
      tournamentName: json['data']['tournament_name'],
      totalAmount: json['data']['total_amount'],
      status: json['data']['status'],
      message: json['data']['message'],
      timeStamp: json['data']['timestamp'],
      formattedTimeStamp: json['data']['formatted_timestamp'],
    );
  }
}
