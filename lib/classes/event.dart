import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_app/classes/chat.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:nexus_app/main.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'user.dart';
import 'application_object.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/number_selector.dart';
import 'package:table_calendar/table_calendar.dart';

class Event extends ApplicationObject {
  int id;
  String title;
  User author;
  String description;
  DateTime date;
  int maxPlayers;
  int maxSpectators;
  List<User>? players;
  List<User>? spectators;
  List<String>? games;
  List<String>? links;
  late Chat? chat;
  late List<User> participants;

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
  }) {
    chat = Chat(eventId: id, messages: []);

    participants = [];
    if (players != null) {
      participants.addAll(players!);
    }
    if (spectators != null) {
      participants.addAll(spectators!);
    }
  }
}

class VisualizeEventScreen extends StatefulWidget {
  final Event? event;

  const VisualizeEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<VisualizeEventScreen> createState() => _VisualizeEventScreenState();
}

class _VisualizeEventScreenState extends State<VisualizeEventScreen> {
  late bool isUserInPlayers;
  late bool isUserInSpectators;
  late bool isUserAuthor;
  late Event event;

  @override
  void initState() {
    super.initState();
    _updateUserStatus();
  }

  void _updateUserStatus() {
    isUserInPlayers = DataManager.isUserInPlayers(
      DataManager.getSelfUser()!.id,
      widget.event?.id ?? -1,
    );
    isUserInSpectators = DataManager.isUserInSpectators(
      DataManager.getSelfUser()!.id,
      widget.event?.id ?? -1,
    );
    isUserAuthor = DataManager.isAuthor(
      DataManager.getSelfUser()!.id,
      widget.event?.id ?? -1,
    );
  }

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
              width: AppConstants.mainContainerWidth(context),
              height: AppConstants.headerHeight(context) * 1.1,
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
              child: Row(
                children: [
                  BackButtonWidget(),
                  SizedBox(
                    width: AppConstants.mainContainerWidth(context) * 0.01,
                  ),
                  Container(
                    width: AppConstants.mainContainerWidth(context) * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.event!.author.username}\'s',
                          style: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                            fontSize:
                                (AppConstants.fontSizeSmallResponsive(context) >
                                    1
                                ? AppConstants.fontSizeSmallResponsive(
                                        context,
                                      ) -
                                      1
                                : 0),
                          ),
                        ),
                        Text(
                          widget.event!.title,
                          style: TextStyle(
                            color: AppConstants.textColor,
                            fontSize: () {
                              final baseFontSize =
                                  AppConstants.fontSizeXLargeResponsive(
                                    context,
                                  ) +
                                  2;
                              final titleLength = widget.event!.title.length;
                              if (titleLength <= 15) return baseFontSize;
                              if (titleLength <= 25) return baseFontSize - 2;
                              if (titleLength <= 35) return baseFontSize - 4;
                              return (baseFontSize - 6).clamp(
                                AppConstants.fontSizeMediumResponsive(context),
                                baseFontSize,
                              );
                            }(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.event!.date.year}/${widget.event!.date.month}/${widget.event!.date.day} ${widget.event!.date.hour}:${widget.event!.date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: AppConstants.textColor),
                        ),
                      ],
                    ),
                  ),
                  (!isUserInSpectators && !isUserInPlayers)
                      ? Container(width: AppConstants.iconSizeMedium(context))
                      : IconButton(
                          padding: EdgeInsets.all(
                            AppConstants.paddingSmall(context) * 0.5,
                          ),
                          constraints: BoxConstraints(),
                          icon: ImageIcon(
                            size: AppConstants.iconSizeMedium(context),
                            Image.asset('assets/icons/chat.png').image,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            NexusAppState.instance!.returnScreenParams.add([
                              widget.event!,
                            ]);
                            NexusAppState.instance!.returnScreenPath.add(
                              'Event',
                            );
                            NexusAppState.instance!.updateState(
                              'Chat',
                              params: [widget.event!.chat!],
                            );
                          },
                        ),
                  (!isUserAuthor)
                      ? Container(width: AppConstants.iconSizeMedium(context))
                      : PopupMenuButton(
                          padding: EdgeInsets.all(
                            AppConstants.paddingSmall(context) * 0.5,
                          ),
                          icon: Icon(
                            Icons.more_vert,
                            size: AppConstants.iconSizeMedium(context),
                            color: Colors.white,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit Event'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete Event'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              // Navigate to edit screen
                              NexusAppState.instance!.returnScreenParams.add([
                                widget.event!,
                              ]);
                              NexusAppState.instance!.returnScreenPath.add(
                                'Event',
                              );
                              NexusAppState.instance!.updateState(
                                'EditEvent',
                                params: [widget.event!],
                              );
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        AppConstants.secondaryColor,
                                    title: Text(
                                      'Delete Event',
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this event? This action cannot be undone.',
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
                                          DataManager.deleteEvent(widget.event!.id);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    AppConstants.secondaryColor,
                                                title: Text(
                                                  'Event Deleted',
                                                  style: TextStyle(
                                                    color: AppConstants.textColor,
                                                  ),
                                                ),
                                                content: Text(
                                                  'The event has been successfully deleted.',
                                                  style: TextStyle(
                                                    color: AppConstants.textColor,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      
                                                      
                                                      NexusAppState.instance!.updateState(
                                                        NexusAppState
                                                          .instance!
                                                          .returnScreenPath
                                                          .removeLast(),
                                                        params: NexusAppState
                                                          .instance!
                                                          .returnScreenParams
                                                          .removeLast()
                                                      );
                                                    },
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: AppConstants.textColor,
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
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                ],
              ),
            ),
            SizedBox(height: AppConstants.mainContainerHeight(context) * 0.01),
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
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
                          height: AppConstants.sectionHeaderHeight(context),
                          padding: EdgeInsets.only(
                            top: (AppConstants.paddingSmall(context) > 5
                                ? AppConstants.paddingSmall(context) - 5
                                : 0),
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
                              fontSize: AppConstants.fontSizeLargeResponsive(
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
                                right: AppConstants.paddingMedium(context),
                                bottom: (AppConstants.paddingSmall(context) > 2
                                    ? AppConstants.paddingSmall(context) - 2
                                    : 0),
                                top: (AppConstants.paddingSmall(context) > 2
                                    ? AppConstants.paddingSmall(context) - 2
                                    : 0),
                              ),
                              child: Text(
                                widget.event!.description,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: AppConstants.textColor),
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
                        width: (AppConstants.paddingMedium(context) > 3
                            ? AppConstants.paddingMedium(context) - 3
                            : 0),
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
                              height: AppConstants.sectionHeaderHeight(context),
                              padding: EdgeInsets.only(
                                top: (AppConstants.paddingSmall(context) > 5
                                    ? AppConstants.paddingSmall(context) - 5
                                    : 0),
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
                                    width:
                                        AppConstants.screenWidth(
                                          context,
                                          0.08,
                                        ).clamp(
                                          AppConstants.screenWidth(
                                            context,
                                            0.05,
                                          ),
                                          AppConstants.screenWidth(
                                            context,
                                            0.13,
                                          ),
                                        ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    '${widget.event!.players == null ? 0 : widget.event!.players!.length}/${widget.event!.maxPlayers}',
                                    style: TextStyle(
                                      color:
                                          AppConstants.semitransparentTextColor,
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
                                SizedBox(
                                  height:
                                      AppConstants.playerBoxHeight(context) -
                                      AppConstants.sectionHeaderHeight(context),
                                  width: AppConstants.playerBoxWidth(context),
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
                                            (AppConstants.paddingSmall(
                                                  context,
                                                ) >
                                                2
                                            ? AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2
                                            : 0),
                                        top:
                                            (AppConstants.paddingSmall(
                                                  context,
                                                ) >
                                                2
                                            ? AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2
                                            : 0),
                                      ),
                                      child:
                                          widget.event!.players == null ||
                                              widget.event!.players!.isEmpty
                                          ? Container()
                                          : Column(
                                              children: widget.event!.players!
                                                  .map(
                                                    (item) => InkWell(
                                                      onTap: () {
                                                        NexusAppState
                                                            .instance!
                                                            .returnScreenParams
                                                            .add([
                                                              widget.event!,
                                                            ]);
                                                        NexusAppState
                                                            .instance!
                                                            .returnScreenPath
                                                            .add('Event');
                                                        NexusAppState()
                                                            .updateState(
                                                              'User',
                                                              params: [item],
                                                            );
                                                      },
                                                      child:
                                                          VisualizeUserPreview(
                                                            user: item,
                                                            inPlayers: true,
                                                            inSpectators: false,
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
                                    0.5,
                                  ).clamp(75.0, 160.0),
                                  left: AppConstants.paddingSmall(context),
                                  right: AppConstants.paddingSmall(context),
                                  child:
                                      isUserInSpectators ||
                                          isUserAuthor ||
                                          widget.event!.players!.length >=
                                              widget.event!.maxPlayers
                                      ? Container()
                                      : Container(
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
                                            child: InkWell(
                                              onTap: () {
                                                if (isUserInPlayers) {
                                                  DataManager.leaveEvent(
                                                    widget.event!.id,
                                                  );
                                                  setState(() {
                                                    isUserInPlayers = false;
                                                    widget.event!.players!
                                                        .removeWhere(
                                                          (user) =>
                                                              user.id ==
                                                              DataManager.getSelfUser()!
                                                                  .id,
                                                        );
                                                  });
                                                } else {
                                                  DataManager.joinEvent(
                                                    widget.event!.id,
                                                    "player",
                                                  );
                                                  setState(() {
                                                    isUserInPlayers = true;
                                                    widget.event!.players!.add(
                                                      DataManager.getSelfUser()!,
                                                    );
                                                  });
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    isUserInPlayers
                                                        ? 'Leave as Player     '
                                                        : 'Join as Player      ',
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
                                                          0.09,
                                                        ).clamp(
                                                          AppConstants.screenWidth(
                                                            context,
                                                            0.05,
                                                          ),
                                                        AppConstants.screenWidth(
                                                            context,
                                                            isUserInPlayers ? 0.075 : 0.09,
                                                          ),
                                                        ),
                                                  ),
                                                  isUserInPlayers
                                                      ? Icon(
                                                          Icons.remove_circle,
                                                          color: AppConstants
                                                              .playersButtonColor,
                                                          size: 14,
                                                        )
                                                      : Icon(
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppConstants.paddingLarge(context) * 1.2),
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
                              height: AppConstants.sectionHeaderHeight(context),
                              padding: EdgeInsets.only(
                                top: (AppConstants.paddingSmall(context) > 5
                                    ? AppConstants.paddingSmall(context) - 5
                                    : 0),
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
                                color: AppConstants.spectatorsSecondaryColor,
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
                                    width:
                                        AppConstants.screenWidth(
                                          context,
                                          0.08,
                                        ).clamp(
                                          AppConstants.screenWidth(
                                            context,
                                            0.05,
                                          ),
                                          AppConstants.screenWidth(
                                            context,
                                            0.13,
                                          ),
                                        ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    '${widget.event!.spectators == null ? 0 : widget.event!.spectators!.length}/${widget.event!.maxSpectators}',
                                    style: TextStyle(
                                      color:
                                          AppConstants.semitransparentTextColor,
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
                                SizedBox(
                                  height:
                                      AppConstants.playerBoxHeight(context) -
                                      AppConstants.sectionHeaderHeight(context),
                                  width: AppConstants.playerBoxWidth(context),
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
                                            (AppConstants.paddingSmall(
                                                  context,
                                                ) >
                                                2
                                            ? AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2
                                            : 0),
                                        top:
                                            (AppConstants.paddingSmall(
                                                  context,
                                                ) >
                                                2
                                            ? AppConstants.paddingSmall(
                                                    context,
                                                  ) -
                                                  2
                                            : 0),
                                      ),
                                      child:
                                          widget.event!.spectators == null ||
                                              widget.event!.spectators!.isEmpty
                                          ? Container()
                                          : Column(
                                              children: widget
                                                  .event!
                                                  .spectators!
                                                  .map(
                                                    (item) => InkWell(
                                                      onTap: () {
                                                        NexusAppState
                                                            .instance!
                                                            .returnScreenParams
                                                            .add([
                                                              widget.event!,
                                                            ]);
                                                        NexusAppState
                                                            .instance!
                                                            .returnScreenPath
                                                            .add('Event');
                                                        NexusAppState()
                                                            .updateState(
                                                              'User',
                                                              params: [item],
                                                            );
                                                      },
                                                      child:
                                                          VisualizeUserPreview(
                                                            user: item,
                                                            inPlayers: false,
                                                            inSpectators: true,
                                                          ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:  AppConstants.screenHeight(
                                    context,
                                    0.5,
                                  ).clamp(75.0, 160.0),
                                  left: AppConstants.paddingSmall(context),
                                  right: AppConstants.paddingSmall(context),
                                  child:
                                      isUserInPlayers ||
                                          isUserAuthor ||
                                          widget.event!.players!.length >=
                                              widget.event!.maxPlayers
                                      ? Container()
                                      : Container(
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
                                            child: InkWell(
                                              onTap: () {
                                                if (isUserInSpectators) {
                                                  DataManager.leaveEvent(
                                                    widget.event!.id,
                                                  );
                                                  setState(() {
                                                    isUserInSpectators = false;
                                                    widget.event!.spectators!
                                                        .removeWhere(
                                                          (user) =>
                                                              user.id ==
                                                              DataManager.getSelfUser()!
                                                                  .id,
                                                        );
                                                  });
                                                } else {
                                                  DataManager.joinEvent(
                                                    widget.event!.id,
                                                    "spectator",
                                                  );
                                                  setState(() {
                                                    isUserInSpectators = true;
                                                    widget.event!.spectators!.add(
                                                      DataManager.getSelfUser()!,
                                                    );
                                                  });
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    isUserInSpectators
                                                        ? 'Leave as Spectator'
                                                        : 'Join as Spectator ',
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
                                                          0.083,
                                                        ).clamp(
                                                          AppConstants.screenWidth(
                                                            context,
                                                            0.05,
                                                          ),
                                                          AppConstants.screenWidth(
                                                            context,
                                                            isUserInSpectators ? 0.067 : 0.085,
                                                          ),
                                                        ),
                                                  ),
                                                  isUserInSpectators
                                                      ? Icon(
                                                          Icons.remove_circle,
                                                          color: AppConstants
                                                              .spectatorsButtonColor,
                                                          size: 14,
                                                        )
                                                      : Icon(
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
                          height: AppConstants.sectionHeaderHeight(context),
                          padding: EdgeInsets.only(
                            top: (AppConstants.paddingSmall(context) > 5
                                ? AppConstants.paddingSmall(context) - 5
                                : 0),
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
                              fontSize: AppConstants.fontSizeLargeResponsive(
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
                                right: AppConstants.paddingMedium(context),
                                bottom: (AppConstants.paddingSmall(context) > 2
                                    ? AppConstants.paddingSmall(context) - 2
                                    : 0),
                                top: (AppConstants.paddingSmall(context) > 2
                                    ? AppConstants.paddingSmall(context) - 2
                                    : 0),
                              ),
                              child:
                                  widget.event!.games == null ||
                                      widget.event!.games!.isEmpty
                                  ? Container()
                                  : Column(
                                      children: widget.event!.games!
                                          .map(
                                            (game) => Text(
                                              game,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: AppConstants.textColor,
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
                          height: AppConstants.sectionHeaderHeight(context),
                          padding: EdgeInsets.only(
                            top: (AppConstants.paddingSmall(context) > 5
                                ? AppConstants.paddingSmall(context) - 5
                                : 0),
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
                              fontSize: AppConstants.fontSizeLargeResponsive(
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
                                right: AppConstants.paddingMedium(context),
                                bottom: (AppConstants.paddingSmall(context) > 2
                                    ? AppConstants.paddingSmall(context) - 2
                                    : 0),
                                top: (AppConstants.paddingSmall(context) > 2
                                    ? AppConstants.paddingSmall(context) - 2
                                    : 0),
                              ),
                              child:
                                  widget.event!.links == null ||
                                      widget.event!.links!.isEmpty
                                  ? Container()
                                  : Column(
                                      children: widget.event!.links!
                                          .map(
                                            (link) => Text(
                                              link,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: AppConstants.textColor,
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
                      fontSize: AppConstants.fontSizeSmallResponsive(context),
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

class EditEventScreen extends StatefulWidget {
  final Event? event;

  EditEventScreen({Key? key, this.event}) : super(key: key);

  @override
  State<EditEventScreen> createState() => EditEventScreenState();
}

class EditEventScreenState extends State<EditEventScreen> {
  late Event newEvent;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _maxPlayersController;
  late TextEditingController _maxSpectatorsController;
  late TextEditingController _gameController;
  late TextEditingController _linkController;
  late String friendGroup;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.event != null ? widget.event!.title : '',
    );
    _descriptionController = TextEditingController(
      text: widget.event != null ? widget.event!.description : '',
    );
    _maxPlayersController = TextEditingController(
      text: widget.event != null ? widget.event!.maxPlayers.toString() : '1',
    );
    _maxSpectatorsController = TextEditingController(
      text: widget.event != null ? widget.event!.maxSpectators.toString() : '0',
    );
    _gameController = TextEditingController(
      text: widget.event != null && widget.event!.games!.isNotEmpty
          ? widget.event!.games![0]
          : '',
    );
    _linkController = TextEditingController(
      text: widget.event != null && widget.event!.links!.isNotEmpty
          ? widget.event!.links![0]
          : '',
    );
    newEvent = new Event(
      id: widget.event != null ? widget.event!.id : -1,
      title: "",
      author: DataManager.getSelfUser()!,
      description: "",
      date: DateTime.now(),
      maxPlayers: 0,
      maxSpectators: 0,
    );
    _selectedDay = _focusedDay;
    friendGroup = 'All';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxPlayersController.dispose();
    _maxSpectatorsController.dispose();
    _gameController.dispose();
    _linkController.dispose();
    super.dispose();
  }

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
        decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium(context),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                child: Row(
                  children: [
                    BackButtonWidget(),
                    SizedBox(
                      width: AppConstants.mainContainerWidth(context) * 0.01,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              right: AppConstants.paddingMedium(context),
                            ),
                            height: AppConstants.headerHeight(context) * 0.9,
                            child: TextField(
                              controller: _titleController,
                              maxLength: 30,
                              decoration: InputDecoration(
                                labelText: 'Event Title',
                                hintText: 'Enter event title...',
                                labelStyle: TextStyle(
                                  color: AppConstants.textColor,
                                  fontSize:
                                      AppConstants.fontSizeLargeResponsive(
                                        context,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                                counterStyle: TextStyle(
                                  color: AppConstants.semitransparentTextColor,
                                  fontSize:
                                      AppConstants.fontSizeSmallResponsive(
                                        context,
                                      ),
                                ),
                                hintStyle: TextStyle(
                                  color: AppConstants.semitransparentTextColor,
                                  fontSize:
                                      AppConstants.fontSizeSmallResponsive(
                                        context,
                                      ),
                                ),
                              ),
                              style: TextStyle(
                                color: AppConstants.textColor,
                                fontSize: () {
                                  final baseFontSize =
                                      AppConstants.fontSizeXLargeResponsive(
                                        context,
                                      ) +
                                      2;
                                  final titleLength = widget.event == null
                                      ? 0
                                      : widget.event!.title.length;
                                  if (titleLength <= 15) return baseFontSize;
                                  if (titleLength <= 25)
                                    return baseFontSize - 2;
                                  if (titleLength <= 35)
                                    return baseFontSize - 4;
                                  return (baseFontSize - 6).clamp(
                                    AppConstants.fontSizeMediumResponsive(
                                      context,
                                    ),
                                    baseFontSize,
                                  );
                                }(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TableCalendar(
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppConstants.todayColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    gradient: AppConstants.selectionBackgroundGradient,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: AppConstants.textColor),
                  weekendTextStyle: TextStyle(color: AppConstants.textColor),
                  outsideTextStyle: TextStyle(
                    color: AppConstants.semitransparentTextColor,
                  ),
                  weekNumberTextStyle: TextStyle(color: AppConstants.textColor),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: AppConstants.fontSizeLargeResponsive(context),
                    fontWeight: FontWeight.bold,
                  ),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppConstants.textColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppConstants.textColor,
                  ),
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
              Container(
                width: AppConstants.descriptionWidth(context),
                height: AppConstants.descriptionHeight(context) * 1.15,
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
                      height: AppConstants.sectionHeaderHeight(context),
                      padding: EdgeInsets.only(
                        top: (AppConstants.paddingSmall(context) > 5
                            ? AppConstants.paddingSmall(context) - 5
                            : 0),
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
                          fontSize: AppConstants.fontSizeLargeResponsive(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppConstants.paddingMedium(context),
                        right: AppConstants.paddingMedium(context),
                        top: AppConstants.paddingSmall(context),
                        bottom: AppConstants.paddingSmall(context),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLength: 250,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                            fontSize: AppConstants.fontSizeSmallResponsive(
                              context,
                            ),
                          ),
                          hintText: 'Enter event description...',
                          hintStyle: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                          ),
                        ),
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: AppConstants.fontSizeSmallResponsive(
                            context,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
              Row(
                children: [
                  SizedBox(
                    width: (AppConstants.paddingLarge(context) > 3
                        ? AppConstants.paddingLarge(context) - 3
                        : 0),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: AppConstants.playerBoxWidth(context),
                    height: AppConstants.sectionHeaderHeight(context) * 1.3,
                    padding: EdgeInsets.only(
                      top: (AppConstants.paddingSmall(context) > 5
                          ? AppConstants.paddingSmall(context) - 5
                          : 0),
                      left: AppConstants.paddingMedium(context),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMax,
                      ),
                      color: AppConstants.playersPrimaryColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          'Players',
                          style: TextStyle(
                            color: AppConstants.textColor,
                            fontSize: AppConstants.fontSizeLargeResponsive(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: AppConstants.paddingLarge(context) * 3.7,
                        ),
                        NumberSelector(
                          controller: _maxPlayersController,
                          minValue: 1,
                          maxValue: 99,
                          onChanged: () {
                            setState(() {
                              newEvent.maxPlayers =
                                  int.tryParse(_maxPlayersController.text) ?? 1;
                            });
                          },
                          buttonColor: AppConstants.playersButtonColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingLarge(context) * 1.5),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: AppConstants.playerBoxWidth(context),
                    height: AppConstants.sectionHeaderHeight(context) * 1.3,
                    padding: EdgeInsets.only(
                      top: (AppConstants.paddingSmall(context) > 5
                          ? AppConstants.paddingSmall(context) - 5
                          : 0),
                      left: AppConstants.paddingMedium(context),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMax,
                      ),
                      color: AppConstants.spectatorsPrimaryColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          'Spectators',
                          style: TextStyle(
                            color: AppConstants.textColor,
                            fontSize: AppConstants.fontSizeLargeResponsive(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: AppConstants.paddingLarge(context) * 1.7,
                        ),
                        NumberSelector(
                          controller: _maxSpectatorsController,
                          minValue: 0,
                          maxValue: 99,
                          onChanged: () {
                            setState(() {
                              newEvent.maxSpectators =
                                  int.tryParse(_maxSpectatorsController.text) ??
                                  1;
                            });
                          },
                          buttonColor: AppConstants.spectatorsButtonColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
              Container(
                width: AppConstants.descriptionWidth(context),
                height: AppConstants.descriptionHeight(context) * 0.75,
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
                      height: AppConstants.sectionHeaderHeight(context),
                      padding: EdgeInsets.only(
                        top: (AppConstants.paddingSmall(context) > 5
                            ? AppConstants.paddingSmall(context) - 5
                            : 0),
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
                        'Game',
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: AppConstants.fontSizeLargeResponsive(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppConstants.paddingMedium(context),
                        right: AppConstants.paddingMedium(context),
                        top: AppConstants.paddingSmall(context),
                        bottom: AppConstants.paddingSmall(context),
                      ),
                      child: TextField(
                        controller: _gameController,
                        maxLength: 60,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLines: null,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                            fontSize: AppConstants.fontSizeSmallResponsive(
                              context,
                            ),
                          ),
                          hintText: 'Enter game title...',
                          hintStyle: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                          ),
                        ),
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: AppConstants.fontSizeSmallResponsive(
                            context,
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
                height: AppConstants.descriptionHeight(context) * 0.9,
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
                      height: AppConstants.sectionHeaderHeight(context),
                      padding: EdgeInsets.only(
                        top: (AppConstants.paddingSmall(context) > 5
                            ? AppConstants.paddingSmall(context) - 5
                            : 0),
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
                        'Link',
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: AppConstants.fontSizeLargeResponsive(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppConstants.paddingMedium(context),
                        right: AppConstants.paddingMedium(context),
                        top: AppConstants.paddingSmall(context),
                        bottom: AppConstants.paddingSmall(context),
                      ),
                      child: TextField(
                        controller: _linkController,
                        maxLength: 100,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLines: null,
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                            fontSize: AppConstants.fontSizeSmallResponsive(
                              context,
                            ),
                          ),
                          hintText: 'Enter link...',
                          hintStyle: TextStyle(
                            color: AppConstants.semitransparentTextColor,
                          ),
                        ),
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: AppConstants.fontSizeSmallResponsive(
                            context,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
              Container(
                padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
                width: AppConstants.descriptionWidth(context),
                height: AppConstants.sectionHeaderHeight(context) * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium(context),
                  ),
                  color: AppConstants.secondaryColor,
                ),

                child: Row(
                  children: [
                    Text(
                      'Friends to Invite',
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: AppConstants.paddingLarge(context) * 12),
                    DropdownButton<String>(
                      value: friendGroup,
                      isExpanded: false,
                      underline: SizedBox(),
                      dropdownColor: AppConstants.secondaryColor,
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: AppConstants.fontSizeMediumResponsive(
                          context,
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppConstants.textColor,
                      ),
                      items:
                          DataManager.getGroups().map((group) {
                            return DropdownMenuItem<String>(
                              value: group.name,
                              child: Text(
                                group.name,
                                style: TextStyle(
                                  color: AppConstants.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList()..add(
                            DropdownMenuItem<String>(
                              value: "All",
                              child: Text(
                                "All",
                                style: TextStyle(
                                  color: AppConstants.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      onChanged: (value) {
                        setState(() {
                          friendGroup = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
              Container(
                height: AppConstants.mainContainerHeight(context) * 0.06,
                width: AppConstants.mainContainerWidth(context) * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    newEvent.title = _titleController.text;
                    newEvent.description = _descriptionController.text;
                    newEvent.date = _selectedDay!;
                    newEvent.maxPlayers =
                        int.tryParse(_maxPlayersController.text) ?? 1;
                    newEvent.maxSpectators =
                        int.tryParse(_maxSpectatorsController.text) ?? 0;
                    newEvent.games = [_gameController.text];
                    newEvent.links = [_linkController.text];
                    newEvent = DataManager.editAndGetEvent(newEvent);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: AppConstants.secondaryColor,
                          title: Text(
                            'Event Saved',
                            style: TextStyle(color: AppConstants.textColor),
                          ),
                          content: Text(
                            'The event has been successfully saved.',
                            style: TextStyle(color: AppConstants.textColor),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                NexusAppState.instance!.returnScreenParams
                                    .removeLast();
                                NexusAppState.instance!.returnScreenPath
                                    .removeLast();
                                NexusAppState.instance!.updateState(
                                  'Event',
                                  params: [newEvent],
                                );
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(color: AppConstants.textColor),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge(context),
                      vertical: AppConstants.paddingMedium(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall(context),
                      ),
                    ),
                  ),
                  child: Text(
                    'SAVE EVENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeLargeResponsive(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
            ],
          ),
        ),
      ),
    );
  }
}
