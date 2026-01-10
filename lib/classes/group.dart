import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/classes/user_settings.dart';
import 'package:nexus_app/main.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'user.dart';
import '../main.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/user_stack.dart';

class Group extends ApplicationObject {
  final int id;
  final String name;
  final List<User> friends;

  Group({
    required this.id,
    required this.name,
    required List<User> friends,
  }) : friends = friends.toList();

  
}

class VisualizeGroupScreen {
  static late Group? group;

  static Widget buildFullDetails(
    BuildContext context,
  ) {
    if (group == null) {
      return Center(
        child: Text(
          'Group not found',
          style: TextStyle(
            color: AppConstants.textColor,
            fontSize: AppConstants.fontSizeLargeResponsive(context),
          ),
        ),
      );
    }
    return Builder(
      builder: (context) => Padding(
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
                      group!.name,
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: () {
                          final baseFontSize =
                              AppConstants.fontSizeXLargeResponsive(
                                context,
                              ) +
                              2;
                          final titleLength = group!.name.length;
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
            SizedBox(height: AppConstants.paddingMedium(context),),
            Container(
                padding: EdgeInsets.only(
                  left: AppConstants.paddingSmall(context),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Members',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: AppConstants.fontSizeLargeResponsive(context),
                  ),
                ),
              ),
            Container(
                width: AppConstants.mainContainerWidth(context),
                height: AppConstants.mainContainerHeight(context)*0.7,
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
                    children: group!.friends
                        .map(
                          (friend) => InkWell(
                            onTap: () {
                              NexusAppState.instance!.returnScreenParams.add([group!]);
                              NexusAppState.instance!.returnScreenPath.add('Group');
                              NexusAppState.instance!.updateState(
                                'User',
                                params: [friend],
                              );
                            },
                            child: VisualizeUserPreview(user: friend),
                          ),
                        )
                        .toList()
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
  }
}

class VisualizeGroupPreview extends StatelessWidget {
  final Group group;

  const VisualizeGroupPreview({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(

      color: AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: (AppConstants.paddingSmall(context) > 4
            ? AppConstants.paddingSmall(context) - 4
            : 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
        child: Row(
          children: [
            UserStackIcon(users: group.friends),
            SizedBox(width: AppConstants.paddingLarge(context)),
            Container(
              child: Text(
                group.name,
                style: TextStyle(
                  fontWeight: group.id == NexusAppState.instance!.selfUser!.id ? FontWeight.bold : FontWeight.normal,
                  fontSize: AppConstants.fontSizeXLargeResponsive(context),
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
