import 'package:flutter/material.dart';
import 'package:nexus_app/main.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'user.dart';
import 'application_object.dart';

class Event extends ApplicationObject {
  final int id;
  final String title;
  final User author;
  final String description;
  final DateTime date;
  final int maxPlayers;
  final int maxSpectators;
  final List<User>? players;
  final List<User>? spectators;
  final List<String>? games;
  final List<String>? links;

  Event({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.date,
    required this.maxPlayers,
    required this.maxSpectators,
    this.players,
    this.spectators,
    this.games,
    this.links,
  });
}

class VisualizeEventScreen {
  static bool _showingEventDetails = false;
  static User? _activeUser;

  static Widget buildFullDetails(
    Event event,
    BuildContext context,
    String returnScreenTitle,
  ) {
    return _showingEventDetails && _activeUser != null
        ? VisualizeUserScreen.buildFullDetails(_activeUser!)
        : Padding(
            padding: EdgeInsets.only(
              left: AppConstants.paddingSmall(context),
              right: AppConstants.paddingSmall(context),
              bottom: 0.0,
              top: AppConstants.paddingMedium(context),
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
                    width: AppConstants.mainContainerWidth(context),
                    height: AppConstants.headerHeight(context),
                    padding: EdgeInsets.only(
                      top: AppConstants.paddingSmall(context) - 3,
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
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppConstants.textColor,
                          ),
                          onPressed: () {
                            debugPrint('Returning to $returnScreenTitle screen');
                            NexusAppState().updateState(returnScreenTitle);
                          },
                        ),
                        SizedBox(
                          width:
                              AppConstants.mainContainerWidth(context) * 0.01,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${event.author.username}\'s',
                                style: TextStyle(
                                  color: AppConstants.semitransparentTextColor,
                                  fontSize:
                                      AppConstants.fontSizeSmallResponsive(
                                        context,
                                      ) -
                                      1,
                                ),
                              ),
                              Text(
                                event.title,
                                style: TextStyle(
                                  color: AppConstants.textColor,
                                  fontSize:
                                      AppConstants.fontSizeXLargeResponsive(
                                        context,
                                      ) +
                                      2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${event.date.year}/${event.date.month}/${event.date.day} ${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: AppConstants.textColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppConstants.mainContainerHeight(context) * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      AppConstants.paddingMedium(context),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: AppConstants.descriptionWidth(context),
                          height: AppConstants.descriptionHeight(context),
                          //padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppConstants.descriptionPrimaryColor,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium(context),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: AppConstants.descriptionWidth(context),
                                height: AppConstants.sectionHeaderHeight(
                                  context,
                                ),
                                padding: EdgeInsets.only(
                                  top: AppConstants.paddingSmall(context) - 5,
                                  left: AppConstants.paddingMedium(context),
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
                                  color: AppConstants.descriptionSecondaryColor,
                                ),
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                    color: AppConstants.textColor,
                                    fontSize:
                                        AppConstants.fontSizeLargeResponsive(
                                          context,
                                        ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(
                                    AppConstants.paddingSmall(context),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: AppConstants.paddingMedium(context),
                                      right: AppConstants.paddingMedium(
                                        context,
                                      ),
                                      bottom:
                                          AppConstants.paddingSmall(context) -
                                          2,
                                      top:
                                          AppConstants.paddingSmall(context) -
                                          2,
                                    ),
                                    child: Text(
                                      event.description,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: AppConstants.paddingMedium(context) - 3,
                            ),
                            Container(
                              width: AppConstants.playerBoxWidth(context),
                              height: AppConstants.playerBoxHeight(context),
                              //padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: AppConstants.playersPrimaryColor,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium(context),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: AppConstants.playerBoxWidth(context),
                                    height: AppConstants.sectionHeaderHeight(
                                      context,
                                    ),
                                    padding: EdgeInsets.only(
                                      top:
                                          AppConstants.paddingSmall(context) -
                                          5,
                                      left: AppConstants.paddingMedium(context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          AppConstants.borderRadiusMedium(
                                            context,
                                          ),
                                        ),
                                        topRight: Radius.circular(
                                          AppConstants.borderRadiusMedium(
                                            context,
                                          ),
                                        ),
                                      ),
                                      color: AppConstants.playersSecondaryColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Players      ',
                                          style: TextStyle(
                                            color: AppConstants.textColor,
                                            fontSize:
                                                AppConstants.fontSizeLargeResponsive(
                                                  context,
                                                ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppConstants.screenWidth(
                                            context,
                                            0.11,
                                          ).clamp(75.0, 85.0),
                                        ),
                                        Text(
                                          textAlign: TextAlign.start,
                                          '${event.players == null ? 0 : event.players!.length}/${event.maxPlayers}',
                                          style: TextStyle(
                                            color: AppConstants
                                                .semitransparentTextColor,
                                            fontSize:
                                                AppConstants.fontSizeLargeResponsive(
                                                  context,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.all(
                                            AppConstants.paddingSmall(context),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: AppConstants.paddingMedium(
                                                context,
                                              ),
                                              right: AppConstants.paddingMedium(
                                                context,
                                              ),
                                              bottom:
                                                  AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2,
                                              top:
                                                  AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2,
                                            ),
                                            child:
                                                event.players == null ||
                                                    event.players!.isEmpty
                                                ? Container()
                                                : Column(
                                                    children: event.players!
                                                        .map(
                                                          (item) => InkWell(
                                                            onTap: () {
                                                              NexusAppState()
                                                                  .updateState(
                                                                    'Event',
                                                                    params: [
                                                                      item,
                                                                    ],
                                                                  );
                                                            },
                                                            child:
                                                                VisualizeUserPreview(
                                                                  user: item,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: AppConstants.screenHeight(
                                          context,
                                          0.115,
                                        ).clamp(75.0, 90.0),
                                        left: AppConstants.paddingSmall(
                                          context,
                                        ),
                                        right: AppConstants.paddingSmall(
                                          context,
                                        ),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          height: AppConstants.joinButtonHeight(
                                            context,
                                          ),
                                          width: AppConstants.joinButtonWidth(
                                            context,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppConstants.secondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                AppConstants.borderRadiusMedium(
                                                      context,
                                                    ) *
                                                    2,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: AppConstants.paddingSmall(
                                                context,
                                              ),
                                              left: AppConstants.paddingSmall(
                                                context,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Join as Player      ',
                                                  style: TextStyle(
                                                    color: AppConstants
                                                        .semitransparentTextColor,
                                                    fontSize:
                                                        AppConstants.fontSizeMediumResponsive(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      AppConstants.screenWidth(
                                                        context,
                                                        0.16,
                                                      ).clamp(
                                                        48.0,
                                                        AppConstants.screenWidth(
                                                          context,
                                                          0.13,
                                                        ),
                                                      ),
                                                ),
                                                Icon(
                                                  Icons.add_circle,
                                                  color: AppConstants
                                                      .playersButtonColor,
                                                  size: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: AppConstants.paddingLarge(context) + 7,
                            ),
                            Container(
                              width: AppConstants.playerBoxWidth(context),
                              height: AppConstants.playerBoxHeight(context),
                              //padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: AppConstants.spectatorsPrimaryColor,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium(context),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: AppConstants.playerBoxWidth(context),
                                    height: AppConstants.sectionHeaderHeight(
                                      context,
                                    ),
                                    padding: EdgeInsets.only(
                                      top:
                                          AppConstants.paddingSmall(context) -
                                          5,
                                      left: AppConstants.paddingMedium(context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          AppConstants.borderRadiusMedium(
                                            context,
                                          ),
                                        ),
                                        topRight: Radius.circular(
                                          AppConstants.borderRadiusMedium(
                                            context,
                                          ),
                                        ),
                                      ),
                                      color:
                                          AppConstants.spectatorsSecondaryColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Spectators',
                                          style: TextStyle(
                                            color: AppConstants.textColor,
                                            fontSize:
                                                AppConstants.fontSizeLargeResponsive(
                                                  context,
                                                ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppConstants.screenWidth(
                                            context,
                                            0.11,
                                          ).clamp(75.0, 85.0),
                                        ),
                                        Text(
                                          textAlign: TextAlign.start,
                                          '${event.spectators == null ? 0 : event.spectators!.length}/${event.maxSpectators}',
                                          style: TextStyle(
                                            color: AppConstants
                                                .semitransparentTextColor,
                                            fontSize:
                                                AppConstants.fontSizeLargeResponsive(
                                                  context,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.all(
                                            AppConstants.paddingSmall(context),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: AppConstants.paddingMedium(
                                                context,
                                              ),
                                              right: AppConstants.paddingMedium(
                                                context,
                                              ),
                                              bottom:
                                                  AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2,
                                              top:
                                                  AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2,
                                            ),
                                            child:
                                                event.spectators == null ||
                                                    event.spectators!.isEmpty
                                                ? Container()
                                                : Column(
                                                    children: event.spectators!
                                                        .map(
                                                          (item) => InkWell(
                                                            onTap: () {
                                                              NexusAppState()
                                                                  .updateState(
                                                                    'Event',
                                                                    params: [
                                                                      item,
                                                                    ],
                                                                  );
                                                            },
                                                            child:
                                                                VisualizeUserPreview(
                                                                  user: item,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: AppConstants.screenHeight(
                                          context,
                                          0.115,
                                        ).clamp(75.0, 90.0),
                                        left: AppConstants.paddingSmall(
                                          context,
                                        ),
                                        right: AppConstants.paddingSmall(
                                          context,
                                        ),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          height: AppConstants.joinButtonHeight(
                                            context,
                                          ),
                                          width: AppConstants.joinButtonWidth(
                                            context,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppConstants.secondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                AppConstants.borderRadiusMedium(
                                                      context,
                                                    ) *
                                                    2,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: AppConstants.paddingSmall(
                                                context,
                                              ),
                                              left: AppConstants.paddingSmall(
                                                context,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Join as Spectator',
                                                  style: TextStyle(
                                                    color: AppConstants
                                                        .semitransparentTextColor,
                                                    fontSize:
                                                        AppConstants.fontSizeMediumResponsive(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      AppConstants.screenWidth(
                                                        context,
                                                        0.16,
                                                      ).clamp(
                                                        48.0,
                                                        AppConstants.screenWidth(
                                                          context,
                                                          0.13,
                                                        ),
                                                      ),
                                                ),
                                                Icon(
                                                  Icons.add_circle,
                                                  color: AppConstants
                                                      .spectatorsButtonColor,
                                                  size: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
                        Container(
                          width: AppConstants.descriptionWidth(context),
                          height: AppConstants.descriptionHeight(context) * 0.6,
                          //padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppConstants.gamesPrimaryColor,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium(context),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: AppConstants.descriptionWidth(context),
                                height: AppConstants.sectionHeaderHeight(
                                  context,
                                ),
                                padding: EdgeInsets.only(
                                  top: AppConstants.paddingSmall(context) - 5,
                                  left: AppConstants.paddingMedium(context),
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
                                  color: AppConstants.gamesSecondaryColor,
                                ),
                                child: Text(
                                  'Games',
                                  style: TextStyle(
                                    color: AppConstants.textColor,
                                    fontSize:
                                        AppConstants.fontSizeLargeResponsive(
                                          context,
                                        ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(
                                    AppConstants.paddingSmall(context),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: AppConstants.paddingMedium(context),
                                      right: AppConstants.paddingMedium(
                                        context,
                                      ),
                                      bottom:
                                          AppConstants.paddingSmall(context) -
                                          2,
                                      top:
                                          AppConstants.paddingSmall(context) -
                                          2,
                                    ),
                                    child:
                                        event.games == null ||
                                            event.games!.isEmpty
                                        ? Container()
                                        : Column(
                                            children: event.games!
                                                .map(
                                                  (game) => Text(
                                                    game,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: AppConstants
                                                          .textColor,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
                        Container(
                          width: AppConstants.descriptionWidth(context),
                          height: AppConstants.descriptionHeight(context) * 0.6,
                          //padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppConstants.linksPrimaryColor,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium(context),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: AppConstants.descriptionWidth(context),
                                height: AppConstants.sectionHeaderHeight(
                                  context,
                                ),
                                padding: EdgeInsets.only(
                                  top: AppConstants.paddingSmall(context) - 5,
                                  left: AppConstants.paddingMedium(context),
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
                                  color: AppConstants.linksSecondaryColor,
                                ),
                                child: Text(
                                  'Links',
                                  style: TextStyle(
                                    color: AppConstants.textColor,
                                    fontSize:
                                        AppConstants.fontSizeLargeResponsive(
                                          context,
                                        ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(
                                    AppConstants.paddingSmall(context),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: AppConstants.paddingMedium(context),
                                      right: AppConstants.paddingMedium(
                                        context,
                                      ),
                                      bottom:
                                          AppConstants.paddingSmall(context) -
                                          2,
                                      top:
                                          AppConstants.paddingSmall(context) -
                                          2,
                                    ),
                                    child:
                                        event.links == null ||
                                            event.links!.isEmpty
                                        ? Container()
                                        : Column(
                                            children: event.links!
                                                .map(
                                                  (link) => Text(
                                                    link,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: AppConstants
                                                          .textColor,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                  ),
                                ),
                              ),
                            ],
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

class VisualizeEventPreview extends StatelessWidget {
  final Event event;

  const VisualizeEventPreview({Key? key, required this.event})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: AppConstants.paddingSmall(context),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${event.author.username}'s",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize:
                          AppConstants.fontSizeSmallResponsive(context),
                      color: AppConstants.semitransparentTextColor,
                    ),
                  ),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeMediumResponsive(context),
                      color: AppConstants.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppConstants.paddingMedium(context),
              ),
              child: Text(
                "${event.players == null ? 0 : event.players!.length}/${event.maxPlayers}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSizeSmallResponsive(context),
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
