import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'privacy_policy_viewmodel.dart';

class PrivacyPolicyView extends StackedView<PrivacyPolicyViewModel> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PrivacyPolicyViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("PrivacyPolicyView")),
      ),
    );
  }

  @override
  PrivacyPolicyViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PrivacyPolicyViewModel();
}
