import 'package:flutter/material.dart';
import 'package:nexus_app/constants.dart';
import 'package:nexus_app/main.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonWidget({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(NexusAppState.instance!.returnScreenPath.isEmpty.toString());
    return NexusAppState.instance!.returnScreenPath.isEmpty ? SizedBox(width: AppConstants.iconSizeMedium(context)* 1.16 + AppConstants.paddingMedium(context), height: AppConstants.iconSizeMedium(context)) :
    IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: AppConstants.textColor,
        size: AppConstants.iconSizeMedium(context),
      ),
      onPressed: onPressed ?? () {
        NexusAppState.instance!.updateState(NexusAppState.instance!.returnScreenPath.removeLast(),params: NexusAppState.instance!.returnScreenParams.removeLast());
      },
    );
  }
}
