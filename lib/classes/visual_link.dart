import 'package:flutter/material.dart';
import '../constants.dart';

class VisualLink{
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

    const VisualizeVisualLink({Key? key, required this.visualLink}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Card(
          color: AppConstants.secondaryColor,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                if (visualLink.previewImage != null)
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 12.0),
                    child: visualLink.previewImage,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        visualLink.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
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