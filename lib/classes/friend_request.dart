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
    double iconSize = AppConstants.isTablet(context) ? AppConstants.iconSizeMedium(context)*0.8 : AppConstants.iconSizeLarge(context);
    if (AppConstants.isTablet(context)) {
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
              SizedBox(width: AppConstants.paddingSmall(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      friendRequest.username,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    SizedBox(height: AppConstants.paddingSmall(context)*0.05),
                    Text(
                      friendRequest.date.toLocal().toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmallResponsive(context),
                        color: AppConstants.semitransparentTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  debugPrint('Accepting friend request from ${friendRequest.username} (ID: ${friendRequest.id})');
                  await DataManager.acceptFriendRequest(friendRequest.id);
                  debugPrint('Accepted friend request from ${friendRequest.username} (ID: ${friendRequest.id})');
                  NexusAppState.instance!.reloadCurrentScreen(); // Reload the screen to update the friend requests list
                },
                icon: Icon(Icons.check, color: AppConstants.successColor),
                ),
              SizedBox(width: AppConstants.paddingSmall(context)),
              IconButton(
                onPressed: () async {
                  await DataManager.removeFriendRequest(friendRequest.id);
                  NexusAppState.instance!.reloadCurrentScreen(); // Remove the request from the list after rejecting
                },
                icon: Icon(Icons.close, color: AppConstants.errorColor),
                ),
            ],
          ),
        ),
      ),
    );
  
    }
    else {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      friendRequest.username,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    SizedBox(height: AppConstants.paddingSmall(context)),
                    Text(
                      friendRequest.date.toLocal().toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMediumResponsive(context),
                        color: AppConstants.semitransparentTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  debugPrint('Accepting friend request from ${friendRequest.username} (ID: ${friendRequest.id})');
                  await DataManager.acceptFriendRequest(friendRequest.id);
                  debugPrint('Accepted friend request from ${friendRequest.username} (ID: ${friendRequest.id})');
                  NexusAppState.instance!.reloadCurrentScreen(); // Reload the screen to update the friend requests list
                },
                icon: Icon(Icons.check, color: AppConstants.successColor),
                ),
              SizedBox(width: AppConstants.paddingSmall(context)),
              IconButton(
                onPressed: () async {
                  await DataManager.removeFriendRequest(friendRequest.id);
                  NexusAppState.instance!.reloadCurrentScreen(); // Remove the request from the list after rejecting
                },
                icon: Icon(Icons.close, color: AppConstants.errorColor),
                ),
            ],
          ),
        ),
      ),
    );
  
    }
   }
}
