import 'package:flutter/material.dart';
import '../constants.dart';

/// A reusable header container widget with standard styling used across app screens.
/// Features rounded top corners, secondary color background, and consistent dimensions.
class HeaderContainer extends StatelessWidget {
  /// The child widget to display inside the header
  final Widget child;

  /// Optional custom padding value. If not provided, uses paddingSmall.
  final double? customPadding;

  const HeaderContainer({Key? key, required this.child, this.customPadding})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = customPadding ?? AppConstants.paddingSmall(context);

    return Container(
      width: AppConstants.mainContainerWidth(context),
      height: AppConstants.headerHeight(context),
      padding: EdgeInsets.only(top: (padding > 3 ? padding - 3 : 0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadiusMedium(context)),
          topRight: Radius.circular(AppConstants.borderRadiusMedium(context)),
        ),
        color: AppConstants.secondaryColor,
      ),
      child: child,
    );
  }
}
