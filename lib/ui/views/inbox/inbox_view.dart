import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'inbox_viewmodel.dart';

class InboxView extends StackedView<InboxViewModel> {
  const InboxView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InboxViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("InboxView")),
      ),
    );
  }

  @override
  InboxViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InboxViewModel();
}
