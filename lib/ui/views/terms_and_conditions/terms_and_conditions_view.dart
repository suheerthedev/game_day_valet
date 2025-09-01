import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'terms_and_conditions_viewmodel.dart';

class TermsAndConditionsView extends StackedView<TermsAndConditionsViewModel> {
  const TermsAndConditionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TermsAndConditionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Color(int.parse(viewModel.colorCode)),
        appBar: MainAppBar(
          hasSubtitle: true,
          title: Text(
            'Terms & Conditions',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          subtitle: viewModel.terms.isNotEmpty
              ? Text(
                  'Last Updated: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(viewModel.terms.first.updatedAt ?? ''))}',
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
                        itemCount: viewModel.terms.length,
                        itemBuilder: (context, index) {
                          return Html(
                              shrinkWrap: true,
                              data: viewModel.terms[index].description);
                        }),
                  )));
  }

  @override
  TermsAndConditionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TermsAndConditionsViewModel();

  @override
  void onViewModelReady(TermsAndConditionsViewModel viewModel) {
    viewModel.getTerms();
    super.onViewModelReady(viewModel);
  }
}
