import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'chat_viewmodel.dart';

// ignore: must_be_immutable
class ChatView extends StackedView<ChatViewModel> {
  final int? conversationId;
  late ChatViewModel _viewModel;
  ChatView({Key? key, this.conversationId}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatViewModel viewModel,
    Widget? child,
  ) {
    _viewModel = viewModel;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: MainAppBar(
          title: Text(
        "GDV Chat",
        style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      )),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Chat(
              showUserNames: false,
              inputOptions: InputOptions(
                  textEditingController: viewModel.messageController,
                  sendButtonVisibilityMode: SendButtonVisibilityMode.always),
              theme: _buildChatTheme(),
              bubbleBuilder: _bubbleBuilder,
              messages: viewModel.chatMessages,
              onSendPressed: (types.PartialText text) {
                viewModel.handleSendPressed(text);
              },
              user: viewModel.currentUserForChat!,
            ),
    );
  }

  ChatTheme _buildChatTheme() {
    return DefaultChatTheme(
      deliveredIcon: const Icon(
        Icons.check,
        color: AppColors.white,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      primaryColor: AppColors.secondary,
      secondaryColor: const Color(0xfff5f5f7),
      inputBackgroundColor: AppColors.primary,
      inputTextColor: AppColors.white,
      inputTextCursorColor: AppColors.white,
      inputBorderRadius: BorderRadius.circular(20.r),
      messageBorderRadius: 20.r,
      inputMargin: EdgeInsets.all(16.w),
      inputPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      userAvatarNameColors: const [AppColors.secondary],
    );
  }

  Widget _bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    final isCurrentUser =
        message.author.id == _viewModel.messages.first.senderId.toString();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: nextMessageInGroup ? 0.h : 8.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.grey300 : AppColors.secondary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  @override
  ChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatViewModel(conversationId: conversationId);

  @override
  void onViewModelReady(ChatViewModel viewModel) {
    if (conversationId != null) {
      viewModel.getConversationMessages(conversationId!);
    }
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(ChatViewModel viewModel) {
    viewModel.clearMessages();
    super.onDispose(viewModel);
  }
}
