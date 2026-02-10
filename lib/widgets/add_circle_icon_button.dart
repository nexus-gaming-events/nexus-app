import 'package:flutter/material.dart';
import '../constants.dart';

/// A reusable widget for the add circle IconButton used throughout the app.
///
/// [onPressed] is required. Optionally, you can override [iconColor], [iconSize], [alignment], and [containerHeight].
class AddCircleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? iconColor;
  final double? iconSize;
  final AlignmentGeometry alignment;
  final double? containerHeight;

  const AddCircleIconButton({
    Key? key,
    required this.onPressed,
    this.iconColor,
    this.iconSize,
    this.alignment = Alignment.bottomRight,
    this.containerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double resolvedIconSize = AppConstants.isTablet(context) ? AppConstants.iconSizeMedium(context) : AppConstants.iconSizeLarge(context);
    final double resolvedContainerHeight = resolvedIconSize * 1.1;
    return Container(
      height: resolvedContainerHeight,
      alignment: alignment,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.add_circle,
          color: iconColor ?? AppConstants.accentColor2,
          size: resolvedIconSize,
        ),
      ),
    );
  }
}