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
        backgroundColor: Color(int.parse(viewModel.colorCode)),
        appBar: MainAppBar(
          title: Text(
            'FAQs',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: ListView.separated(
                  itemCount: viewModel.faqItems.length,
                  itemBuilder: (context, index) {
                    return _buildFAQItem(
                        context, viewModel, index, viewModel.faqItems[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10.h);
                  },
                ),
              )));
  }

  Widget _buildFAQItem(
    BuildContext context,
    FaqViewModel viewModel,
    int index,
    FaqItemModel faqItem,
  ) {
    return AnimatedContainer(
      width: 340.w,
      // Remove fixed height to allow content to determine the size
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use min size to prevent extra space
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
                      faqItem.title ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: faqItem.isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Answer with smooth size + fade animation
          ClipRect(
            child: AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  faqItem.description ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              crossFadeState: faqItem.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOut,
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

  @override
  void onViewModelReady(FaqViewModel viewModel) {
    viewModel.getFaqs();
    super.onViewModelReady(viewModel);
  }
}
