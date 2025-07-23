import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'rental_history_viewmodel.dart';

class RentalHistoryView extends StackedView<RentalHistoryViewModel> {
  const RentalHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RentalHistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("RentalHistoryView")),
      ),
    );
  }

  @override
  RentalHistoryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalHistoryViewModel();
}
