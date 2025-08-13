import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'chat_viewmodel.dart';

class ChatView extends StackedView<ChatViewModel> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatViewModel viewModel,
    Widget? child,
  ) {
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
      body: Chat(
        showUserNames: false,
        inputOptions: InputOptions(
            textEditingController: viewModel.messageController,
            sendButtonVisibilityMode: SendButtonVisibilityMode.always),
        theme: _buildChatTheme(),
        //  bubbleBuilder: _bubbleBuilder,
        messages: [],
        onSendPressed: (types.PartialText text) {},
        user: const types.User(id: "1", firstName: "John", lastName: "Doe"),
      ),
    );
  }

  ChatTheme _buildChatTheme() {
    return DefaultChatTheme(
      backgroundColor: AppColors.scaffoldBackground,
      primaryColor: AppColors.secondary,
      secondaryColor: const Color(0xfff5f5f7),
      inputBackgroundColor: AppColors.primary,
      inputTextColor: AppColors.white,
      inputBorderRadius: BorderRadius.circular(20.r),
      messageBorderRadius: 20.r,
      inputMargin: EdgeInsets.all(16.w),
      inputPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      userAvatarNameColors: const [AppColors.secondary],
    );
  }

  // Widget _bubbleBuilder(
  //   Widget child, {
  //   required types.Message message,
  //   required bool nextMessageInGroup,
  // }) {
  //   final isCurrentUser =
  //       message.author.id == _viewModel.currentUserForChat!.id;

  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 8.w,
  //       vertical: nextMessageInGroup ? 0.h : 8.h,
  //     ),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: isCurrentUser ? AppColors.secondary : AppColors.white,
  //         borderRadius: BorderRadius.circular(16.r),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 5,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: child,
  //     ),
  //   );
  // }

  @override
  ChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatViewModel();
}
