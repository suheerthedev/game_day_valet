import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
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
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    child: ListView.builder(
                        itemCount: viewModel.privacyPolicies.length,
                        itemBuilder: (context, index) {
                          return Html(
                              shrinkWrap: true,
                              data:
                                  viewModel.privacyPolicies[index].description);
                        }),
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
