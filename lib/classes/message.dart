import 'package:flutter/material.dart';
import 'package:nexus_app/main.dart';
import '../constants.dart';

class Message {
  int senderId;
  int eventId;
  String content;
  DateTime timestamp;
  Color color;

  Message(
    this.senderId,
    this.eventId,
    this.content,
    this.timestamp,
    this.color,
  );
}

class VisualizeMessagePreview extends StatelessWidget {
  final Message message;

  const VisualizeMessagePreview({Key? key, required this.message})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = message.senderId ==
        NexusAppState.instance!.selfUser!.id;
    return Row(
      mainAxisAlignment: isCurrentUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        isCurrentUser? SizedBox.shrink() :
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
          child: Image.network(
            NexusAppState.instance!.events
                .firstWhere((event) => event.id == message.eventId)
                .participants
                .firstWhere((user) => user.id == message.senderId)
                .imageUrl,
            width: AppConstants.iconSizeMedium(context),
            height: AppConstants.iconSizeMedium(context),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: AppConstants.paddingSmall(context)),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: AppConstants.mainContainerWidth(context) * 0.67,
            ),
            child: Card(
              color: AppConstants.messageBackgroundColor,
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NexusAppState.instance!.events
                          .firstWhere((event) => event.id == message.eventId)
                          .participants
                          .firstWhere((user) => user.id == message.senderId)
                          .username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeSmallResponsive(context),
                        color: message.color,
                      ),
                    ),
                    SizedBox(height: AppConstants.paddingSmall(context) * 0.5),
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMediumResponsive(
                          context,
                        ),
                        color: AppConstants.textColor,
                      ),
                    ),
                    SizedBox(height: AppConstants.paddingSmall(context) * 0.3),
                    Text(
                      textAlign: TextAlign.right,
                      '${message.timestamp.year}-${message.timestamp.month.toString().padLeft(2, '0')}-${message.timestamp.day.toString().padLeft(2, '0')} ${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmallResponsive(context),
                        color: AppConstants.semitransparentTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        !isCurrentUser? SizedBox.shrink() :
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
          child: Image.network(
            NexusAppState.instance!.events
                .firstWhere((event) => event.id == message.eventId)
                .participants
                .firstWhere((user) => user.id == message.senderId)
                .imageUrl,
            width: AppConstants.iconSizeMedium(context),
            height: AppConstants.iconSizeMedium(context),
            fit: BoxFit.cover,
          ),
        ),
        
      ],
    );
  }
}
