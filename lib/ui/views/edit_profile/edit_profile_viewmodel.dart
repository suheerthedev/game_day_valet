import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProfileViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _userService = locator<UserService>();

  final _imagePicker = ImagePicker();
  File? imageFile;
  String? get imagePath => imageFile?.path;

  void pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    imageFile = File(image.path);

    print(imageFile);
    print(imagePath);

    rebuildUi();
  }

  UserModel? get currentUser => _userService.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? get profileImage => currentUser?.profileImage;

  ImageProvider get profileImageProvider {
    if (imageFile != null) {
      return FileImage(imageFile!);
    } else if (profileImage?.isNotEmpty == true) {
      return CachedNetworkImageProvider(
          "${ApiConfig.baseUrl}/storage/$profileImage");
    } else {
      return const AssetImage('assets/images/default_avatar.png'); // fallback
    }
  }

  void init() {
    nameController.text = currentUser?.name ?? '';
    emailController.text = currentUser?.email ?? '';
    phoneController.text = currentUser?.contactNumber ?? '';
    addressController.text = currentUser?.address ?? '';
    notifyListeners();
  }

  Future<void> save() async {
    final url = ApiConfig.baseUrl + ApiConfig.profileEndPoint;

    setBusy(true);
    rebuildUi();

    try {
      final body = <String, String>{
        "name": nameController.text,
        "contact_number": phoneController.text,
        "address": addressController.text,
      };

      final response = await _apiService.postTextAndMultiPart(
        url,
        body,
        [imageFile!],
      );

      await _userService.fetchCurrentUser();

      _navigationService.back();

      await _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        title: 'Success',
        message: response['message'],
      );

      logger.info("Update User: $response");
      logger.info("Update User Status: ${response['message']}");
    } on ApiException catch (e) {
      logger.error("Update User Status failed - API Exception", e);
      await _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: 'Error',
        message: e.message,
      );
    } catch (e) {
      logger.error("Update User Status failed - Unknown error", e);
      await _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: 'Error',
        message: "Something went wrong",
      );
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
