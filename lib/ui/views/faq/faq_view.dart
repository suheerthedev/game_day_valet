import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/faq_item_model.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/views/faq/faq_viewmodel.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class FaqView extends StackedView<FaqViewModel> {
  const FaqView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FaqViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            'Frequently Asked Questions',
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.faqItems.length,
                      itemBuilder: (context, index) {
                        return _buildFAQItem(context, viewModel, index,
                            viewModel.faqItems[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10.h);
                      },
                    ),
                  ],
                ))));
  }

  Widget _buildFAQItem(
    BuildContext context,
    FaqViewModel viewModel,
    int index,
    FaqItemModel faqItem,
  ) {
    return Container(
      width: 340.w,
      height: faqItem.isExpanded ? 115.h : 58.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          GestureDetector(
            onTap: () => viewModel.toggleExpansion(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faqItem.question,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    faqItem.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // Answer (only visible when expanded)
          if (faqItem.isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                faqItem.answer,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  FaqViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FaqViewModel();
}
