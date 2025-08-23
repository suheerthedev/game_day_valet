import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked_services/stacked_services.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  // Required for background isolate
  await Firebase.initializeApp();
  logger.info('🔕 [BG] FCM: ${message.messageId} data=${message.data}');
  // Keep work here light (log/analytics). No UI or heavy IO.
}

class PushNotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _navigatorService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  static String? fcmToken;

  //Local Notification
  static final _local = FlutterLocalNotificationsPlugin();
  static const _androidChannel = AndroidNotificationChannel(
    'high_importance',
    'High Importance Notifications',
    description: 'Used for important notfications',
    importance: Importance.high,
  );

  Future<void> init(BuildContext context) async {
    // 1) Background handler
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    // 2) iOS foreground presentation (lets iOS show banner in-foreground)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3) Initialize local notifications (foreground banners & custom Android channel)
    await _initLocalNotifications();

    // 4) Ask permission (iOS + Android 13+)
    await _requestPermissions();

    // 5) Token get + upload to backend
    final token = await _messaging.getToken();
    logger.info('📲 FCM token: $token');
    fcmToken = token;
    FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
      logger.info('🔁 FCM token refreshed: $t');
      fcmToken = t;
    });

    // 6) Foreground messages → show a local notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 7) App opened from background by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 8) App launched from terminated by tapping notification
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleNotificationTap(initial);
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings(
      '@drawable/ic_stat_notification',
    );
    const iosInit = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    // Android: ensure channel exists
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      // iOS specific:
      announcement: false,
      criticalAlert: false,
      provisional: false,
      carPlay: false,
    );
    logger.info('🔐 Notification permission: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      _snackbarService.showSnackbar(
        message: 'Notifications are disabled. Enable in Settings for updates.',
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    final n = message.notification;
    // If the server sends only "data" (no notification block), you can build a custom title/body from data.
    final title = n?.title ?? message.data['title'];
    final body = n?.body ?? message.data['body'];

    await _local.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_stat_notification',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    logger.info('🔔 Opened from notification: ${message.data}');
    // Example deep-linking based on data payload:
    final screen = message.data['screen'];
    final id = message.data['id'];
    if (screen == 'order' && id != null) {
      _navigatorService.navigateTo('/order', arguments: id);
    }
  }
}
