import 'package:flutter/material.dart';
import '../constants.dart';

class VisualLink {
  final String id;
  final String? url;
  final String title;
  final Image? previewImage;

  VisualLink({
    required this.id,
    this.url,
    required this.title,
    this.previewImage,
  });
}

class VisualizeVisualLink extends StatelessWidget {
  final VisualLink visualLink;

  const VisualizeVisualLink({Key? key, required this.visualLink})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: AppConstants.paddingSmall(context) - 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
        child: Row(
          children: [
            if (visualLink.previewImage != null)
              Container(
                width: AppConstants.linkIconSize(context),
                height: AppConstants.linkIconSize(context),
                margin: EdgeInsets.only(
                  right: AppConstants.paddingMedium(context),
                ),
                child: visualLink.previewImage,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    visualLink.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeMediumResponsive(context),
                      color: AppConstants.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
