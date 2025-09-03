import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'edit_profile_viewmodel.dart';

class EditProfileView extends StackedView<EditProfileViewModel> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EditProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: MainAppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: viewModel.pickImage,
                            child: Container(
                              width: 100.r,
                              height: 100.r,
                              decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(50.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.2),
                                      blurRadius: 10.r,
                                      offset: Offset(0, 5.h),
                                    ),
                                  ]),
                              child: Stack(children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(50.r),
                                      child: Image(
                                        image: viewModel.profileImageProvider,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(IconsaxPlusLinear.user,
                                                    size: 24.w,
                                                    color: AppColors.white),
                                        width: 100.w,
                                        height: 100.h,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.secondary,
                                        width: 2.w,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 15.r,
                                      backgroundColor: AppColors.white,
                                      child: Icon(Icons.edit,
                                          size: 20.w,
                                          color: AppColors.secondary),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          MainTextField(
                            label: 'Name',
                            controller: viewModel.nameController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: true,
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(IconsaxPlusLinear.edit)),
                            suffixIconColor: AppColors.primary,
                          ),
                          SizedBox(height: 10.h),
                          MainTextField(
                            label: 'Email',
                            readOnly: true,
                            controller: viewModel.emailController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: true,
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(IconsaxPlusLinear.edit)),
                            suffixIconColor: AppColors.primary,
                          ),
                          SizedBox(height: 10.h),
                          MainTextField(
                            label: 'Phone',
                            controller: viewModel.phoneController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: true,
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(IconsaxPlusLinear.edit)),
                            suffixIconColor: AppColors.primary,
                          ),
                          SizedBox(height: 10.h),
                          MainTextField(
                            label: 'Address',
                            controller: viewModel.addressController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: true,
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(IconsaxPlusLinear.edit)),
                            suffixIconColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MainButton(
                      text: 'Save',
                      onTap: viewModel.save,
                      textColor: AppColors.white,
                      borderColor: AppColors.secondary,
                    ),
                  ),
                ]),
              ),
      ),
    );
  }

  @override
  EditProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EditProfileViewModel();

  @override
  void onViewModelReady(EditProfileViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
