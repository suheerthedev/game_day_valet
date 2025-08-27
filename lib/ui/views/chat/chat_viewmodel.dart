import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/message_model.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/chat_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatViewModel extends ReactiveViewModel {
  final _chatService = locator<ChatService>();
  final _snackbarService = locator<SnackbarService>();
  final _userService = locator<UserService>();

  int? conversationId;
  ChatViewModel({this.conversationId});

  UserModel? get currentUser => _userService.currentUser;

  List<MessageModel> get messages => _chatService.messages;

  List<types.Message> get chatMessages {
    return convertToChatMessages(messages);
  }

  // Support-side greeting shown each time chat opens
  final types.User _supportUser = const types.User(
    id: 'support',
    firstName: 'Support',
  );

  types.TextMessage get _greetingMessage => types.TextMessage(
        id: 'support_greeting_message',
        text: 'Hey! Glad you stopped by 👋 What’s up with your rental today?',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: _supportUser,
      );

  // Messages to display in UI: greeting (support) + dynamic content
  List<types.Message> get displayMessages {
    final List<types.Message> combined = List.of(chatMessages);
    // Place greeting as the oldest message (at the end) to appear first in the
    // conversation timeline when using newest-first lists.
    combined.add(_greetingMessage);
    return combined;
  }

  List<types.Message> convertToChatMessages(List<MessageModel> messages) {
    return messages.map((message) {
      return types.TextMessage(
        id: message.id.toString(),
        text: message.content ?? '',
        createdAt:
            DateTime.parse(message.createdAt ?? '').millisecondsSinceEpoch,
        author: types.User(
          id: message.senderId.toString(),
          firstName: message.sender?.name ?? '',
        ),
      );
    }).toList();
  }

  types.User? get currentUserForChat => types.User(
        id: currentUser?.id.toString() ?? '',
        firstName: currentUser?.name ?? '',
      );

  void handleSendPressed(types.PartialText message) async {
    if (conversationId != null) {
      _handleSendMessage(message);
    } else {
      _handleStartConversation(message);
    }
  }

  void _handleStartConversation(types.PartialText message) async {
    try {
      final sent = await _chatService.startConversation(message.text);
      logger.info("Sent: $sent");

      conversationId = sent.conversationId;

      // _chatService.addMessageToActiveConversation(sent);

      final newMessage = types.TextMessage(
          author: types.User(
            id: currentUser!.id.toString(),
            firstName: currentUser!.name,
          ),
          id: sent.id.toString(),
          text: sent.content ?? '',
          createdAt:
              DateTime.parse(sent.createdAt ?? '').millisecondsSinceEpoch);

      chatMessages.insert(0, newMessage);
    } on ApiException catch (e) {
      logger.error("Error sending message: $e");
      // _setState(ViewState.error, errorMessage: e.toString());
    } catch (e) {
      logger.error("Error sending message: $e");
    } finally {
      rebuildUi();
    }
  }

  void _handleSendMessage(types.PartialText message) async {
    try {
      final sent =
          await _chatService.sendMessage(message.text, conversationId!);
      logger.info("Sent: $sent");

      // _chatService.addMessageToActiveConversation(sent);

      // final newMessage = types.TextMessage(
      //     author: types.User(
      //       id: currentUser?.id.toString() ?? '',
      //       firstName: currentUser?.name ?? '',
      //     ),
      //     id: sent.id.toString(),
      //     text: sent.content ?? '',
      //     createdAt:
      //         DateTime.parse(sent.createdAt ?? '').millisecondsSinceEpoch);

      // chatMessages.insert(0, newMessage);
    } on ApiException catch (e) {
      logger.error("Error sending message: $e");
      // _setState(ViewState.error, errorMessage: e.toString());
    } catch (e) {
      logger.error("Error sending message: $e");
    } finally {
      rebuildUi();
    }
  }

  void getConversationMessages(int conversationId) async {
    setBusy(true);
    rebuildUi();
    try {
      await _chatService.getConversationMessages(conversationId);

      logger.info("Conversation messages: ${messages.last.content}");
    } on ApiException catch (e) {
      logger.error("Error getting user conversations: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error getting user conversations: $e");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void clearMessages() {
    _chatService.clearMessages();
  }

  TextEditingController messageController = TextEditingController();

  @override
  List<ListenableServiceMixin> get listenableServices => [_chatService];
}
