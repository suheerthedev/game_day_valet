import 'package:flutter/material.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/views/home/home_view.dart';
import 'package:game_day_valet/ui/views/rental_booking/rental_booking_view.dart';
import 'package:game_day_valet/ui/views/rental_status/rental_status_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
        children: const [
          HomeView(),
          RentalBookingView(),
          RentalStatusView(),
          HomeView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.scaffoldBackground,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.primary,
        currentIndex: viewModel.currentIndex,
        onTap: (index) => viewModel.setCurrentIndex(index),
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(
                Iconsax.home_2,
              ),
              icon: Icon(
                Iconsax.home_2_copy,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Iconsax.calendar_2,
              ),
              icon: Icon(
                Iconsax.calendar_2_copy,
              ),
              label: 'Rental Booking'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Iconsax.box_tick,
              ),
              icon: Icon(
                Iconsax.box_tick_copy,
              ),
              label: 'Rental Status'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Iconsax.user,
              ),
              icon: Icon(
                Iconsax.user_copy,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();
}
