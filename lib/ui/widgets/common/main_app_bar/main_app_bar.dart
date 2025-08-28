import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'main_app_bar_model.dart';

class MainAppBar extends StackedView<MainAppBarModel>
    implements PreferredSizeWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final bool hasLeading;
  final bool hasSubtitle;
  final bool hasNotification;
  final List<Widget> extraActions;

  const MainAppBar(
      {super.key,
      required this.title,
      this.subtitle,
      this.leading,
      this.hasLeading = true,
      this.hasSubtitle = false,
      this.hasNotification = true,
      this.extraActions = const []});

  @override
  Widget builder(
    BuildContext context,
    MainAppBarModel viewModel,
    Widget? child,
  ) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: true,
      // elevation: 10,
      // shadowColor: AppColors.primary.withOpacity(0.1),

      title: Row(
        children: [
          if (hasLeading) leading ?? const SizedBox.shrink(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (hasSubtitle) subtitle ?? const SizedBox.shrink(),
            ],
          ),
        ],
      ),
      actionsPadding: EdgeInsets.only(right: 16.w),
      actions: [
        ...extraActions,
        if (hasNotification) ...[
          GestureDetector(
            onTap: () {
              viewModel.onNotificationTap();
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.secondary.withOpacity(0.1),
              child: Center(
                child: Icon(IconsaxPlusBold.notification,
                    size: 24.w, color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  MainAppBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainAppBarModel();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
