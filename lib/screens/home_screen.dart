import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import '../main.dart';
import '../classes/event.dart';
import '../classes/friend_request.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> _upcomingEvents = [];
  List<FriendRequest> _friendRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load events and friend requests
    final events = DataManager.getEvents();
    final friendRequests = DataManager.getFriendRequests();

    // Filter and sort events

    final filteredEvents = (await Future.wait(events.map((e) async => await DataManager.getEventById(e.id))))
        .where((event) => event?.date.isAfter(DateTime.now()) ?? false)
        .where((event) => event != null && event.maxPlayers > event.currentPlayers)
        .where((event) => event != null && !event.participants.any((p) => p.id == DataManager.getSelfUser()!.id))
        .take(5)
        .toList();

    // Sort friend requests
    final sortedFriendRequests = (friendRequests..sort((a, b) => b.date.compareTo(a.date)))
        .take(5)
        .toList();

    if (mounted) {
      setState(() {
        _upcomingEvents = filteredEvents?.cast<Event>() ?? [];
        _friendRequests = sortedFriendRequests;
        _isLoading = false;
      });
    }
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
          HeaderContainer(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Welcome to the Nexus!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      AppConstants.fontSizeXLargeResponsive(context) * 1.7,
                  color: AppConstants.textColor,
                ),
              ),
            ),
          ),
          SizedBox(height: AppConstants.mainContainerHeight(context) * 0.01),
          Container(
            padding: EdgeInsets.only(left: AppConstants.paddingSmall(context)),
            alignment: Alignment.centerLeft,
            child: Text(
              'Upcoming Expeditions',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: AppConstants.fontSizeLargeResponsive(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
            width: AppConstants.mainContainerWidth(context),
            height: AppConstants.eventListHeight(context) * 2,
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
                children: _upcomingEvents
                    .map(
                      (item) => InkWell(
                        onTap: () async {
                          NexusAppState.instance!.returnScreenParams.add(
                            [],
                          );
                          NexusAppState.instance!.returnScreenPath.add(
                            'Home',
                          );
                          NexusAppState.instance!.updateState(
                            'Event',
                            params: [(await DataManager.getEventById(item.id))!],
                          );
                        },
                        child: VisualizeEventPreview(event: item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingSmall(context)),
            alignment: Alignment.centerLeft,
            child: Text(
              'Pending Friend Requests',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: AppConstants.fontSizeLargeResponsive(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
            width: AppConstants.mainContainerWidth(context),
            height: AppConstants.eventListHeight(context) * 2,
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
                children: _friendRequests
                    .map(
                      (item) => InkWell(
                        //onTap: () {},
                        child: VisualizeFriendRequestPreview(
                          friendRequest: item,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
