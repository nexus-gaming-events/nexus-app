import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import '../main.dart';
import '../classes/event.dart';
import '../classes/friend_request.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderContainer(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Welcome to the Nexus!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      AppConstants.fontSizeXLargeResponsive(context) * 1.7,
                  color: AppConstants.textColor,
                ),
              ),
            ),
          ),
          SizedBox(height: AppConstants.mainContainerHeight(context) * 0.01),
          Container(
            padding: EdgeInsets.only(left: AppConstants.paddingSmall(context)),
            alignment: Alignment.centerLeft,
            child: Text(
              'Upcoming Expeditions',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: AppConstants.fontSizeLargeResponsive(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
            width: AppConstants.mainContainerWidth(context),
            height: AppConstants.eventListHeight(context) * 1.5,
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
                children:
                    (DataManager.getEvents()
                          ..sort((a, b) => a.date.compareTo(b.date)))
                        .where((event) => event.date.isAfter(DateTime.now()))
                        .where(
                          (event) => event.maxPlayers > event.currentPlayers,
                        )
                        .where(
                          (event) => !event.participants.contains(
                            DataManager.getSelfUser(),
                          ),
                        )
                        .take(5)
                        .map(
                          (item) => InkWell(
                            onTap: () async{
                              NexusAppState.instance!.returnScreenParams.add(
                                [],
                              );
                              NexusAppState.instance!.returnScreenPath.add(
                                'Home',
                              );
                              NexusAppState.instance!.updateState(
                                'Event',
                                params: [(await DataManager.getEventById(item.id))!],
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
            padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
            alignment: Alignment.centerLeft,
            child: Text(
              'Pending Friend Requests',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: AppConstants.fontSizeLargeResponsive(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
            width: AppConstants.mainContainerWidth(context),
            height: AppConstants.eventListHeight(context) * 1.5,
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
                children:
                    (DataManager.getFriendRequests()
                          ..sort((a, b) => b.date.compareTo(a.date)))
                        .take(5)
                        .map(
                          (item) => InkWell(
                            //onTap: () {},
                            child: VisualizeFriendRequestPreview(
                              friendRequest: item,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
