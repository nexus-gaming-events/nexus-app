import 'package:flutter/material.dart';
import 'package:nexus_app/classes/chat.dart';
import 'package:nexus_app/main.dart';
import '../constants.dart';
import '../data_manager.dart';
import 'user.dart';

class Message {
  int senderId;
  String username;
  String avatarUrl;
  int eventId;
  String content;
  DateTime timestamp;
  Color color;

  Message(
    this.senderId,
    this.username,
    this.avatarUrl,
    this.eventId,
    this.content,
    this.timestamp,
    this.color,
  );
}

class VisualizeMessagePreview extends StatefulWidget {
  final Message message;
  final Chat? chat;
  const VisualizeMessagePreview({
    Key? key,
    required this.message,
    required this.chat,
  }) : super(key: key);

  @override
  State<VisualizeMessagePreview> createState() =>
      _VisualizeMessagePreviewState();
}

class _VisualizeMessagePreviewState extends State<VisualizeMessagePreview> {
  User? sender;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSender();
  }

  Future<void> _loadSender() async {
    sender = await DataManager.getUserById(widget.message.senderId);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || sender == null) {
      return SizedBox(
        height: AppConstants.iconSizeMedium(context),
        child: Center(
          child: CircularProgressIndicator(
            color: AppConstants.textColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    bool isCurrentUser =
        widget.message.senderId == DataManager.getSelfUser()!.id;
    return Row(
      mainAxisAlignment: isCurrentUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        isCurrentUser
            ? SizedBox.shrink()
            : ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMax,
                ),
                child: InkWell(
                  child: Image.network(
                    widget.message.avatarUrl,
                    width: AppConstants.iconSizeMedium(context),
                    height: AppConstants.iconSizeMedium(context),
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    NexusAppState.instance!.returnScreenParams.add([
                      widget.chat!,
                    ]);
                    NexusAppState.instance!.returnScreenPath.add('Chat');
                    NexusAppState.instance!.updateState(
                      'User',
                      params: [sender!],
                    );
                  },
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
                      widget.message.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeSmallResponsive(context),
                        color: widget.message.color,
                      ),
                    ),
                    SizedBox(height: AppConstants.paddingSmall(context) * 0.5),
                    Text(
                      widget.message.content,
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
                      '${widget.message.timestamp.year}-${widget.message.timestamp.month.toString().padLeft(2, '0')}-${widget.message.timestamp.day.toString().padLeft(2, '0')} ${widget.message.timestamp.hour.toString().padLeft(2, '0')}:${widget.message.timestamp.minute.toString().padLeft(2, '0')}',
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
        !isCurrentUser
            ? SizedBox.shrink()
            : ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMax,
                ),
                child: InkWell(
                  child: Image.network(
                    widget.message.avatarUrl,
                    width: AppConstants.iconSizeMedium(context),
                    height: AppConstants.iconSizeMedium(context),
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    NexusAppState.instance!.returnScreenParams.add([
                      widget.chat!,
                    ]);
                    NexusAppState.instance!.returnScreenPath.add('Chat');
                    NexusAppState.instance!.updateState(
                      'User',
                      params: [sender!],
                    );
                  },
                ),
              ),
      ],
    );
  }
}
