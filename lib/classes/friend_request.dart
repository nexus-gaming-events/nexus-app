import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import 'application_object.dart';
import '../main.dart';
import 'user.dart';

class FriendRequest extends ApplicationObject {
  int id;
  String username;
  String imageUrl;
  DateTime date;

  FriendRequest({
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.date,
  });
}

class VisualizeFriendRequestPreview extends StatelessWidget {
  final FriendRequest friendRequest;

  const VisualizeFriendRequestPreview({Key? key, required this.friendRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = AppConstants.iconSizeLarge(context);
    return Card(
      color: AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: (AppConstants.paddingSmall(context) > 3
            ? AppConstants.paddingSmall(context) - 3
            : 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingLarge(context)),
        child: InkWell(
            onTap: () async {
                      NexusAppState.instance!.returnScreenPath.add(
                        'FriendRequests',
                      );
                      NexusAppState.instance!.updateState(
                        'User',
                        params: [await DataManager.getUserById(friendRequest.id) ?? User(id: 0, username: 'Unknown', email: '', avatarUrl: '', bannerGradient: {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0})],
                      );
            },
          child: Row(
            children: [
              friendRequest.imageUrl.isEmpty
                  ? Image.asset(
                      'assets/icons/Neil.png',
                      width: iconSize,
                      height: iconSize,
                    )
                  : Image.network(
                      friendRequest.imageUrl,
                      width: iconSize,
                      height: iconSize,
                    ),
              SizedBox(width: AppConstants.paddingMedium(context)),
              Expanded(
                child: Text(
                  friendRequest.username,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: AppConstants.fontSizeLargeResponsive(context),
                    color: AppConstants.textColor,
                  ),
                ),
              ),
              SizedBox(width: AppConstants.paddingMedium(context)),
              Text(
                  friendRequest.date.toLocal().toString().split(' ')[0],
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMediumResponsive(context),
                    color: AppConstants.semitransparentTextColor,
                  )),
              IconButton(
                onPressed: () => {/* Accept friend request logic here */},
                icon: Icon(Icons.check, color: AppConstants.successColor),
                ),
              SizedBox(width: AppConstants.paddingSmall(context)),
              IconButton(
                onPressed: () => {/* Decline friend request logic here */},
                icon: Icon(Icons.close, color: AppConstants.errorColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
