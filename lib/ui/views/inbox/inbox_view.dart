import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'inbox_viewmodel.dart';

class InboxView extends StackedView<InboxViewModel> {
  const InboxView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InboxViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: MainAppBar(
        title: Text(
          'Chat Inbox',
          style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: viewModel.conversations.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.h,
                      color: AppColors.grey200,
                    ),
                    itemBuilder: (context, index) {
                      final conversation = viewModel.conversations[index];
                      if (viewModel.conversations.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          viewModel.navigateToChatView(conversation.id);
                        },
                        leading: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: AppColors.secondary,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.r),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl: conversation
                                        .responder?.profileImage ??
                                    "https://ui-avatars.com/api/?name=${conversation.responder?.name}",
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                    IconsaxPlusLinear.user,
                                    color: AppColors.white,
                                    size: 20.r),
                              )),
                        ),
                        title: Text(conversation.responder?.name ?? "Unknown",
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        subtitle: Text(
                            conversation.messages?.last.content ??
                                "No messages",
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textHint)),
                      );
                    },
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.startNewConversation();
        },
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: const Icon(IconsaxPlusLinear.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusLinear.message,
              size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No conversations yet',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  @override
  InboxViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InboxViewModel();

  @override
  void onViewModelReady(InboxViewModel viewModel) {
    viewModel.getUserConversations();
    super.onViewModelReady(viewModel);
  }
}
