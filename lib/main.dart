import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'constants.dart';
import 'widgets/custom_navbar.dart';
import 'screens/screens.dart';  
import 'classes/event.dart';
import 'classes/application_object.dart';
import 'classes/user.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NexusApp());
}

class NexusApp extends StatefulWidget {
  const NexusApp({Key? key}) : super(key: key);

  @override
  State<NexusApp> createState() => NexusAppState();
}

class NexusAppState extends State<NexusApp> {
  static NexusAppState? instance;
  String _currentScreenTitle = 'Settings';
  int _selectedIndex = 2;
  late final int selfId;
  User? selfUser;
  List<ApplicationObject> currentParams = [];
  bool isLoggedIn = true;
  List<String> returnScreenPath = [];

  factory NexusAppState() {
    instance ??= NexusAppState._internal();
    return instance!;
  }

  NexusAppState._internal();

  @override
  void initState() {
    super.initState();
    selfId = 0;
    selfUser = User(
      id: selfId,
      username: "Neil",
    );
    if(!isLoggedIn){
      _currentScreenTitle = 'Login';
      _selectedIndex = 2;
    } else {
      updateState(_currentScreenTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: Container(alignment: Alignment.topCenter, child: _buildScreenBody(_currentScreenTitle, currentParams)),
        bottomNavigationBar: isLoggedIn ? CustomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _mapIndexToTitle(index);
            });
          },
        ) : null,
      ),
    );
  }

  void updateState(String screenTitle, {List<ApplicationObject> params = const [], String? returnScreenTitle = null}) {
    debugPrint('Params length: ${params.length}');
    setState(() {
      debugPrint('Updating state to screen: $screenTitle with params: $params');
      _currentScreenTitle = screenTitle;
      currentParams = params;
      if(returnScreenTitle != null){
        returnScreenPath.add(returnScreenTitle);
      }
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
      case 'Login':
        return LoginScreen();
      case 'Chats':
        return Container();
      case 'Home':
        return Container();
      case 'Friends':
        return Container(/*params[0] as User*/);
      case 'Calendar':
        return ExpeditionsScreen();
      case 'Event':
        return VisualizeEventScreen.buildFullDetails(params[0] as Event, context, returnScreenPath.isNotEmpty ? returnScreenPath.removeLast() : 'Home');
      case 'Settings':
        return SettingsScreen();
      default:
        return Center(child: Text('Screen not found: $currentScreenTitle'));
    }
  }
  
}
