import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'secondary_tournament_card_model.dart';

class SecondaryTournamentCard
    extends StackedView<SecondaryTournamentCardModel> {
  const SecondaryTournamentCard({super.key});

  @override
  Widget builder(
    BuildContext context,
    SecondaryTournamentCardModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  SecondaryTournamentCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      SecondaryTournamentCardModel();
}
