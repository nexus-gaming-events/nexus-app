import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_app/classes/chat.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:nexus_app/main.dart';
import '../constants.dart';
import 'user.dart';
import 'application_object.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';
import '../widgets/number_selector.dart';
import 'package:table_calendar/table_calendar.dart';
import 'group.dart';

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
  int? numPlayers;
  int? numSpectators;
  late Chat? chat;
  late List<User> participants;
  int groupId;
  bool onlyFriends;

  Event({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.date,
    required this.maxPlayers,
    required this.maxSpectators,
    required this.groupId,
    required this.onlyFriends,
    this.players,
    this.spectators,
    this.games,
    this.links,
    this.numPlayers,
    this.numSpectators,
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
  int get currentPlayers => players?.length ?? numPlayers ?? 0;
  int get currentSpectators => spectators?.length ?? numSpectators ?? 0;
}

class VisualizeEventScreen extends StatefulWidget {
  final Event? event;

  const VisualizeEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<VisualizeEventScreen> createState() => _VisualizeEventScreenState();
}

class _VisualizeEventScreenState extends State<VisualizeEventScreen> {
  bool isUserInPlayers = false;
  bool isUserInSpectators = false;
  bool isUserAuthor = false;
  bool _isLoading = true;
  late Event event;

  @override
  void initState() {
    super.initState();
    _updateUserStatus();
  }

  void _updateUserStatus() async {
    debugPrint('Updating user status for event: ${widget.event?.title}');
    final players = await DataManager.isUserInPlayers(
      DataManager.getSelfUser()!.id,
      widget.event?.id ?? -1,
    );
    final spectators = await DataManager.isUserInSpectators(
      DataManager.getSelfUser()!.id,
      widget.event?.id ?? -1,
    );
    final author = await DataManager.isAuthor(
      DataManager.getSelfUser()!.id,
      widget.event?.id ?? -1,
    );
    
    setState(() {
      isUserInPlayers = players;
      isUserInSpectators = spectators;
      isUserAuthor = author;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return BaseScreenContainer(
        child: Center(
          child: CircularProgressIndicator(
            color: AppConstants.textColor,
          ),
        ),
      );
    }
    
    return BaseScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Custom height (1.1x) needed for event menu buttons
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
                                          DataManager.deleteEvent(
                                            widget.event!.id,
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    AppConstants.secondaryColor,
                                                title: Text(
                                                  'Event Deleted',
                                                  style: TextStyle(
                                                    color:
                                                        AppConstants.textColor,
                                                  ),
                                                ),
                                                content: Text(
                                                  'The event has been successfully deleted.',
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
                                          'Delete',
                                          style: TextStyle(color: Colors.white),
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
                                      isUserAuthor ||
                                          isUserInSpectators ||
                                          (!isUserInPlayers &&
                                              widget.event!.players!.length >=
                                                  widget.event!.maxPlayers)
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
                                              onTap: () async {
                                                if (isUserInPlayers) {
                                                  debugPrint('Player button tapped: User is currently a player, attempting to leave event');
                                                  await DataManager.leaveEvent(
                                                    widget.event!.id,
                                                  );
                                                  debugPrint('Left event as player, updating state');
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
                                                  NexusAppState.instance!.reloadCurrentScreen();
                                                } else {
                                                  await DataManager.joinEvent(
                                                    widget.event!.id,
                                                    "player",
                                                  );
                                                  setState(() {
                                                    isUserInPlayers = true;
                                                    widget.event!.players!.add(
                                                      DataManager.getSelfUser()!,
                                                    );
                                                  });
                                                  NexusAppState.instance!.reloadCurrentScreen();
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
                                                            isUserInPlayers
                                                                ? 0.075
                                                                : 0.09,
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
                                  top: AppConstants.screenHeight(
                                    context,
                                    0.5,
                                  ).clamp(75.0, 160.0),
                                  left: AppConstants.paddingSmall(context),
                                  right: AppConstants.paddingSmall(context),
                                  child:
                                      isUserAuthor ||
                                          isUserInPlayers ||
                                          (!isUserInSpectators &&
                                              widget.event!.spectators!.length >=
                                                  widget.event!.maxSpectators)
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
                                              onTap: () async {
                                                if (isUserInSpectators) {
                                                  await DataManager.leaveEvent(
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
                                                  NexusAppState.instance!.reloadCurrentScreen();
                                                } else {
                                                  await DataManager.joinEvent(
                                                    widget.event!.id,
                                                    "spectator",
                                                  );
                                                  setState(() {
                                                    isUserInSpectators = true;
                                                    widget.event!.spectators!.add(
                                                      DataManager.getSelfUser()!,
                                                    );
                                                  });
                                                  NexusAppState.instance!.reloadCurrentScreen();
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
                                                            isUserInSpectators
                                                                ? 0.067
                                                                : 0.085,
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
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingSmall(context) * 1.4),
              child: SizedBox(
                width: AppConstants.iconSizeSmall(context) * 1.1,
                height: AppConstants.iconSizeSmall(context) * 1.1,
                child: Image.asset(
                  'assets/icons/Space ship.png',
                  fit: BoxFit.contain,
                  color: event.maxPlayers > event.currentPlayers
                      ? AppConstants.successColor
                      : event.maxSpectators > event.currentSpectators
                      ? AppConstants.warningColor
                      : AppConstants.errorColor,
                ),
              ),
            ),
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
                "${event.numPlayers}/${event.maxPlayers}",
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
  TimeOfDay _selectedTime = TimeOfDay(hour: 12, minute: 0);
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _maxPlayersController;
  late TextEditingController _maxSpectatorsController;
  late TextEditingController _gameController;
  late TextEditingController _linkController;
  bool _isRecurrent = false;
  late String _periodicity;
  late String _recurrenceTime;
  int? selectedGroupId;
  bool _onlyFriends = false;
  int _groupId = -1;

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
      groupId: -1,
      onlyFriends: false,
    );
    _selectedDay = _focusedDay;
    if (widget.event != null) {
      _selectedTime = TimeOfDay(
        hour: widget.event!.date.hour,
        minute: widget.event!.date.minute,
      );
    }
    _onlyFriends = widget.event?.onlyFriends ?? false;
    _groupId = widget.event?.groupId ?? 0;
    // Seleziona -1 se onlyFriends è false (Public), 0 se groupId==0 (All Friends), altrimenti groupId
    if (!_onlyFriends) {
      selectedGroupId = -1;
    } else if (_groupId == 0) {
      selectedGroupId = 0;
    } else {
      selectedGroupId = _groupId;
    }
    _periodicity = "Daily";
    _recurrenceTime = "1 week";
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
    return BaseScreenContainer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderContainer(
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
                height: AppConstants.sectionHeaderHeight(context) * 1.5,
                padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium(context),
                  ),
                  color: AppConstants.secondaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: AppConstants.fontSizeLargeResponsive(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppConstants.textColor,
                                  surface: AppConstants.secondaryColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != _selectedTime) {
                          setState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium(context),
                          vertical: AppConstants.paddingSmall(context),
                        ),
                        decoration: BoxDecoration(
                          gradient: AppConstants.selectionBackgroundGradient,
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSmall(context),
                          ),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                          style: TextStyle(
                            color: AppConstants.textColor,
                            fontSize: AppConstants.fontSizeMediumResponsive(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.event == null
                  ? Column(
                      children: [
                        SizedBox(
                          height: AppConstants.paddingMedium(context) * 1.2,
                        ),
                        AnimatedCrossFade(
                          crossFadeState: _isRecurrent
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 250),
                          firstChild: Container(
                            width: AppConstants.descriptionWidth(context),
                            height:
                                AppConstants.sectionHeaderHeight(context) *
                                2.15,
                            padding: EdgeInsets.all(
                              AppConstants.paddingMedium(context),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium(context),
                              ),
                              color: AppConstants.secondaryColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Is the event recurrent?',
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                        fontSize:
                                            AppConstants.fontSizeLargeResponsive(
                                              context,
                                            ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: _isRecurrent,
                                      onChanged: (value) {
                                        setState(() {
                                          _isRecurrent = value;
                                        });
                                      },
                                      activeColor:
                                          AppConstants.semitransparentTextColor,
                                      inactiveThumbColor:
                                          AppConstants.messageBackgroundColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          secondChild: Container(
                            width: AppConstants.descriptionWidth(context),
                            height:
                                AppConstants.sectionHeaderHeight(context) * 6,
                            padding: EdgeInsets.all(
                              AppConstants.paddingMedium(context),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium(context),
                              ),
                              color: AppConstants.secondaryColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Is the event recurrent?',
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                        fontSize:
                                            AppConstants.fontSizeLargeResponsive(
                                              context,
                                            ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: _isRecurrent,
                                      onChanged: (value) {
                                        setState(() {
                                          _isRecurrent = value;
                                        });
                                      },
                                      activeColor:
                                          AppConstants.semitransparentTextColor,
                                      inactiveThumbColor:
                                          AppConstants.messageBackgroundColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppConstants.paddingMedium(context),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Periodicity:",
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
                                      width: AppConstants.paddingLarge(context)*6,
                                    ),
                                    DropdownButton<String>(
                                      value: _periodicity,
                                      isExpanded: false,
                                      underline: SizedBox(),
                                      dropdownColor:
                                          AppConstants.secondaryColor,
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                        fontSize:
                                            AppConstants.fontSizeLargeResponsive(
                                              context,
                                            ),
                                      ),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: AppConstants.textColor,
                                      ),
                                      items: ["Daily", "Weekly", "Monthly"].map(
                                        (period) {
                                          return DropdownMenuItem<String>(
                                            value: period,
                                            child: Text(
                                              period,
                                              style: TextStyle(
                                                color: AppConstants.textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _periodicity = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppConstants.paddingMedium(context),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Duration:",
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
                                      width: AppConstants.paddingLarge(context)*6,
                                    ),
                                    DropdownButton<String>(
                                      value: _recurrenceTime,
                                      isExpanded: false,
                                      underline: SizedBox(),
                                      dropdownColor:
                                          AppConstants.secondaryColor,
                                      style: TextStyle(
                                        color: AppConstants.textColor,
                                        fontSize:
                                            AppConstants.fontSizeLargeResponsive(
                                              context,
                                            ),
                                      ),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: AppConstants.textColor,
                                      ),
                                      items: ["1 week", "1 month", "3 months", "6 months", "1 year"].map(
                                        (period) {
                                          return DropdownMenuItem<String>(
                                            value: period,
                                            child: Text(
                                              period,
                                              style: TextStyle(
                                                color: AppConstants.textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _recurrenceTime = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: AppConstants.paddingLarge(context) * 1.2),
              Container(
                width: AppConstants.descriptionWidth(context),
                height: AppConstants.descriptionHeight(context) * 1.15,
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
                    DropdownButton<int?>(
                      value: selectedGroupId,
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
                      items: [
                        DropdownMenuItem<int?>(
                          value: -1,
                          child: Text(
                            "Public",
                            style: TextStyle(
                              color: AppConstants.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DropdownMenuItem<int?>(
                          value: 0,
                          child: Text(
                            "All Friends",
                            style: TextStyle(
                              color: AppConstants.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...DataManager.getGroups().where((g) => g.id != 0).map((group) {
                          return DropdownMenuItem<int?>(
                            value: group.id,
                            child: Text(
                              group.name,
                              style: TextStyle(
                                color: AppConstants.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGroupId = value;
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
                  onPressed: () async {
                    newEvent.title = _titleController.text;
                    newEvent.description = _descriptionController.text;
                    // Combine selected day with selected time
                    newEvent.date = DateTime(
                      _selectedDay!.year,
                      _selectedDay!.month,
                      _selectedDay!.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                    newEvent.maxPlayers =
                        int.tryParse(_maxPlayersController.text) ?? 1;
                    newEvent.maxSpectators =
                        int.tryParse(_maxSpectatorsController.text) ?? 0;
                    newEvent.games = [_gameController.text];
                    newEvent.links = [_linkController.text];
                    newEvent.players = widget.event?.players ?? [];
                    newEvent.spectators = widget.event?.spectators ?? [];
                    if (selectedGroupId == -1) {
                      newEvent.groupId = 0;
                      newEvent.onlyFriends = false;
                    } else {
                      newEvent.groupId = selectedGroupId ?? 0;
                      newEvent.onlyFriends = true;
                    }
                    bool titleEmpty = newEvent.title.isEmpty;
                    bool descriptionEmpty = newEvent.description.isEmpty;
                    bool dateInvalid = !newEvent.date.isAfter(DateTime.now());
                    bool maxPlayersUnder0 = newEvent.maxPlayers <= 0;
                    bool maxSpectatorsUnder0 = newEvent.maxSpectators < 0;
                    bool maxPlayersLessThanCurrent =
                        newEvent.maxPlayers < newEvent.currentPlayers;
                    bool maxSpectatorsLessThanCurrent =
                        newEvent.maxSpectators < newEvent.currentSpectators;
                    bool hasErrors =
                        titleEmpty ||
                        descriptionEmpty ||
                        dateInvalid ||
                        maxPlayersUnder0 ||
                        maxSpectatorsUnder0 ||
                        maxPlayersLessThanCurrent ||
                        maxSpectatorsLessThanCurrent;
                    if (!hasErrors) {
                      if (!_isRecurrent){
                        newEvent = await DataManager.editAndGetEvent(newEvent);
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
                                  style: TextStyle(
                                    color: AppConstants.textColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    
                      }
                      else{
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppConstants.secondaryColor,
                            title: Text(
                              'Recurrent Event',
                              style: TextStyle(color: AppConstants.textColor),
                            ),
                            content: Text(
                              'This operation will create multiple events based on the selected periodicity and duration. Each event will be created separately. Do you want to proceed?',
                              style: TextStyle(color: AppConstants.textColor),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  List<Event> events = await DataManager.createRecurrentEvents(newEvent, _periodicity, _recurrenceTime);
                                  newEvent = events.first;
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
                                  style: TextStyle(
                                    color: AppConstants.textColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    
                      }
                      } else {
                      String errorMessage =
                          'Please fix the following errors:\n';
                      if (titleEmpty)
                        errorMessage += '- Title cannot be empty\n';
                      if (descriptionEmpty)
                        errorMessage += '- Description cannot be empty\n';
                      if (dateInvalid)
                        errorMessage += '- Date must be in the future\n';
                      if (maxPlayersUnder0)
                        errorMessage +=
                            '- Max players must be greater than 0\n';
                      if (maxSpectatorsUnder0)
                        errorMessage += '- Max spectators cannot be negative\n';
                      if (maxPlayersLessThanCurrent)
                        errorMessage +=
                            '- Max players cannot be less than current players (${newEvent.currentPlayers})\n';
                      if (maxSpectatorsLessThanCurrent)
                        errorMessage +=
                            '- Max spectators cannot be less than current spectators (${newEvent.currentSpectators})\n';
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppConstants.secondaryColor,
                            title: Text(
                              'Error',
                              style: TextStyle(color: AppConstants.textColor),
                            ),
                            content: Text(
                              errorMessage,
                              style: TextStyle(color: AppConstants.textColor),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                    }
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
    );
  }
}
