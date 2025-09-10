import 'package:game_day_valet/app/app.dialogs.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();

  UserModel? get currentUser => _userService.currentUser;

  bool? isNotificationsEnabled;
  bool? isEmailNotificationsEnabled;
  bool? isSmsNotificationsEnabled;

  void init() async {
    isNotificationsEnabled = currentUser?.isNotification ?? false;
    isEmailNotificationsEnabled = currentUser?.isEmailNotification ?? false;
    isSmsNotificationsEnabled = currentUser?.isSmsNotification ?? false;

    rebuildUi();
  }

  void toggleNotifications() {
    isNotificationsEnabled = !isNotificationsEnabled!;
    rebuildUi();
  }

  void onNotificationsTap() async {
    isNotificationsEnabled = !isNotificationsEnabled!;
    rebuildUi();

    final url = ApiConfig.baseUrl + ApiConfig.toggleNotificationsEndPoint;

    try {
      final response = await _apiService.post(url, {});

      if (response.containsKey('enabled')) {
        _snackbarService.showCustomSnackBar(
            message: response['message'], variant: SnackbarType.success);
      }
    } on ApiException catch (e) {
      logger.error("Error in toggle notifications: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in toggle notifications: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
    }
  }

  void onEmailNotificationsTap() async {
    isEmailNotificationsEnabled = !isEmailNotificationsEnabled!;
    rebuildUi();

    final url = ApiConfig.baseUrl + ApiConfig.toggleEmailNotificationsEndPoint;

    try {
      final response = await _apiService.post(url, {});

      if (response.containsKey('enabled')) {
        _snackbarService.showCustomSnackBar(
            message: response['message'], variant: SnackbarType.success);
      }
    } on ApiException catch (e) {
      logger.error("Error in toggle email notifications: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in toggle email notifications: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
    }
  }

  void onSmsNotificationsTap() async {
    isSmsNotificationsEnabled = !isSmsNotificationsEnabled!;
    rebuildUi();

    final url = ApiConfig.baseUrl + ApiConfig.toggleSmsNotificationsEndPoint;

    try {
      final response = await _apiService.post(url, {});

      if (response.containsKey('enabled')) {
        _snackbarService.showCustomSnackBar(
            message: response['message'], variant: SnackbarType.success);
      }
    } on ApiException catch (e) {
      logger.error("Error in toggle sms notifications: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in toggle sms notifications: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
    }
  }

  void onDeleteAccountTap() async {
    logger.info("Delete Account");

    final response = await _dialogService.showCustomDialog(
      variant: DialogType.confirmation,
      title: "Delete Account",
      description:
          "Are you sure you want to delete your account? This action cannot be undone.",
    );

    if (response?.confirmed ?? false) {
      logger.info("Delete Account");
    } else {
      logger.info("Cancel");
    }
  }
}
