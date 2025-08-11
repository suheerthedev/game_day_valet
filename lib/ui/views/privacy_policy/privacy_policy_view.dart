import 'package:floating_chat_button/floating_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'privacy_policy_viewmodel.dart';

class PrivacyPolicyView extends StackedView<PrivacyPolicyViewModel> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PrivacyPolicyViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          hasSubtitle: true,
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          subtitle: viewModel.privacyPolicies.isNotEmpty
              ? Text(
                  'Last Updated: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(viewModel.privacyPolicies.first.updatedAt ?? ''))}',
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textHint),
                )
              : null,
        ),
        body: SafeArea(
            child: viewModel.isBusy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        child: ListView.builder(
                            itemCount: viewModel.privacyPolicies.length,
                            itemBuilder: (context, index) {
                              return Html(
                                  data: viewModel
                                      .privacyPolicies[index].description);
                            }),
                      ),
                      // SingleChildScrollView(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       _buildSection(
                      //         '1. Acceptance of Terms',
                      //         'By using GDV, you agree to these Terms of Service. If you do not agree, please do not use our platform.',
                      //       ),
                      //       SizedBox(height: 24.h),
                      //       _buildSection(
                      //         '2. User Conduct',
                      //         'You Agree Not to:',
                      //         bulletPoints: [
                      //           'Violate any laws or regulations.',
                      //           'Use our platform for any unlawful or unauthorized purpose.',
                      //           'Transmit any viruses, malware, or harmful code.',
                      //           'Attempt to gain unauthorized access to our systems.',
                      //         ],
                      //       ),
                      //       SizedBox(height: 24.h),
                      //       _buildSection(
                      //         '4. Privacy',
                      //         'Our Privacy Policy explains how we collect, use, and protect your information. By using GDV, you consent to the practices outlined in our Privacy Policy.',
                      //       ),
                      //       SizedBox(height: 24.h),
                      //       _buildSection(
                      //         '5. Termination',
                      //         'We reserve the right to terminate or suspend your account for any reason without notice.',
                      //       ),
                      //       SizedBox(height: 24.h),
                      //       _buildSection(
                      //         '5. Damage Waiver',
                      //         'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                      //       ),
                      //       SizedBox(height: 40.h),
                      //     ],
                      //   ),
                      // ),
                      FloatingChatButton(
                        onTap: (_) {
                          viewModel.onChatTap();
                        },
                        chatIconWidget: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Icon(
                            Iconsax.message_2_copy,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        messageBackgroundColor: AppColors.secondary,
                        chatIconBorderColor: AppColors.secondary,
                        chatIconBackgroundColor: AppColors.secondary,
                        messageBorderWidth: 2,
                        messageText: "You've received a message!",
                        messageTextStyle: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white),
                        showMessageParameters: ShowMessageParameters(
                            delayDuration: const Duration(seconds: 2),
                            durationToShowMessage: const Duration(seconds: 5)),
                      )
                    ],
                  )));
  }

  @override
  PrivacyPolicyViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PrivacyPolicyViewModel();

  @override
  void onViewModelReady(PrivacyPolicyViewModel viewModel) {
    viewModel.getPrivacyPolicy();
    super.onViewModelReady(viewModel);
  }
}
