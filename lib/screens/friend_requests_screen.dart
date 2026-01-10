import 'package:flutter/material.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/main.dart';
import '../constants.dart';
import '../widgets/back_button_widget.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.paddingSmall(context),
        right: AppConstants.paddingSmall(context),
        bottom: 0.0,
        top: AppConstants.paddingLarge(context) * 3.5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium(context),
          ),
        ),
        width: AppConstants.mainContainerWidth(context),
        height: AppConstants.mainContainerHeight(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.headerHeight(context),
                padding: EdgeInsets.only(
                  top: (AppConstants.paddingSmall(context) > 3
                      ? AppConstants.paddingSmall(context) - 3
                      : 0),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      AppConstants.borderRadiusMedium(context),
                    ),
                    topRight: Radius.circular(
                      AppConstants.borderRadiusMedium(context),
                    ),
                  ),
                  color: AppConstants.secondaryColor,
                ),
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
                              fontSize: AppConstants.fontSizeXLargeResponsive(
                                context,
                              ),
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
              Column(
                children: NexusAppState.instance!.friendRequests.map((friendRequest) =>
                  VisualizeFriendRequestPreview(friendRequest: friendRequest)
              ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
