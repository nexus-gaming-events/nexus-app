import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/back_button_widget.dart';
import '../classes/chat.dart';
import '../classes/group.dart';
import '../main.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(NexusAppState.instance!.chats.length.toString());
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
              child: Row(
                children: [
                  BackButtonWidget(),
                  SizedBox(
                    width: AppConstants.mainContainerWidth(context) * 0.01,
                  ),
                  Expanded(
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: () {
                          final baseFontSize =
                              AppConstants.fontSizeXLargeResponsive(
                                context,
                              ) +
                              2;
                          final titleLength = 'Chats'.length;
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
                  ),
                  ],
              ),
            ),
            SizedBox(height: AppConstants.mainContainerHeight(context) * 0.01),
            Container(
                          alignment: Alignment.topCenter,
                          width: AppConstants.mainContainerWidth(context)*0.9,
                          height: AppConstants.mainContainerHeight(context)*0.821,
                          child: SingleChildScrollView(
                            child: Column(
                              children: NexusAppState.instance!.chats.map(
                                (chat) => InkWell(
                                        onTap: () {
                                          NexusAppState.instance!.returnScreenParams.add([]);
                                          NexusAppState.instance!.returnScreenPath.add('Chats');
                                          NexusAppState.instance!.updateState(
                                            'Chat',
                                            params: [chat],
                                          );
                                        },
                                        child: VisualizeChatPreview(chat: chat),
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
