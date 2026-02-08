import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import '../main.dart';
import '../classes/event.dart';
import '../classes/friend_request.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        width: AppConstants.mainContainerWidth(context),
        height: AppConstants.mainContainerHeight(context),
        //padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium(context),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
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
            SizedBox(height: AppConstants.mainContainerHeight(context) * 0.01),
            Container(
              padding: EdgeInsets.only(
                left: AppConstants.paddingSmall(context),
              ),
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
              height: AppConstants.eventListHeight(context)*1.5,
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
                            ..sort((a, b) => a.date.compareTo(b.date))).where(  
                              (event) => event.date.isAfter(DateTime.now()),
                            ).where(  
                              (event) => event.maxPlayers > event.currentPlayers
                              ).where((event) => !event.participants.contains(DataManager.getSelfUser()))
                          .take(5)
                          .map(
                            (item) => InkWell(
                              onTap: () {
                                NexusAppState.instance!.returnScreenParams.add(
                                  [],
                                );
                                NexusAppState.instance!.returnScreenPath.add(
                                  'Home',
                                );
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
              height: AppConstants.eventListHeight(context)*1.5,
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
      ),
    );
  }
}
