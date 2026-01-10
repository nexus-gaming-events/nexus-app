import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';
import '../classes/user.dart';
import '../classes/group.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        alignment: Alignment.topCenter,
        width: AppConstants.mainContainerWidth(context),
        height: AppConstants.mainContainerHeight(context),
        child: Column(
          children: [
            // Chrome-style tab bar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadiusMedium(context)),
                  topRight: Radius.circular(AppConstants.borderRadiusMedium(context)),
                ),
              ),
              child: TabBar(
               controller: _tabController,
                indicator: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.borderRadiusMedium(context)),
                    topRight: Radius.circular(AppConstants.borderRadiusMedium(context)),
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'Friends'),
                  Tab(text: 'Groups'),
                ],
              ),
            ),
            // Content area
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: AppConstants.paddingMedium(context),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      AppConstants.borderRadiusMedium(context),
                    ),
                    bottomRight: Radius.circular(
                      AppConstants.borderRadiusMedium(context),
                    ),
                  ),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: AppConstants.mainContainerWidth(context)*0.9,
                          height: AppConstants.mainContainerHeight(context)*0.821,
                          child: SingleChildScrollView(
                            child: Column(
                              children: NexusAppState.instance!.friends.map(
                                (friend) => InkWell(
                                  onTap: () {
                                    NexusAppState
                                        .instance!
                                        .returnScreenParams
                                        .add([]);
                                    NexusAppState
                                        .instance!
                                        .returnScreenPath
                                        .add('Friends');
                                    NexusAppState()
                                        .updateState(
                                          'User',
                                          params: [friend],
                                        );
                                  },
                                  child: VisualizeUserPreview(
                                    user: friend,
                                    inPlayers: false,
                                    inSpectators: false,
                                  ),
                                ),
                              ).toList(),
                            ),
                          ),
                        ),
                        Container(
                            height: AppConstants.iconSizeLarge(context)*1.1,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                       //Add friend action
                      },

                      icon: Icon(
                        Icons.add_circle,
                        color: AppConstants.accentColor2,
                        size: AppConstants.iconSizeLarge(context),
                        
                      ),
                    )
                    )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: AppConstants.mainContainerWidth(context)*0.9,
                          height: AppConstants.mainContainerHeight(context)*0.821,
                          child: SingleChildScrollView(
                            child: Column(
                              children: NexusAppState.instance!.friendGroups.map(
                                (group) => InkWell(
                                        onTap: () {
                                          NexusAppState.instance!.returnScreenParams.add([]);
                                          NexusAppState.instance!.returnScreenPath.add('Friends');
                                          NexusAppState.instance!.updateState(
                                            'Group',
                                            params: [group],
                                          );
                                        },
                                        child: VisualizeGroupPreview(group: group),
                                      ),
                                    )
                                    .toList(),
                            ),
                          ),
                        ),
                      Container(
                            height: AppConstants.iconSizeLarge(context)*1.1,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                       //Add group action
                      },

                      icon: Icon(
                        Icons.add_circle,
                        color: AppConstants.accentColor2,
                        size: AppConstants.iconSizeLarge(context),
                        
                      ),
                    )
                    )
                     ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
