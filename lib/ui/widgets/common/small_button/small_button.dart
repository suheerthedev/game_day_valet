import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'small_button_model.dart';

class SmallButton extends StackedView<SmallButtonModel> {
  const SmallButton({super.key});

  @override
  Widget builder(
    BuildContext context,
    SmallButtonModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  SmallButtonModel viewModelBuilder(
    BuildContext context,
  ) =>
      SmallButtonModel();
}
