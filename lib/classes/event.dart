import 'package:flutter/material.dart';
import 'package:nexus_app/main.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'user.dart';
import 'application_object.dart';

class Event extends ApplicationObject{
  final String id;
  final String title;
  final String author;
  final String description;
  final DateTime date;
  final int maxPlayers;
  final int maxSpectators;
  final List<User>? players;
  final List<User>? spectators;
  final List<VisualLink>? games;
  final List<VisualLink>? links;

  Event ({
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

class VisualizeEventScreen{
  static bool _showingEventDetails = false;
  static User? _activeUser;

  static Widget buildFullDetails(Event event) {
    return _showingEventDetails && _activeUser != null
        ? VisualizeUserScreen.buildFullDetails(_activeUser!)
        : Container(
            width: 600,
            height: 600,
            //padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 600,
                  height: 80,
                  padding: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
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
                          NexusAppState().updateState('Calendar');
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${event.author}\'s',
                              style: TextStyle(
                                color: AppConstants.semitransparentTextColor,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              event.title,
                              style: TextStyle(
                                color: AppConstants.textColor,
                                fontSize: 22,
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
                //const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 450,
                        height: 130,
                        //padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppConstants.descriptionPrimaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 450,
                              height: 30,
                              padding: EdgeInsets.only(top: 3.0, left: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                color: AppConstants.descriptionSecondaryColor,
                              ),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  color: AppConstants.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 6.0,
                                    top: 6.0,
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
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 12),
                          Container(
                            width: 215,
                            height: 130,
                            //padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppConstants.playersPrimaryColor,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  width: 215,
                                  height: 30,
                                  padding: EdgeInsets.only(
                                    top: 3.0,
                                    left: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    color: AppConstants.playersSecondaryColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Players',
                                        style: TextStyle(
                                          color: AppConstants.textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 85),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${event.players == null ? 0 : event.players!.length}/${event.maxPlayers}',
                                        style: TextStyle(
                                          color: AppConstants
                                              .semitransparentTextColor,
                                          fontSize: 18,
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
                                        padding: EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12.0,
                                            bottom: 6.0,
                                            top: 6.0,
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
                                                            NexusAppState().updateState('Event', params: [item]);
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
                                      top: 85,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        height: 20,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: AppConstants.secondaryColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                            left: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Join as Player',
                                                style: TextStyle(
                                                  color: AppConstants
                                                      .semitransparentTextColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(width: 78),
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
                          const SizedBox(width: 20),
                          Container(
                            width: 215,
                            height: 130,
                            //padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppConstants.spectatorsPrimaryColor,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  width: 215,
                                  height: 30,
                                  padding: EdgeInsets.only(
                                    top: 3.0,
                                    left: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 55),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${event.spectators == null ? 0 : event.spectators!.length}/${event.maxSpectators}',
                                        style: TextStyle(
                                          color: AppConstants
                                              .semitransparentTextColor,
                                          fontSize: 18,
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
                                        padding: EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12.0,
                                            bottom: 6.0,
                                            top: 6.0,
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
                                                            NexusAppState().updateState('Event', params: [item]);
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
                                      top: 85,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        height: 20,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: AppConstants.secondaryColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                            left: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Join as Spectator',
                                                style: TextStyle(
                                                  color: AppConstants
                                                      .semitransparentTextColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(width: 55),
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
                      const SizedBox(height: 12),
                      Container(
                        width: 450,
                        height: 90,
                        //padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppConstants.gamesPrimaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 450,
                              height: 30,
                              padding: EdgeInsets.only(top: 3.0, left: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                color: AppConstants.gamesSecondaryColor,
                              ),
                              child: Text(
                                'Games',
                                style: TextStyle(
                                  color: AppConstants.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 6.0,
                                    top: 6.0,
                                  ),
                                  child:
                                      event.games == null ||
                                          event.games!.isEmpty
                                      ? Container()
                                      : Column(
                                          children: event.games!
                                              .map(
                                                (game) => Text(
                                                  game.title,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color:
                                                        AppConstants.textColor,
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
                      const SizedBox(height: 12),
                      Container(
                        width: 450,
                        height: 90,
                        //padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppConstants.linksPrimaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 450,
                              height: 30,
                              padding: EdgeInsets.only(top: 3.0, left: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                color: AppConstants.linksSecondaryColor,
                              ),
                              child: Text(
                                'Links',
                                style: TextStyle(
                                  color: AppConstants.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 6.0,
                                    top: 6.0,
                                  ),
                                  child:
                                      event.links == null ||
                                          event.links!.isEmpty
                                      ? Container()
                                      : Column(
                                          children: event.links!
                                              .map(
                                                (link) => Text(
                                                  link.title,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color:
                                                        AppConstants.textColor,
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
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${event.author}'s",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 7.0,
                      color: AppConstants.semitransparentTextColor,
                    ),
                  ),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: AppConstants.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "${event.players == null ? 0 : event.players!.length}/${event.maxPlayers}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
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
