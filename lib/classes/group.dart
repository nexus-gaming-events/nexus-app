import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/main.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import 'user.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';
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

class VisualizeGroupScreen extends StatefulWidget {
  final int groupId;
  const VisualizeGroupScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  State<VisualizeGroupScreen> createState() => _VisualizeGroupScreenState();
}

class _VisualizeGroupScreenState extends State<VisualizeGroupScreen> {
  Group? _group;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroup();
  }

  Future<void> _loadGroup() async {
    setState(() {
      _isLoading = true;
    });
    // If you have async loading, use await. Otherwise, just get from DataManager
    final group = await DataManager.getGroupById(widget.groupId);
    setState(() {
      _group = group;
      _isLoading = false;
    });
  }

  void _showManageMembersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _ManageMembersDialog(
          group: _group!,
          onUpdate: () async {
            await _loadGroup();
          },
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
    if (_group == null) {
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
    final group = _group!;
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
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: () {
                        final baseFontSize =
                            AppConstants.fontSizeXLargeResponsive(
                              context,
                            ) +
                            2;
                        final titleLength = group.name.length;
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
                IconButton(
                  onPressed: () {
                    // Show delete confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: AppConstants.primaryColor,
                          title: Text(
                            'Delete Group',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            'Are you sure you want to delete this group?',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text(
                                'Cancel',
                                style:
                                    TextStyle(color: Colors.white.withOpacity(0.6)),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                DataManager.deleteGroup(group.id);
                                Navigator.of(dialogContext).pop(); // Close dialog
                                NexusAppState.instance!.returnScreenParams.clear();
                                NexusAppState.instance!.returnScreenPath.clear();
                                NexusAppState.instance!.updateState('Friends');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.accentColor2,
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
                  },
                  icon: Icon(Icons.delete,),),
        ],),
          ),
          SizedBox(height: AppConstants.paddingMedium(context),),
          Container(
              padding: EdgeInsets.only(
                left: AppConstants.paddingMedium(context),
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
          SizedBox(height: AppConstants.paddingMedium(context),),
          Container(
              width: AppConstants.mainContainerWidth(context)*0.95,
              height: AppConstants.mainContainerHeight(context)*0.7265,
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
                  children: group.friends
                      .map(
                        (friend) => InkWell(
                          onTap: () {
                            NexusAppState.instance!.returnScreenParams.add([group]);
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
          Container(
                          height: AppConstants.iconSizeLarge(context)*1.1,
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: _showManageMembersDialog,
                    icon: Icon(
                      Icons.add_circle,
                      color: AppConstants.accentColor2,
                      size: AppConstants.iconSizeLarge(context),

                    ),
                  )
                  )
        ],
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
                  fontWeight: FontWeight.normal,
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

class _ManageMembersDialog extends StatefulWidget {
  final Group group;
  final Function() onUpdate;

  const _ManageMembersDialog({
    Key? key,
    required this.group,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<_ManageMembersDialog> createState() => _ManageMembersDialogState();
}

class _ManageMembersDialogState extends State<_ManageMembersDialog> {
  late List<User> selectedFriends;
  late List<User> originalMembers;
  List<User> allFriends = [];

  @override
  void initState() {
    super.initState();
    allFriends = DataManager.getFriends();
    // Create a copy of the current members list
    originalMembers = List<User>.from(widget.group.friends);
    selectedFriends = List<User>.from(widget.group.friends);
  }

  List<User> get addedFriends {
    return selectedFriends
        .where((friend) => !originalMembers.any((u) => u.id == friend.id))
        .toList();
  }

  List<User> get removedFriends {
    return originalMembers
        .where((friend) => !selectedFriends.any((u) => u.id == friend.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.primaryColor,
      title: Text(
        'Manage Members',
        style: TextStyle(color: Colors.white),
      ),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Friend selection section
              Text(
                'Select Members:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              if (allFriends.isEmpty)
                Text(
                  'No friends available',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                )
              else
                ...allFriends.map((friend) {
                  final isSelected = selectedFriends.any((u) => u.id == friend.id);
                  return CheckboxListTile(
                    secondary: CircleAvatar(
                      backgroundImage: (friend.avatarUrl == null || friend.avatarUrl.isEmpty)
                          ? AssetImage('assets/pfps/Neil.png')
                          : NetworkImage(friend.avatarUrl) as ImageProvider,
                      radius: 20,
                    ),
                    title: Text(
                      friend.username,
                      style: TextStyle(color: Colors.white),
                    ),
                    value: isSelected,
                    activeColor: AppConstants.accentColor2,
                    checkColor: Colors.white,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!selectedFriends.any((u) => u.id == friend.id)) {
                            selectedFriends.add(friend);
                          }
                        } else {
                          selectedFriends.removeWhere((u) => u.id == friend.id);
                        }
                      });
                    },
                  );
                }).toList(),
              SizedBox(height: 16),
              Divider(color: Colors.white.withOpacity(0.3)),
              SizedBox(height: 16),
              // Added friends section
              Text(
                'Added (${addedFriends.length}):',
                style: TextStyle(
                  color: AppConstants.accentColor2,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              if (addedFriends.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'None',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                )
              else
                ...addedFriends.map((friend) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: (friend.avatarUrl == null || friend.avatarUrl.isEmpty)
                            ? AssetImage('assets/pfps/Neil.png')
                            : NetworkImage(friend.avatarUrl) as ImageProvider,
                        radius: 12,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '+ ${friend.username}',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                )).toList(),
              SizedBox(height: 12),
              // Removed friends section
              Text(
                'Removed (${removedFriends.length}):',
                style: TextStyle(
                  color: AppConstants.accentColor2,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              if (removedFriends.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'None',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                )
              else
                ...removedFriends.map((friend) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: (friend.avatarUrl == null || friend.avatarUrl.isEmpty)
                            ? AssetImage('assets/pfps/Neil.png')
                            : NetworkImage(friend.avatarUrl) as ImageProvider,
                        radius: 12,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '- ${friend.username}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                )).toList(),
            ],
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
          onPressed: () async{
            // Get the lists of added and removed friends
            final added = addedFriends;
            final removed = removedFriends;

           await DataManager.addFriendsToGroup(widget.group.id, added);
           await DataManager.removeFriendsFromGroup(widget.group.id, removed);
           Navigator.of(context).pop();
           widget.onUpdate();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.accentColor2,
          ),
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
