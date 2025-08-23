import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'terms_and_conditions_viewmodel.dart';

class TermsAndConditionsView extends StackedView<TermsAndConditionsViewModel> {
  const TermsAndConditionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TermsAndConditionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("TermsAndConditionsView")),
      ),
    );
  }

  @override
  TermsAndConditionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TermsAndConditionsViewModel();
}
