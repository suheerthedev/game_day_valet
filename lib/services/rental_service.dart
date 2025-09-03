import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/models/rental_booking_model.dart';
import 'package:game_day_valet/models/rental_status_model.dart';
import 'package:game_day_valet/models/settings_item_model.dart';
import 'package:game_day_valet/models/tournament_rental_model.dart';
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
  final _snackbarService = locator<SnackbarService>();
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

  List<ItemModel> _items = [];
  List<BundleModel> _bundles = [];

  TournamentRentalModel? _tournamentRental;

  int? itemsLastPage;
  // int? bundlesLastPage;

  List<ItemModel> get items => _items;
  List<BundleModel> get bundles => _bundles;
  TournamentRentalModel? get tournamentRental => _tournamentRental;

  final ReactiveValue<List<SettingsItemModel>> _insuranceOptions =
      ReactiveValue<List<SettingsItemModel>>([]);
  final ReactiveValue<List<SettingsItemModel>> _damageWaiverOptions =
      ReactiveValue<List<SettingsItemModel>>([]);

  RentalService() {
    listenToReactiveValues([_rentalStatus, _rentalBooking]);
  }

  RentalBookingModel? get rentalBooking => _rentalBooking.value;
  List<RentalStatusModel> get rentalStatus => _rentalStatus.value;
  List<SettingsItemModel> get insuranceOptions => _insuranceOptions.value;
  List<SettingsItemModel> get damageWaiverOptions => _damageWaiverOptions.value;

  Future<void> init() async {
    rentalId = await _sharedPreferencesService.getInt('rental_id');
    if (rentalId != null) {
      await getRentalStatus();
      await initializePusher();
    }

    // await getItems();
    // await getBundles();
    await getSettingsItems();
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

  Future<void> reset() async {
    try {
      if (_isPusherInitialized) {
        final int currentRentalId = rentalId ?? 0;
        if (currentRentalId != 0) {
          await _pusherService
              .unsubscribeFromChannel('rental-${currentRentalId.toString()}');
        }
        _isPusherInitialized = false;
      }
    } catch (e) {
      logger.error("Error resetting RentalService: $e");
    } finally {
      clearData();
      notifyListeners();
    }
  }

  Future<dynamic> createRentalBooking(
      BuildContext context, num totalAmount, Map<String, dynamic> body) async {
    final url = ApiConfig.baseUrl + ApiConfig.rentalEndPoint;

    clearData();

    try {
      final response = await _apiService.post(url, body);

      logger.info("Booking Rental Response: $response");

      if (response.containsKey('errors')) {
        return response;
      }

      _rentalBooking.value = RentalBookingModel.fromJson(response['data']);

      logger.info("Booking Rental Response: $response");

      final isPaymentSuccess = await _handleStripePayment(context, totalAmount);

      await initializePusher(isNewRental: true);
      await _sharedPreferencesService.setInt(
          'rental_id', _rentalBooking.value.id);
      rentalId = _rentalBooking.value.id;
      await getRentalStatus();

      if (isPaymentSuccess) {
        await _updatePaymentStatus(_rentalBooking.value.id, 'completed');
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

    _navigationService.popUntil((route) => route.isFirst);

    return isPaymentSuccess;
  }

  Future<void> getRentalStatus() async {
    logger.info("Getting rental status for rental ID: $rentalId");
    final url =
        "${ApiConfig.baseUrl}${ApiConfig.rentalStatusEndPoint}/$rentalId";

    try {
      final response = await _apiService.get(url);

      logger.info("Rental Status Response: $response");

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

  Future<void> getSettingsItems() async {
    final url = ApiConfig.baseUrl + ApiConfig.settingsItemsEndPoint;
    logger.info("Getting settings items from: $url");
    try {
      final response = await _apiService.get(url);

      _insuranceOptions.value = (response['insurance_options'] as List)
          .map((e) => SettingsItemModel.fromJson(e))
          .toList();

      _damageWaiverOptions.value = (response['damage_waiver_options'] as List)
          .map((e) => SettingsItemModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      logger.error("Error in getting settings items: ${e.message}");
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Error in getting settings items: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> getItems({int page = 1}) async {
    final url = "${ApiConfig.baseUrl}${ApiConfig.items}?limit=10&page=$page";

    try {
      final response = await _apiService.get(url);
      _items =
          (response['data'] as List).map((e) => ItemModel.fromJson(e)).toList();
      itemsLastPage = response['meta']['last_page'];
      logger.info("Items: $items");
    } on ApiException catch (e) {
      logger.error("Error getting items: ${e.message}");
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Error getting items: $e");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    }
  }

  Future<void> getMoreItems() async {}

  Future<void> getMoreBundles() async {}

  Future<void> getBundles({int page = 1}) async {
    final url = "${ApiConfig.baseUrl}${ApiConfig.bundles}?limit=10&page=1";

    try {
      final response = await _apiService.get(url);
      logger.info("Bundles: $response");
      _bundles = (response['data'] as List)
          .map((e) => BundleModel.fromJson(e))
          .toList();
      // bundlesLastPage = response['meta']['last_page'];
    } on ApiException catch (e) {
      logger.error("Error getting bundles: ${e.message}");
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Error getting bundles: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    }
  }

  Future<void> getTournamentRentalItems(int tournamentId) async {
    final url =
        "${ApiConfig.baseUrl}${ApiConfig.tournamentRentalItemsEndPoint}/$tournamentId";
    try {
      final response = await _apiService.get(url);

      logger.info("Tournament Rental Items: $response");
      _tournamentRental = TournamentRentalModel.fromJson(response);
    } on ApiException catch (e) {
      logger.error("Error getting tournament rental items: ${e.message}");
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Error getting tournament rental items: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    }
  }

  clearTournamentRental() {
    _tournamentRental = null;
  }

  void resetItemsandBundles() {
    //change their quantites to 0 and unselect bundles
    _items.forEach((element) {
      element.quantity = 0;
    });
    _bundles.forEach((element) {
      element.quantity = 0;
    });
  }
}
