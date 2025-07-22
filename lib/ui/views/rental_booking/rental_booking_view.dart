import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'rental_booking_viewmodel.dart';

class RentalBookingView extends StackedView<RentalBookingViewModel> {
  const RentalBookingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RentalBookingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("RentalBookingView")),
      ),
    );
  }

  @override
  RentalBookingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalBookingViewModel();
}
