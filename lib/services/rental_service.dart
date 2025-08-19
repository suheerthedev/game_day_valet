import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/rental_booking_model.dart';
import 'package:game_day_valet/models/rental_status_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/pusher_service.dart';
import 'package:game_day_valet/services/shared_preferences_service.dart';
import 'package:game_day_valet/services/stripe_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RentalService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();
  final _pusherService = locator<PusherService>();
  final _stripeService = locator<StripeService>();
  final _navigationService = locator<NavigationService>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();

  bool _isPusherInitialized = false;

  int? rentalId;

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

  Future<void> init() async {
    rentalId = await _sharedPreferencesService.getInt('rental_id');
    if (rentalId != null) {
      await getRentalStatus();
      await initializePusher();
    }
  }

  void clearData() {
    rentalId = null;
    _rentalStatus.value = [];
    _rentalBooking.value = RentalBookingModel(
      id: 0,
      userId: 0,
      tournamentId: 0,
      teamName: "",
      coachName: "",
      fieldNumber: "",
    );
  }

  Future<dynamic> createRentalBooking(
      BuildContext context, num totalAmount, Map<String, dynamic> body) async {
    final url = ApiConfig.baseUrl + ApiConfig.rentalEndPoint;

    clearData();

    try {
      final response = await _apiService.post(url, body);

      print("Booking Rental Response: $response");

      if (response.containsKey('errors')) {
        return response;
      }

      _rentalBooking.value = RentalBookingModel.fromJson(response['data']);

      logger.info("Booking Rental Response: $response");

      final isPaymentSuccess = await _handleStripePayment(context, totalAmount);

      if (isPaymentSuccess) {
        await _updatePaymentStatus(_rentalBooking.value.id, 'completed');
        await initializePusher(isNewRental: true);
        await _sharedPreferencesService.setInt(
            'rental_id', _rentalBooking.value.id);
        rentalId = _rentalBooking.value.id;
        await getRentalStatus();
      }

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error in booking rental: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error in booking rental: ${e.toString()}");
      throw ApiException("Something went wrong. ${e.toString()}");
    }
  }

  Future<bool> _handleStripePayment(BuildContext context, num amount) async {
    logger.info('Stripe');
    final isPaymentSuccess = await _stripeService.payWithPaymentSheet(
      amount: amount,
      currency: 'usd',
      context: context,
    );

    if (isPaymentSuccess) {
      _navigationService.popUntil((route) => route.isFirst);
    }

    return isPaymentSuccess;
  }

  Future<void> getRentalStatus() async {
    logger.info("Getting rental status for rental ID: $rentalId");
    final url =
        "${ApiConfig.baseUrl}${ApiConfig.rentalStatusEndPoint}/$rentalId";

    try {
      final response = await _apiService.get(url);

      print("Rental Status Response: $response");

      _rentalStatus.value = (response['status'] as List)
          .map((e) => RentalStatusModel.fromJson(e))
          .toList();

      logger.info("Rental Status Response: $response");
    } on ApiException catch (e) {
      logger.error("Error in getting rental status: ${e.message}");
    } catch (e) {
      logger.error("Error in getting rental status: ${e.toString()}");
    }
  }

  Future<void> _updatePaymentStatus(int rentalId, String paymentStatus) async {
    final url = "${ApiConfig.baseUrl}${ApiConfig.rentalEndPoint}/$rentalId";
    try {
      final response = await _apiService.put(url, {
        'payment_status': paymentStatus,
      });

      logger.info("Payment Status Update Response: $response");
    } on ApiException catch (e) {
      logger.error("Error in updating payment status: ${e.message}");
    } catch (e) {
      logger.error("Error in updating payment status: ${e.toString()}");
    }
  }

  Future<void> compeletePayment(
      BuildContext context, num amount, int rentalId) async {
    try {
      final isPaymentSuccess = await _handleStripePayment(context, amount);

      if (isPaymentSuccess) {
        await _updatePaymentStatus(rentalId, 'completed');
      }

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error in completing payment: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error in completing payment: ${e.toString()}");
      throw ApiException("Something went wrong. ${e.toString()}");
    }
  }

  Future<dynamic> applyPromoCode(
      String promoCode, Map<String, dynamic> body) async {
    final url = ApiConfig.baseUrl + ApiConfig.applyPromoCodeEndPoint;
    try {
      final response = await _apiService.post(url, body);

      return response;
    } on ApiException catch (e) {
      logger.error("Error in applying promo code: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error in applying promo code: ${e.toString()}");
      throw ApiException("Something went wrong. ${e.toString()}");
    }
  }

  Future<void> initializePusher({bool isNewRental = false}) async {
    int tempId;

    if (isNewRental) {
      tempId = rentalBooking?.id ?? 0;
      if (_isPusherInitialized) {
        _isPusherInitialized = false;
        await _pusherService
            .unsubscribeFromChannel('rental-${rentalId.toString()}');
      }
    } else {
      tempId = rentalId ?? 0;
    }

    logger.info("Initializing Pusher For Rental: $tempId");
    if (_isPusherInitialized) return;

    try {
      await _pusherService.initialize();

      if (tempId != 0) {
        await subscribeToChannel('rental-${tempId.toString()}');
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
