import 'dart:math';

import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/main.dart';
import 'package:nexus_app/widgets/user_stack.dart';
import 'message.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/back_button_widget.dart';

class Chat extends ApplicationObject{
  int id;
  int eventId;
  List<Message> messages;

  Chat({
    required this.id,
    required this.eventId,
    required this.messages,
  });

}

class VisualizeChatScreen extends StatelessWidget {
  final Chat chat;

  const VisualizeChatScreen({Key? key, required this.chat}) : super(key: key);

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
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusMedium(context),
            ),
          ),
          width: AppConstants.mainContainerWidth(context),
          height: AppConstants.mainContainerHeight(context),
          child:  Column(
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
              child: Flexible(
                child: Column(
                  children: [
                    Row(
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
                              NexusAppState.instance!.events.firstWhere((event) => event.id == chat.eventId).title,
                              style: TextStyle(
                                color: AppConstants.textColor,
                                fontSize: () {
                                  final baseFontSize =
                                      AppConstants.fontSizeXLargeResponsive(
                                        context,
                                      ) +
                                      2;
                                  final titleLength = NexusAppState.instance!.events.firstWhere((event) => event.id == chat.eventId).title.length;
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
                                maxWidth: AppConstants.mainContainerWidth(context) * 0.7,
                              ),
                              child: ClipRect(
                                clipBehavior: Clip.hardEdge,
                                child: Text(
                                  NexusAppState.instance!.events.firstWhere((event) => event.id == chat.eventId).participants.map((participant) => participant.username).toList().join(', '),
                                  style: TextStyle(
                                    color: AppConstants.semitransparentTextColor,
                                    fontSize: AppConstants.fontSizeMediumResponsive(context),
                                    fontWeight: FontWeight.normal,  
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //print all messages from bottom to top
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
                itemCount: chat.messages.length,
                itemBuilder: (context, index) {
                  final message = chat.messages[chat.messages.length - 1 - index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppConstants.paddingSmall(context),
                    ),
                    child: VisualizeMessagePreview(message: message),
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
                        fontSize: AppConstants.fontSizeMediumResponsive(context),
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
                      size: AppConstants.iconSizeMedium(context)*0.8,
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
      ),
    );
  }
}

class VisualizeChatPreview extends StatelessWidget {
  final Chat chat;

  const VisualizeChatPreview({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = AppConstants.iconSizeLarge(context);
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
            UserStackIcon(users: NexusAppState.instance!.events.firstWhere((event) => event.id == chat.eventId).participants),
            SizedBox(width: AppConstants.paddingMedium(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NexusAppState.instance!.events.firstWhere((event) => event.id == chat.eventId).title,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: AppConstants.fontSizeLargeResponsive(context),
                      color: AppConstants.textColor,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingSmall(context)),
                  Text(
                    textAlign: TextAlign.left,
                    chat.messages.isNotEmpty
                        ? '${NexusAppState.instance!.events.firstWhere((event) => event.id == chat.eventId).participants.firstWhere((user) => user.id == chat.messages.last.senderId).username}: ${chat.messages.last.content}'
                        : '',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMediumResponsive(context),
                      color: AppConstants.semitransparentTextColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}