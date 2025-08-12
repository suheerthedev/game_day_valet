import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'main_search_bar_model.dart';

class MainSearchBar extends StackedView<MainSearchBarModel> {
  const MainSearchBar({super.key});

  @override
  Widget builder(
    BuildContext context,
    MainSearchBarModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  MainSearchBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainSearchBarModel();
}
