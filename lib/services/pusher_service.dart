import 'dart:convert';

import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:http/http.dart' as http;
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static const String _appKey = '018b37a23cdaa32a0f1c';
  static const String _cluster = 'ap2';
  static final String _authEndpoint = '${ApiConfig.baseUrl}/broadcasting/auth';

  final _apiService = locator<ApiService>();
  PusherChannelsFlutter? _pusher;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _pusher = PusherChannelsFlutter.getInstance();
    final headers = await _apiService.getPusherHeaders();

    await _pusher!.init(
      apiKey: _appKey,
      cluster: _cluster,
      authEndpoint: _authEndpoint,
      authParams: {'headers': headers},
      onConnectionStateChange: (currentState, previousState) {
        logger.info('Pusher Connection: $currentState');
      },
      onError: (message, code, error) {
        logger.error('Pusher Error: $message');
      },
      onAuthorizer: (channelName, socketId, options) async {
        logger.info(socketId.toString());
        //   // ignore: prefer_typing_uninitialized_variables
        var json;
        try {
          var authUrl = '${ApiConfig.baseUrl}/broadcasting/auth';
          logger.info('socket_id=$socketId&channel_name=$channelName');

          var result = await http.post(
            Uri.parse(authUrl),
            headers: headers,
            body: 'socket_id=$socketId&channel_name=$channelName',
          );
          logger.info("result: ${result.body.toString()}");
          try {
            json = jsonDecode(result.body);
          } catch (e) {
            return {};
          }

          logger.info(json.toString());

          return json;
        } catch (e) {
          logger.error("Error :${e.toString()}");
        }
      },
    );
    await _pusher!.connect();
    _isInitialized = true;
  }

  Future<void> subscribeToChannel(
      String userId, Function(dynamic) onMessageReceived) async {
    if (_isInitialized) {
      await initialize();
    }

    final myChannel = await _pusher!.subscribe(
      channelName: 'conversation.$userId',
      onEvent: (event) {
        logger.info("New message received: ${event.eventName} - ${event.data}");

        onMessageReceived(event.data);
      },
    );

    logger.info("My Channel: ${myChannel.channelName}");
  }

  Future<void> unsubscribeFromChannel(String userId) async {
    if (_pusher != null) {
      await _pusher!.unsubscribe(channelName: 'conversation.$userId');
      logger.info('Unsubscribed from: conversation.$userId');
    }
  }

  Future<void> disconnect() async {
    if (_pusher != null) {
      await _pusher!.disconnect();
      _isInitialized = false;
    }
  }
}
