import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import '../main.dart';
import '../classes/user.dart';
import '../classes/group.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/add_circle_icon_button.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> _friends = [];
  List<Group> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await DataManager.loadFriends();
    await DataManager.loadGroups();
    
    final friends = DataManager.getFriends();
    final groups = DataManager.getGroups();
    
    if (mounted) {
      setState(() {
        _friends = friends;
        _groups = groups;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateGroupDialog() {
    final TextEditingController groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.primaryColor,
          title: Text(
            'Create New Group',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: groupNameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter group name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppConstants.accentColor2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppConstants.accentColor2,
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (groupNameController.text.trim().isNotEmpty) {
                  await DataManager.createGroup(groupNameController.text.trim());
                  Navigator.of(context).pop();
                  await _loadData(); // Properly refresh the UI with new data
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.accentColor2,
              ),
              child: Text('Create', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
      alignment: Alignment.topCenter,
      decoration:
          BoxDecoration(), // No background decoration for custom tab styling
      child: Column(
        children: [
          // Chrome-style tab bar
          Container(
            height: AppConstants.mainContainerHeight(context) * 0.1,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  AppConstants.borderRadiusMedium(context),
                ),
                topRight: Radius.circular(
                  AppConstants.borderRadiusMedium(context),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    AppConstants.borderRadiusMedium(context),
                  ),
                  topRight: Radius.circular(
                    AppConstants.borderRadiusMedium(context),
                  ),
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
                        width: AppConstants.mainContainerWidth(context) * 0.9,
                        height:
                            AppConstants.mainContainerHeight(context) * (AppConstants.isTablet(context) ? 0.7 : 0.78),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _friends
                                .map(
                                  (friend) => InkWell(
                                    onTap: () {
                                      NexusAppState.instance!.returnScreenParams
                                          .add([]);
                                      NexusAppState.instance!.returnScreenPath
                                          .add('Friends');
                                      NexusAppState().updateState(
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
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      AddCircleIconButton(
                        onPressed: () {
                          NexusAppState.instance!.returnScreenParams.add([]);
                          NexusAppState.instance!.returnScreenPath.add('Friends');
                          NexusAppState.instance!.updateState('SearchUsers');
                          
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        width: AppConstants.mainContainerWidth(context) * 0.9,
                        height:
                            AppConstants.mainContainerHeight(context) * (AppConstants.isTablet(context) ? 0.7 : 0.78),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _groups
                                .map(
                                  (group) => InkWell(
                                    onTap: () {
                                      NexusAppState.instance!.returnScreenParams
                                          .add([]);
                                      NexusAppState.instance!.returnScreenPath
                                          .add('Friends');
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
                      AddCircleIconButton(
                        onPressed: _showCreateGroupDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
