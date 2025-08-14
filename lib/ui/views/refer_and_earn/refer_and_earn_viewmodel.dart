import 'package:flutter/services.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked_services/stacked_services.dart';

class ReferAndEarnViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  double progress = 0; // 0 to 1

  // final _share = SharePlus.instance
  //     .share(ShareParams(text: 'check out my website https://example.com'));

  String? referralCode = '';
  String? referralLink = '';

  double finalValue = 50.00;
  double currentValue = 15.00;

  void calculateProgress() {
    progress = currentValue / finalValue;
    logger.info("Refer and Earn Progress: $progress");
    rebuildUi();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _snackbarService.showCustomSnackBar(
        message: 'Copied to clipboard', variant: SnackbarType.success);
    rebuildUi();
  }

  Future<void> shareReferralLink() async {
    await SharePlus.instance.share(ShareParams(text: referralLink));
  }

  Future<void> getReferralData() async {
    final url = ApiConfig.baseUrl + ApiConfig.referralCodeEndPoint;
    setBusy(true);
    rebuildUi();
    try {
      final response = await _apiService.get(url);

      if (response.containsKey('referral_code')) {
        referralCode = response['referral_code'];
        referralLink = response['link'];
      }
    } on ApiException catch (e) {
      logger.error("Error getting referral code: ${e.message}");
      _snackbarService.showCustomSnackBar(
          title: 'Error', message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error getting referral code: $e");
      _snackbarService.showCustomSnackBar(
          title: 'Error', message: e.toString(), variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
