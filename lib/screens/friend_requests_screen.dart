import 'package:flutter/material.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreenContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderContainer(
              child: Column(
                children: [
                  Row(
                    children: [
                      BackButtonWidget(),
                      SizedBox(
                        width: AppConstants.mainContainerWidth(context) * 0.01,
                      ),
                      Expanded(
                        child: Text(
                          'Friend Requests',
                          style: TextStyle(
                            fontSize: AppConstants.isTablet(context)
                                ? AppConstants.fontSizeMediumResponsive(context)
                                : AppConstants.fontSizeLargeResponsive(context),
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: AppConstants.mainContainerWidth(context) * 0.95,
              child: Column(
                children: DataManager.getFriendRequests()
                    .map(
                      (friendRequest) => VisualizeFriendRequestPreview(
                        friendRequest: friendRequest,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
