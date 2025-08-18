import 'dart:convert';

import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/rental_booking_model.dart';
import 'package:game_day_valet/models/rental_status_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/pusher_service.dart';
import 'package:stacked/stacked.dart';

class RentalService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();
  final _pusherService = locator<PusherService>();

  bool _isPusherInitialized = false;

  final ReactiveValue<List<RentalStatusModel>> _rentalStatus =
      ReactiveValue<List<RentalStatusModel>>([]);
  final ReactiveValue<RentalBookingModel> _rentalBooking =
      ReactiveValue<RentalBookingModel>(RentalBookingModel(
    id: 0,
    userId: 0,
    tournamentId: 0,
    teamName: "",
    coachName: "",
    fieldNumber: "",
  ));

  RentalService() {
    listenToReactiveValues([_rentalStatus, _rentalBooking]);
  }

  RentalBookingModel? get rentalBooking => _rentalBooking.value;
  List<RentalStatusModel> get rentalStatus => _rentalStatus.value;

  Future<dynamic> createRentalBooking(Map<String, dynamic> body) async {
    final url = ApiConfig.baseUrl + ApiConfig.bookRentalEndPoint;

    try {
      final response = await _apiService.post(url, body);

      print("Booking Rental Response: $response");

      if (response.containsKey('errors')) {
        return response;
      }

      _rentalBooking.value = RentalBookingModel.fromJson(response['data']);

      logger.info("Booking Rental Response: $response");
      await initializePusher();
      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error in booking rental: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error in booking rental: ${e.toString()}");
      throw ApiException("Something went wrong. ${e.toString()}");
    }
  }

  Future<void> getRentalStatus(int rentalId) async {
    final url =
        "${ApiConfig.baseUrl}${ApiConfig.rentalStatusEndPoint}/$rentalId";

    try {
      final response = await _apiService.get(url);

      _rentalStatus.value = (response['status'] as List)
          .map((e) => RentalStatusModel.fromJson(e))
          .toList();

      logger.info("Rental Status Response: $response");
    } on ApiException catch (e) {
      logger.error("Error in getting rental status: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error in getting rental status: ${e.toString()}");
      throw ApiException("Something went wrong. ${e.toString()}");
    }
  }

  Future<void> initializePusher() async {
    logger.info("Initializing Pusher For Rental");
    if (_isPusherInitialized) return;

    try {
      await _pusherService.initialize();

      if (rentalBooking?.id != null) {
        await subscribeToChannel('rental-${rentalBooking!.id.toString()}');
      }
      _isPusherInitialized = true;
      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error initializing Pusher: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error initializing Pusher: $e");
      rethrow;
    }
  }

  Future<void> subscribeToChannel(String channelName) async {
    await _pusherService.subscribeToChannel(channelName, _handleIncomingStatus);
    notifyListeners();
  }

  void _handleIncomingStatus(dynamic eventData) {
    try {
      logger.info("Handling in RentalService incoming status: $eventData");

      if (eventData.toString() == '{}') {
        logger.info("No data received from Pusher");
        return;
      }

      final data = jsonDecode(eventData);

      _rentalStatus.value.add(RentalStatusModel.fromJson(data));

      notifyListeners();
    } catch (e) {
      logger.error("Error handling incoming status: $e");
    }
    // try {
    //   logger.info("Handling in ChatService incoming message: $eventData");

    //   if (eventData.toString() == '{}') {
    //     print('No data received from Pusher');
    //     return;
    //   }

    //   final data = jsonDecode(eventData);

    //   _conversations.value
    //       .where((element) => element.id == data['message']['conversation_id'])
    //       .first
    //       .messages
    //       ?.add(MessageModel.fromJson(data['message']));

    //   _messages.value.insert(0, MessageModel.fromJson(data['message']));

    //   notifyListeners();
    // } on ApiException catch (e) {
    //   logger.error("Error handling incoming message: ${e.message}");
    //   rethrow;
    // } catch (e) {
    //   logger.error("Error handling incoming message: $e");
    //   rethrow;
    // }
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    await _pusherService.unsubscribeFromChannel(channelName);
    notifyListeners();
  }
}
