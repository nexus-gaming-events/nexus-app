import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/services/secure_storage_service.dart';
import 'widgets/custom_navbar.dart';
import 'widgets/galaxy_background.dart';
import 'screens/screens.dart';
import 'classes/event.dart';
import 'classes/user.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'classes/user_settings.dart';
import 'classes/group.dart';
import '../classes/chat.dart';
import 'screens/friend_requests_screen.dart';
import 'data_manager.dart';
import 'services/web_interface_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSettings.loadFromJson();
  
  // Load token from secure storage if it exists
  final secureStorage = SecureStorageService();
  if (await secureStorage.hasNexusToken()) {
    final token = await secureStorage.getNexusToken();
    WebInterfaceService.token = token;
    await DataManager.initialize();
  }
  
  runApp(NexusApp());
}

class NexusApp extends StatefulWidget {
  const NexusApp({Key? key}) : super(key: key);

  @override
  State<NexusApp> createState() => NexusAppState();
}

class NexusAppState extends State<NexusApp> {
  static NexusAppState? instance;
  String _currentScreenTitle = 'Home';
  int _selectedIndex = 2;
  List<ApplicationObject> currentParams = [];
  bool isLoggedIn = false;
  List<String> returnScreenPath = [];
  List<List<ApplicationObject>> returnScreenParams = [];

  factory NexusAppState() {
    instance ??= NexusAppState._internal();
    return instance!;
  }

  NexusAppState._internal();

  @override
  void initState() {
    super.initState();

    isLoggedIn = DataManager.isLogged();

    if (!isLoggedIn) {
      _currentScreenTitle = 'Login';
      _selectedIndex = 2;
    } else {
      updateState(_currentScreenTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GalaxyBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.topCenter,
            child: _buildScreenBody(_currentScreenTitle, currentParams),
          ),
          bottomNavigationBar: isLoggedIn ? CustomNavBar(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                returnScreenPath.clear();
                _selectedIndex = index;
                _mapIndexToTitle(index);
              });
            },
          ) : null,
        ),
      ),
    );
  }

  void updateState(String screenTitle, {List<ApplicationObject> params = const []}) {
    isLoggedIn = DataManager.isLogged();
    if (!isLoggedIn && screenTitle != 'Login') {
      screenTitle = 'Login';
    }
    debugPrint('Params length: ${params.length}');
    setState(() {
      debugPrint('Updating state to screen: $screenTitle with params: $params');
      _currentScreenTitle = screenTitle;
      currentParams = params;
      debugPrint('Return screen path: $returnScreenPath');
      debugPrint('Return params: $returnScreenParams');
    });
  }

  void reloadCurrentScreen() {
    setState(() {
      updateState(_currentScreenTitle, params: currentParams);
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
        debugPrint(params.isNotEmpty.toString());
        VisualizeUserScreen.user = params.isNotEmpty? params[0] as User : DataManager.getSelfUser()!;
        return VisualizeUserScreen.buildFullDetails(context);
      case 'Login':
        return LoginScreen();
      case 'Chats':
        return ChatsScreen();
      case 'Chat':
        return VisualizeChatScreen(chat: params.isNotEmpty ? params[0] as Chat : DataManager.getChats().first); //Placeholder for ChatScreen
      case 'Home':
        return HomeScreen();
      case 'Friends':
        return FriendsScreen();
      case 'FriendRequests':
        return FriendRequestsScreen();
      case 'Group':
        VisualizeGroupScreen.group = params.isNotEmpty? params[0] as Group : null;
        return VisualizeGroupScreen.buildFullDetails(context);
      case 'Calendar':
        return ExpeditionsScreen();
      case 'Event':
        return VisualizeEventScreen(event: params.isNotEmpty? params[0] as Event : null);
      case 'EditEvent':
        return EditEventScreen(event: params.isNotEmpty? params[0] as Event : null,);
      case 'Settings':
        return SettingsScreen();
      default:
        return Center(child: Text('Screen not found: $currentScreenTitle'));
    }
  }

}
