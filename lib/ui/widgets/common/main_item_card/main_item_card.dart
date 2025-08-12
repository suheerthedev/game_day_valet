import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'main_item_card_model.dart';

class MainItemCard extends StackedView<MainItemCardModel> {
  const MainItemCard({super.key});

  @override
  Widget builder(
    BuildContext context,
    MainItemCardModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  MainItemCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainItemCardModel();
}
