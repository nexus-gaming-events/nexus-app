import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/classes/user_settings.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:nexus_app/main.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'event.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';

class User extends ApplicationObject {
  final String _token;
  final int id;
  final String username;
  final String email;
  final String imageUrl;
  final List<VisualLink>? games;
  final List<Event>? organizedEvents;
  final List<Event>? recentEvents;

  User({
    required this.id,
    required this.username,
    this.games,
    this.organizedEvents,
    this.recentEvents,
    this.email = '',
    this.imageUrl = '',
  }) : _token = '';

  String setToken(String token) {
    return token;
  }

  String getToken() {
    return _token;
  }
}

class VisualizeUserScreen {
  static late User user;

  static Widget buildFullDetails(
    BuildContext context,
  ) {
    bool isSelf = user.id == DataManager.getSelfUser()!.id;
    bool isFriend = DataManager.isFriend(user.id);
    bool hasSentRequest = DataManager.hasSentFriendRequest(user.id); //If sent them a request
    bool hasPendingFriendRequest = DataManager.hasPendingFriendRequest(user.id); //If they sent me a request
    return Builder(
      builder: (context) => BaseScreenContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: AppConstants.mainContainerWidth(context),
                    height: AppConstants.mainContainerHeight(context) * 0.2,
                    decoration: BoxDecoration(
                      gradient: UserSettings.bannerGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          AppConstants.borderRadiusMedium(context),
                        ),
                        topRight: Radius.circular(
                          AppConstants.borderRadiusMedium(context),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top:
                        AppConstants.mainContainerHeight(context) * 0.2 -
                        AppConstants.iconSizeLarge(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingLarge(context),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMax,
                        ),
                        color: AppConstants.textColor,
                      ),
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMax,
                        ),
                        child: Image.network(
                          user.imageUrl,
                          width: AppConstants.iconSizeLarge(context) * 2,
                          height: AppConstants.iconSizeLarge(context) * 2,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      BackButtonWidget(),
                      SizedBox(
                        width: AppConstants.mainContainerWidth(context) -
                            AppConstants.iconSizeMedium(context)* 2 -
                            AppConstants.paddingLarge(context)* 3,
                      ),
                      user.id == DataManager.getSelfUser()?.id ?
                      PopupMenuButton(
                          padding: EdgeInsets.all(
                            AppConstants.paddingSmall(context) * 0.5,
                          ),
                          icon: Icon(
                            Icons.settings,
                            size: AppConstants.iconSizeMedium(context),
                            color: Colors.white,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit Banner'),
                            ),
                            PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: AppConstants.paddingSmall(context)),
                                  Text('Log Out', style: TextStyle(color: AppConstants.errorColor),),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              // Navigate to edit screen
                              NexusAppState.instance!.returnScreenParams.add([
                                user,
                              ]);
                              NexusAppState.instance!.returnScreenPath.add(
                                'User',
                              );
                              NexusAppState.instance!.updateState(
                                'Settings',
                              );
                            } else if (value == 'logout') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        AppConstants.secondaryColor,
                                    title: Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to log out?',
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: AppConstants.textColor,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          DataManager.logout();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    AppConstants.secondaryColor,
                                                title: Text(
                                                  'Goodbye!',
                                                  style: TextStyle(
                                                    color:
                                                        AppConstants.textColor,
                                                  ),
                                                ),
                                                content: Text(
                                                  'You have been successfully logged out.',
                                                  style: TextStyle(
                                                    color:
                                                        AppConstants.textColor,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();

                                                      NexusAppState.instance!
                                                          .updateState(
                                                            NexusAppState
                                                                .instance!
                                                                .returnScreenPath
                                                                .removeLast(),
                                                            params: NexusAppState
                                                                .instance!
                                                                .returnScreenParams
                                                                .removeLast(),
                                                          );
                                                    },
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: AppConstants
                                                            .textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        )
                
                      : Container(),
                    ],
                  ),
                  
                ],
              ),
              SizedBox(
                height:
                    AppConstants.paddingLarge(context) +
                    AppConstants.iconSizeLarge(context),
              ),
              Text(
                user.username,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLargeResponsive(context),
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.5),
              isSelf ?
              InkWell(
                onTap: () {
                  NexusAppState.instance!.returnScreenParams.add([VisualizeUserScreen.user]);
                  NexusAppState.instance!.returnScreenPath.add('User');
                  NexusAppState.instance!.updateState(
                    'FriendRequests',
                  );
                },
                child: Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.headerHeight(context)*0.5,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: AppConstants.paddingMedium(context),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadiusMedium(context))),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: AppConstants.textColor,
                      size: AppConstants.iconSizeSmall(context),
                    ),
                    SizedBox(width: AppConstants.paddingMedium(context)),
                    Text(
                      "Friend Requests",
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],),
                              ),
              ): 
              isFriend ?
              InkWell(
                onTap: () {
                 DataManager.deleteFriend(user.id);
                },
                child: Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.headerHeight(context)*0.5,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: AppConstants.paddingMedium(context),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.errorColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadiusMedium(context))),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_remove,
                      color: AppConstants.textColor,
                      size: AppConstants.iconSizeSmall(context),
                    ),
                    SizedBox(width: AppConstants.paddingMedium(context)),
                    Text(
                      "Remove Friend",
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],),
                              ),
              )
              :
              hasPendingFriendRequest ?
              InkWell(
                onTap: () {
                 DataManager.acceptFriendRequest(user.id);
                },
                child: Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.headerHeight(context)*0.5,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: AppConstants.paddingMedium(context),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.successColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadiusMedium(context))),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: AppConstants.textColor,
                      size: AppConstants.iconSizeSmall(context),
                    ),
                    SizedBox(width: AppConstants.paddingMedium(context)),
                    Text(
                      "Accept Friend Request",
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],),
                              ),
              )            
              :
              hasSentRequest ?
              InkWell(
                child: Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.headerHeight(context)*0.5,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: AppConstants.paddingMedium(context),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.warningColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadiusMedium(context))),
                ),
                child: Row(
                  children: [
                    SizedBox(width: AppConstants.paddingMedium(context)),
                    Text(
                      "You already sent a Friend Request to ${user.username}",
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],),
                              ),
              )
              :
              InkWell(
                onTap: () {
                 DataManager.sendFriendRequest(user.id);
                },
                child: Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.headerHeight(context)*0.5,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: AppConstants.paddingMedium(context),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.successColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadiusMedium(context))),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: AppConstants.textColor,
                      size: AppConstants.iconSizeSmall(context),
                    ),
                    SizedBox(width: AppConstants.paddingMedium(context)),
                    Text(
                      "Add Friend",
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],),
                              ),
              ),
              SizedBox(height: AppConstants.paddingMedium(context),),
              Container(
                padding: EdgeInsets.only(
                  left: AppConstants.paddingSmall(context),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Expeditions',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: AppConstants.fontSizeLargeResponsive(context),
                  ),
                ),
              ),
              Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.eventListHeight(context) * 0.7,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppConstants.semitransparentTextColor,
                      width: 1.0,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: DataManager.getEventsInvolved()!
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              NexusAppState.instance!.returnScreenParams.add([VisualizeUserScreen.user]);
                              NexusAppState.instance!.returnScreenPath.add('User');
                              NexusAppState.instance!.updateState(
                                'Event',
                                params: [item],
                              );
                            },
                            child: VisualizeEventPreview(event: item),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: AppConstants.paddingSmall(context),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Expeditions',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: AppConstants.fontSizeLargeResponsive(context),
                  ),
                ),
              ),
              Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.eventListHeight(context) * 0.7,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppConstants.semitransparentTextColor,
                      width: 1.0,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: DataManager.getEventsAuthored(user.id)!.map(
                          (item) => InkWell(
                            onTap: () {
                              NexusAppState.instance!.returnScreenParams.add([VisualizeUserScreen.user]);
                              NexusAppState.instance!.returnScreenPath.add('User');
                              NexusAppState.instance!.updateState(
                                'Event',
                                params: [item],
                              );
                            },
                            child: VisualizeEventPreview(event: item),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class VisualizeUserPreview extends StatelessWidget {
  final User user;
  final bool inPlayers;
  final bool inSpectators;

  const VisualizeUserPreview({Key? key, required this.user, this.inPlayers = false, this.inSpectators = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = inPlayers || inSpectators ? AppConstants.iconSizeSmall(context) : AppConstants.iconSizeLarge(context);
    return Card(

      color: user.id == DataManager.getSelfUser()?.id ? (inPlayers ? AppConstants.playerUserColor : inSpectators ? AppConstants.spectatorUserColor : AppConstants.secondaryColor) : AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: (AppConstants.paddingSmall(context) > 3
            ? AppConstants.paddingSmall(context) - 3
            : 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingLarge(context)),
        child: Row(
          children: [
            user.imageUrl.isEmpty
                ? Image.asset(
                    'assets/icons/Neil.png',
                    width: iconSize,
                    height: iconSize,
                  )
                : Image.network(
                    user.imageUrl,
                    width: iconSize,
                    height: iconSize,
                  ),
            SizedBox(width: AppConstants.paddingMedium(context)),
            Expanded(
              child: Text(
                user.username,
                style: TextStyle(
                  fontWeight: user.id == DataManager.getSelfUser()?.id ? FontWeight.bold : FontWeight.normal,
                  fontSize: AppConstants.fontSizeLargeResponsive(context),
                  color: user.id == DataManager.getSelfUser()?.id ? (inPlayers ? AppConstants.playerUserTextColor : inSpectators ? AppConstants.spectatorUserTextColor : AppConstants.textColor) : AppConstants.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
