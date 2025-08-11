import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_rentals_viewmodel.dart';

class AddRentalsView extends StackedView<AddRentalsViewModel> {
  const AddRentalsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddRentalsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("AddRentalsView")),
      ),
    );
  }

  @override
  AddRentalsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddRentalsViewModel();
}
