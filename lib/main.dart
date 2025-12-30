import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'constants.dart';
import 'widgets/custom_navbar.dart';
import 'screens/screens.dart';  
import 'classes/event.dart';
import 'classes/application_object.dart';

void main() {
  runApp(NexusApp());
}

class NexusApp extends StatefulWidget {
  const NexusApp({Key? key}) : super(key: key);

  @override
  State<NexusApp> createState() => NexusAppState();
}

class NexusAppState extends State<NexusApp> {
  static NexusAppState? instance;
  static String _currentScreenTitle = 'Home';
  static int _selectedIndex = 2;
  static late final int selfId; 
  static List<ApplicationObject> currentParams = [];

  factory NexusAppState() {
    instance ??= NexusAppState._internal();
    return instance!;
  }

  NexusAppState._internal();

  @override
  void initState() {
    super.initState();
    selfId = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: null, //const CustomAppBar(),
        body: _buildScreenBody(_currentScreenTitle, currentParams),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _mapIndexToTitle(index);
            });
          },
        ),
      ),
    );
  }

  void updateState(String screenTitle, {List<ApplicationObject> params = const []}) {
    debugPrint('Params length: ${params.length}');
    setState(() {
      debugPrint('Updating state to screen: $screenTitle with params: $params');
      _currentScreenTitle = screenTitle;
      currentParams = params;
    });
  }
  
  void _mapIndexToTitle(int index) {
    if(index == 0){
      updateState('User', params: [/*findUser(selfId)*/]);
    }
    else if(index == 1){
      updateState('Chats');
    }
    else if(index == 2){
      updateState('Home');
    }
    else if(index == 3){
      updateState('Friends', params: [/*findUser(selfId)*/]);
    }
    else if(index == 4){
      updateState('Calendar');
    }
  }

  Widget? _buildScreenBody(String currentScreenTitle, [List<ApplicationObject> params = const []]) {
    switch (currentScreenTitle) {
      case 'User':
        /*return VisualizeUserScreen.buildFullDetails(params[0] as User, () {
          setState(() {
            _currentScreenTitle = 'Home';
            _selectedIndex = 2;
          });
        });*/
        return Container();
      case 'Chats':
        return Container();
      case 'Home':
        return Container();
      case 'Friends':
        return Container(/*params[0] as User*/);
      case 'Calendar':
        return ExpeditionsScreen();
      case 'Event':
        debugPrint('Navigating to Event screen with params: $params');
        return VisualizeEventScreen.buildFullDetails(params[0] as Event);
      default:
        return Center(child: Text('Screen not found: $currentScreenTitle'));
    }
  }
  
}
