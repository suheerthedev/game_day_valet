import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/views/home/home_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MainViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: viewModel.currentIndex,
        children: List.generate(viewModel.screens.length,
            (index) => viewModel.screens[index] ?? const SizedBox.shrink()),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.scaffoldBackground,
        indicatorColor: Colors.transparent,
        // selectedItemColor: AppColors.secondary,
        // unselectedItemColor: AppColors.primary,
        selectedIndex: viewModel.currentIndex,
        onDestinationSelected: viewModel.onTabTapped,
        labelTextStyle: WidgetStatePropertyAll(GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        )),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(IconsaxPlusBold.home_2),
            icon: Icon(IconsaxPlusLinear.home_2),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconsaxPlusBold.status),
            icon: Icon(IconsaxPlusLinear.status),
            label: "Status",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconsaxPlusBold.user),
            icon: Icon(IconsaxPlusLinear.user),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();

  @override
  void onViewModelReady(MainViewModel viewModel) {
    viewModel.screens = [
      const HomeView(),
      null,
      null,
      null,
    ];
    super.onViewModelReady(viewModel);
  }
}
