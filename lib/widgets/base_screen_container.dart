import 'package:flutter/material.dart';
import '../constants.dart';

/// A reusable base container widget that wraps screen content with standard padding,
/// dimensions, and styling used across the application.
class BaseScreenContainer extends StatelessWidget {
  /// The child widget to display inside the container
  final Widget child;

  /// Optional alignment for the container. Defaults to no specific alignment.
  final AlignmentGeometry? alignment;

  /// Optional custom decoration. If not provided, uses default styling with
  /// primaryColor background and medium border radius.
  final BoxDecoration? decoration;

  const BaseScreenContainer({
    Key? key,
    required this.child,
    this.alignment,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AppConstants.isTablet(context)) {
      return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.paddingSmall(context),
        right: AppConstants.paddingSmall(context),
        bottom: 0.0,
        top: AppConstants.paddingSmall(context) * 3.5,
      ),
      child: Container(
        alignment: alignment,
        width: AppConstants.mainContainerWidth(context),
        height: AppConstants.mainContainerHeight(context),
        decoration:
            decoration ??
            BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium(context),
              ),
            ),
        child: child,
      ),
    );
  
    }
    else {
      return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.paddingSmall(context),
        right: AppConstants.paddingSmall(context),
        bottom: 0.0,
        top: AppConstants.paddingLarge(context) * 3.5,
      ),
      child: Container(
        alignment: alignment,
        width: AppConstants.mainContainerWidth(context),
        height: AppConstants.mainContainerHeight(context),
        decoration:
            decoration ??
            BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium(context),
              ),
            ),
        child: child,
      ),
    );
  
    }
    }
}
