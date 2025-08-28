import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/sports_model.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/tournament_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TournamentsViewModel extends BaseViewModel {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _tournamentService = locator<TournamentService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _apiService = locator<ApiService>();

  TextEditingController searchController = TextEditingController();
  // Filters
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController ageGroupController = TextEditingController();

  String sportsName = '';
  int sportId = 0;
  TournamentsViewModel({required this.sportsName, required this.sportId});

  List<TournamentModel> get tournamentsList =>
      _tournamentService.tournamentsBySport;
  List<TournamentModel> get recommendedTournamentsList =>
      _tournamentService.recommendedTournaments;
  List<SportsModel> sportsList = [];

  // Tournaments by sport
  int currentPageForTournamentsBySport = 1;
  int get lastPageForTournamentsBySport =>
      _tournamentService.lastPageForTournamentsBySport;
  bool get hasMoreTournamentsBySport =>
      _tournamentService.hasMoreTournamentsBySport;
  bool isLoadingMoreTournamentsBySport = false;

  // Recommended tournaments
  int currentPageForRecommendedTournaments = 1;
  int get lastPageForRecommendedTournaments =>
      _tournamentService.lastPageForRecommendedTournaments;
  bool get hasMoreRecommendedTournaments =>
      _tournamentService.hasMoreRecommendedTournaments;
  bool isLoadingMoreRecommendedTournaments = false;

  void navigateToSearchView(String searchQuery) {
    _navigationService.navigateToSearchView(isTournamentSearch: true);
  }

  void navigateToRentalBook(int tournamentId) {
    _navigationService.navigateToAddRentalsView(tournamentId: tournamentId);
  }

  void init() async {
    setBusy(true);
    rebuildUi();
    await getTournamentsBySport(sportId);
    await getRecommendedTournaments();
    setBusy(false);
    rebuildUi();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      dateController.text = pickedDate.toIso8601String().split('T').first;
      rebuildUi();
    }
  }

  void selectCity(BuildContext context) async {
    final List<String> cities = <String>[
      'All Cities',
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
    ];
    final String? value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
          ),
          child: SafeArea(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cities.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    cities[index],
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  onTap: () => Navigator.of(context).pop(cities[index]),
                );
              },
            ),
          ),
        );
      },
    );
    if (value != null) {
      cityController.text = value == 'All Cities' ? '' : value;
      rebuildUi();
    }
  }

  void selectAgeGroup(BuildContext context) async {
    final List<String> ageGroups = <String>[
      'All Ages',
      'U8',
      'U10',
      'U12',
      'U14',
      'U16',
      'U18',
      'Adult'
    ];
    final String? value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
          ),
          child: SafeArea(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: ageGroups.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    ageGroups[index],
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  onTap: () => Navigator.of(context).pop(ageGroups[index]),
                );
              },
            ),
          ),
        );
      },
    );
    if (value != null) {
      ageGroupController.text = value == 'All Ages' ? '' : value;
      rebuildUi();
    }
  }

  void clearTournaments() {
    _tournamentService.clearTournaments();
  }

  void getTournaments() async {
    setBusy(true);
    rebuildUi();
    try {
      await getTournamentsBySport(sportId);
      await getRecommendedTournaments();
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
    } catch (e) {
      logger.error("Error fetching tournaments", e);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  Future<void> getTournamentsBySport(int sportId) async {
    try {
      await _tournamentService.getTournamentsBySport(sportId);

      // tournamentsList.isEmpty
      //     ? hasMoreTournamentsBySport = false
      //     : hasMoreTournamentsBySport = true;
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    }
  }

  Future<void> loadMoreTournamentsBySport() async {
    isLoadingMoreTournamentsBySport = true;
    rebuildUi();
    try {
      await _tournamentService.getTournamentsBySport(sportId,
          page: ++currentPageForTournamentsBySport);

      // tournamentsList.isEmpty
      //     ? hasMoreTournamentsBySport = false
      //     : hasMoreTournamentsBySport = true;
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    } finally {
      isLoadingMoreTournamentsBySport = false;
      rebuildUi();
    }
  }

  Future<void> getRecommendedTournaments() async {
    try {
      await _tournamentService.getRecommendedTournaments();

      // recommendedTournamentsList.isEmpty
      //     ? hasMoreRecommendedTournaments = false
      //     : hasMoreRecommendedTournaments = true;
    } on ApiException catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    }
  }

  Future<void> loadMoreRecommendedTournaments() async {
    isLoadingMoreRecommendedTournaments = true;
    rebuildUi();
    try {
      await _tournamentService.getRecommendedTournaments(
          page: ++currentPageForRecommendedTournaments);

      // recommendedTournamentsList.isEmpty
      //     ? hasMoreRecommendedTournaments = false
      //     : hasMoreRecommendedTournaments = true;
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    } finally {
      isLoadingMoreRecommendedTournaments = false;
      rebuildUi();
    }
  }

  void toggleFavorite(int tournamentId) async {
    final url = ApiConfig.baseUrl + ApiConfig.toggleFavoriteEndPoint;

    int index =
        tournamentsList.indexWhere((element) => element.id == tournamentId);

    int indexRecommended = recommendedTournamentsList
        .indexWhere((element) => element.id == tournamentId);

    // logger.info("Is Favorite: ${tournamentsList[index].isFavorite}");
    if (index != -1) {
      tournamentsList[index].isFavorite = !tournamentsList[index].isFavorite;
      rebuildUi();
    }

    if (indexRecommended != -1) {
      recommendedTournamentsList[indexRecommended].isFavorite =
          !recommendedTournamentsList[indexRecommended].isFavorite;
      rebuildUi();
    }
    // logger.info("Is Favorite: ${tournamentsList[index].isFavorite}");
    // logger.info(
    // "Is Favorite: ${recommendedTournamentsList[indexRecommended].isFavorite}");

    try {
      final response = await _apiService.post(url, {
        "tournament_id": tournamentId.toString(),
      });

      logger.info("Favorite toggled successfully. Response: $response");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        message: response['message'],
      );
    } on ApiException catch (e) {
      logger.error("Error toggling favorite", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error toggling favorite", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      rebuildUi();
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.899983957647624, 67.10959149999998),
    zoom: 14.4746,
  );

  void showMapPopup(BuildContext context) {
    logger.info('Google Map Popup Triggered');

    // Create a new completer for each popup instance
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.green.shade100, // Simulated map background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: 252.w,
                  height: 148.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      if (!mapController.isCompleted) {
                        mapController.complete(controller);
                      }
                    },
                  ),
                )),
          ),
        );
      },
    );
  }

  void applyFilters() {
    // TODO: If API supports filter parameters, call service with them.
    // For now, just trigger a UI rebuild; filtering can be applied client-side later.
    logger.info(
        'Applying filters: date=${dateController.text}, city=${cityController.text}, age=${ageGroupController.text}');
    rebuildUi();
  }
}
