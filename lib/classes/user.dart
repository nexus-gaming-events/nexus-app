import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/classes/user_settings.dart';
import 'package:nexus_app/main.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'event.dart';
import '../main.dart';
import '../widgets/back_button_widget.dart';

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
    return Builder(
      builder: (context) => Padding(
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
                    height: AppConstants.mainContainerHeight(context) * 0.3,
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
                        AppConstants.mainContainerHeight(context) * 0.3 -
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
                      user.id == NexusAppState.instance!.selfUser!.id ?
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: AppConstants.textColor,
                          size: AppConstants.iconSizeMedium(context),
                        ),
                        onPressed: () {
                          NexusAppState.instance!.returnScreenParams.add([VisualizeUserScreen.user]);
                          NexusAppState.instance!.returnScreenPath.add('User');
                          NexusAppState.instance!.updateState(
                            'Settings',
                          );
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
                  fontSize: AppConstants.fontSizeLargeResponsive(context),
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.5),
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
                    children: NexusAppState.instance!.events
                        .where(
                          (event) => event.players!.any(
                            (player) => player.id == user.id,
                          ),
                        )
                        .toList()
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
                    children: NexusAppState.instance!.events
                        .where((event) => event.author.id == user.id)
                        .toList()
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
            ],
          ),
        ),
      ),
    );
  }
}

class VisualizeUserPreview extends StatelessWidget {
  final User user;

  const VisualizeUserPreview({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: (AppConstants.paddingSmall(context) > 4
            ? AppConstants.paddingSmall(context) - 4
            : 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
        child: Row(
          children: [
            user.imageUrl.isEmpty
                ? Image.asset(
                    'assets/icons/Neil.png',
                    width: AppConstants.iconSizeSmall(context),
                    height: AppConstants.iconSizeSmall(context),
                  )
                : Image.network(
                    user.imageUrl,
                    width: AppConstants.iconSizeSmall(context),
                    height: AppConstants.iconSizeSmall(context),
                  ),
            Expanded(
              child: Text(
                user.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSizeMediumResponsive(context),
                  color: AppConstants.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
