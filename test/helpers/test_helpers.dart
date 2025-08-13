import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:game_day_valet/services/connectivity_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/google_sign_in_service.dart';
import 'package:game_day_valet/services/stripe_service.dart';
import 'package:game_day_valet/services/chat_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<ApiService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<SecureStorageService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<AuthService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<UserService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<ConnectivityService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<LoggerService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<GoogleSignInService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<StripeService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<ChatService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
  ],
)
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterApiService();
  getAndRegisterSecureStorageService();
  getAndRegisterAuthService();
  getAndRegisterUserService();
  getAndRegisterConnectivityService();
  getAndRegisterLoggerService();
  getAndRegisterGoogleSignInService();
  getAndRegisterStripeService();
  getAndRegisterChatService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(
    service.showCustomSheet<T, T>(
      enableDrag: anyNamed('enableDrag'),
      enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
      exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
      ignoreSafeArea: anyNamed('ignoreSafeArea'),
      isScrollControlled: anyNamed('isScrollControlled'),
      barrierDismissible: anyNamed('barrierDismissible'),
      additionalButtonTitle: anyNamed('additionalButtonTitle'),
      variant: anyNamed('variant'),
      title: anyNamed('title'),
      hasImage: anyNamed('hasImage'),
      imageUrl: anyNamed('imageUrl'),
      showIconInMainButton: anyNamed('showIconInMainButton'),
      mainButtonTitle: anyNamed('mainButtonTitle'),
      showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
      secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
      showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
      takesInput: anyNamed('takesInput'),
      barrierColor: anyNamed('barrierColor'),
      barrierLabel: anyNamed('barrierLabel'),
      customData: anyNamed('customData'),
      data: anyNamed('data'),
      description: anyNamed('description'),
    ),
  ).thenAnswer(
    (realInvocation) =>
        Future.value(showCustomSheetResponse ?? SheetResponse<T>()),
  );

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockApiService getAndRegisterApiService() {
  _removeRegistrationIfExists<ApiService>();
  final service = MockApiService();
  locator.registerSingleton<ApiService>(service);
  return service;
}

MockSecureStorageService getAndRegisterSecureStorageService() {
  _removeRegistrationIfExists<SecureStorageService>();
  final service = MockSecureStorageService();
  locator.registerSingleton<SecureStorageService>(service);
  return service;
}

MockAuthService getAndRegisterAuthService() {
  _removeRegistrationIfExists<AuthService>();
  final service = MockAuthService();
  locator.registerSingleton<AuthService>(service);
  return service;
}

MockUserService getAndRegisterUserService() {
  _removeRegistrationIfExists<UserService>();
  final service = MockUserService();
  locator.registerSingleton<UserService>(service);
  return service;
}

MockConnectivityService getAndRegisterConnectivityService() {
  _removeRegistrationIfExists<ConnectivityService>();
  final service = MockConnectivityService();
  locator.registerSingleton<ConnectivityService>(service);
  return service;
}

MockLoggerService getAndRegisterLoggerService() {
  _removeRegistrationIfExists<LoggerService>();
  final service = MockLoggerService();
  locator.registerSingleton<LoggerService>(service);
  return service;
}

MockGoogleSignInService getAndRegisterGoogleSignInService() {
  _removeRegistrationIfExists<GoogleSignInService>();
  final service = MockGoogleSignInService();
  locator.registerSingleton<GoogleSignInService>(service);
  return service;
}

MockStripeService getAndRegisterStripeService() {
  _removeRegistrationIfExists<StripeService>();
  final service = MockStripeService();
  locator.registerSingleton<StripeService>(service);
  return service;
}

MockChatService getAndRegisterChatService() {
  _removeRegistrationIfExists<ChatService>();
  final service = MockChatService();
  locator.registerSingleton<ChatService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
