import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'connectivity_wrapper_model.dart';

class ConnectivityWrapper extends StackedView<ConnectivityWrapperModel> {
  final Widget child;
  final Widget? offlineWidget;
  const ConnectivityWrapper(
      {super.key, required this.child, this.offlineWidget});

  @override
  Widget builder(
    BuildContext context,
    ConnectivityWrapperModel viewModel,
    Widget? child,
  ) {
    return Column(
      children: [
        if (!viewModel.isOnline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        Expanded(
          child: viewModel.isOnline ? this.child : offlineWidget ?? this.child,
        )
      ],
    );
  }

  @override
  ConnectivityWrapperModel viewModelBuilder(
    BuildContext context,
  ) =>
      ConnectivityWrapperModel();

  @override
  void onViewModelReady(ConnectivityWrapperModel viewModel) {
    viewModel.initializeConnectivity();
    super.onViewModelReady(viewModel);
  }
}
