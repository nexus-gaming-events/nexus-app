import 'dart:math';

import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/classes/user.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:nexus_app/main.dart';
import 'package:nexus_app/widgets/user_stack.dart';
import 'message.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';
import 'event.dart';

class Chat extends ApplicationObject {
  int eventId;
  List<Message> messages;

  Chat({required this.eventId, required this.messages});
}

class VisualizeChatScreen extends StatefulWidget {
  final Chat chat;

  const VisualizeChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<VisualizeChatScreen> createState() => _VisualizeChatScreenState();
}

class _VisualizeChatScreenState extends State<VisualizeChatScreen> {
  Event? event;
  bool isLoading = true;
  Map<int, Color> userColors = {};

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    event = await DataManager.getEventById(widget.chat.eventId);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
      assignUserColors();
    }
  }

  void assignUserColors() {
    if (event == null) return;
    final random = Random();
    List<Color> availableColors = List.from(AppConstants.userChatColors);
    for (var participant in event!.participants) {
      if (availableColors.isEmpty) {
        availableColors = List.from(AppConstants.userChatColors);
      }
      final colorIndex = random.nextInt(availableColors.length);
      userColors[participant.id] = availableColors[colorIndex];
      availableColors.removeAt(colorIndex);
    }
    for (var message in widget.chat.messages) {
      message.color = userColors[message.senderId] ?? AppConstants.textColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || event == null) {
      return BaseScreenContainer(
        child: Center(
          child: CircularProgressIndicator(color: AppConstants.textColor),
        ),
      );
    }

    String eventTitle = event!.title;
    List<User> eventParticipantsList = event!.participants;
    String eventParticipants = eventParticipantsList
        .map((participant) => participant.username)
        .toList()
        .join(', ');
    return BaseScreenContainer(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        eventTitle,
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: () {
                            final baseFontSize =
                                AppConstants.fontSizeXLargeResponsive(
                                      context,
                                    ) +
                                    2;
                            final titleLength = eventTitle.length;
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
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              AppConstants.mainContainerWidth(context) * 0.7,
                        ),
                        child: ClipRect(
                          clipBehavior: Clip.hardEdge,
                          child: Text(
                            eventParticipants,
                            style: TextStyle(
                              color: AppConstants.semitransparentTextColor,
                              fontSize:
                                  AppConstants.fontSizeMediumResponsive(
                                context,
                              ),
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      width: AppConstants.mainContainerWidth(context) * 0.35),
                  InkWell(
                    child: Image.asset(
                      "assets/icons/Space ship.png",
                      width: AppConstants.iconSizeMedium(context),
                      height: AppConstants.iconSizeMedium(context),
                    ),
                    onTap: () {
                      NexusAppState.instance!.returnScreenParams.add([
                        widget.chat,
                      ]);
                      NexusAppState.instance!.returnScreenPath.add(
                        'Chat',
                      );
                      NexusAppState.instance!.updateState(
                        'Event',
                        params: [event!],
                      );
                    },
                  ),
                ],
              ),
            ),
            //print all messages from bottom to top
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
                itemCount: widget.chat.messages.length,
                itemBuilder: (context, index) {
                  final message = widget
                      .chat
                      .messages[widget.chat.messages.length - 1 - index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppConstants.paddingSmall(context),
                    ),
                    child: VisualizeMessagePreview(message: message, chat: widget.chat),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
              decoration: BoxDecoration(
                color: AppConstants.secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    AppConstants.borderRadiusMedium(context),
                  ),
                  bottomRight: Radius.circular(
                    AppConstants.borderRadiusMedium(context),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: AppConstants.fontSizeMediumResponsive(
                          context,
                        ),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: AppConstants.semitransparentTextColor,
                        ),
                        filled: true,
                        fillColor: AppConstants.primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSmall(context),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium(context),
                          vertical: AppConstants.paddingSmall(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingSmall(context)),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement send message logic
                    },
                    icon: Icon(
                      Icons.send,
                      color: AppConstants.textColor,
                      size: AppConstants.iconSizeMedium(context) * 0.8,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstants.accentColor2,
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

class VisualizeChatPreview extends StatefulWidget {
  final Chat chat;

  const VisualizeChatPreview({Key? key, required this.chat}) : super(key: key);

  @override
  State<VisualizeChatPreview> createState() => _VisualizeChatPreviewState();
}

class _VisualizeChatPreviewState extends State<VisualizeChatPreview> {
  Event? event;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    event = await DataManager.getEventById(widget.chat.eventId);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || event == null) {
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
          child: Center(
            child: CircularProgressIndicator(
              color: AppConstants.textColor,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    String eventTitle = event!.title;
    List<User> eventParticipantsList = event!.participants;
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
        child: Row(
          children: [
            UserStackIcon(users: eventParticipantsList),
            SizedBox(width: AppConstants.paddingMedium(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: AppConstants.fontSizeLargeResponsive(context),
                      color: AppConstants.textColor,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingSmall(context)),
                  Text(
                    textAlign: TextAlign.left,
                    widget.chat.messages.isNotEmpty
                        ? '${eventParticipantsList.firstWhere((user) => user.id == widget.chat.messages.last.senderId).username}: ${widget.chat.messages.last.content}'
                        : '',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMediumResponsive(context),
                      color: AppConstants.semitransparentTextColor,
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
