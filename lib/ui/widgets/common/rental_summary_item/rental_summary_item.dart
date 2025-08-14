import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'rental_summary_item_model.dart';

class RentalSummaryItem extends StackedView<RentalSummaryItemModel> {
  const RentalSummaryItem({super.key});

  @override
  Widget builder(
    BuildContext context,
    RentalSummaryItemModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  RentalSummaryItemModel viewModelBuilder(
    BuildContext context,
  ) => RentalSummaryItemModel();
}
