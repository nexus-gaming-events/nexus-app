import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/classes/message.dart';
import 'constants.dart';
import 'widgets/custom_navbar.dart';
import 'widgets/galaxy_background.dart';
import 'screens/screens.dart';  
import 'classes/event.dart';
import 'classes/application_object.dart';
import 'classes/user.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'classes/user_settings.dart';
import 'classes/group.dart';
import '../classes/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSettings.loadFromJson();
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
  late final int selfId;
  User? selfUser;
  List<User> users = [];
  List<ApplicationObject> currentParams = [];
  bool isLoggedIn = true;
  List<String> returnScreenPath = [];
  List<List<ApplicationObject>> returnScreenParams = [];
  List<Event> events = [];
  List<User> friends = [];
  List<Group> friendGroups = [];
  List<FriendRequest> friendRequests = [];
  List<Chat> chats = [];

  factory NexusAppState() {
    instance ??= NexusAppState._internal();
    return instance!;
  }

  NexusAppState._internal();

  @override
  void initState() {
    super.initState();
    
    selfId = 0;
    selfUser = User(id: 12, username: "Big Boss", imageUrl: "https://imgur.com/Fjiw4cX.jpg", email: "big.boss@outerheaven.zl");
    events.add(   
      Event(
      id: 0,
      title: "Outer Heaven Recruitment Meeting",
      author: selfUser!,
      description:
          "Join us for an exclusive recruitment meeting for Outer Heaven. Learn about our mission, values, and how you can be a part of our elite team.",
      date: DateTime.now(),
      maxPlayers: 10,
      maxSpectators: 10,
      players: [selfUser!],
      spectators: [User(id: 1, username: "Solid Snake", imageUrl: "https://imgur.com/zj8eDdn.jpg", email: "solid.snake@phylantropy.us"),
      User(id: 2, username: "Liquid Snake", imageUrl: "https://imgur.com/Wqs6EKD.jpg", email: "liquid.snake@foxhound.us"),
      User(id: 3, username: "Revolver Ocelot", imageUrl: "https://imgur.com/ohc6hXB.jpg", email: "revolver.ocelot@patriots.us"),
      ],
      games: ["Metal Gear Solid"],
      links: ["https://www.konamimerda.com/mg/"],
    ),
    );
    if(!isLoggedIn){
      _currentScreenTitle = 'Login';
      _selectedIndex = 2;
    } else {
      updateState(_currentScreenTitle);
    }
    friends = [
      User(id: 1, username: "Solid Snake", imageUrl: "https://imgur.com/zj8eDdn.jpg", email: "solid.snake@phylantropy.us"),
      User(id: 2, username: "Liquid Snake", imageUrl: "https://imgur.com/Wqs6EKD.jpg", email: "liquid.snake@foxhound.us"),
      User(id: 3, username: "Revolver Ocelot", imageUrl: "https://imgur.com/ohc6hXB.jpg", email: "revolver.ocelot@patriots.us"),
      ];
    friendGroups = [
      Group(id: 0, name: 'Foxhound', friends: friends),
    ];
    friendRequests = [
      FriendRequest(id: 0, username: "Raiden", imageUrl: "https://imgur.com/EwOrrYT.jpg", date: DateTime.now()),
      FriendRequest(id:1, username: "Campbell", imageUrl: "", date: DateTime(2024, 6, 1)),    
    ];
    chats = [
      Chat(id: 0, eventId: 0, messages: [Message(1, 0, "Father...", DateTime.now(), Colors.blue)]),
    ];
    users = [
      selfUser!,
      ...friends,
      User(id: 4, username: "Raiden", imageUrl: "https://imgur.com/EwOrrYT.jpg", email: ""),
      User(id: 5, username: "Campbell", imageUrl: "", email: ""),
    ];
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
    debugPrint('Params length: ${params.length}');
    setState(() {
      debugPrint('Updating state to screen: $screenTitle with params: $params');
      _currentScreenTitle = screenTitle;
      currentParams = params;
      debugPrint('Return screen path: $returnScreenPath');
      debugPrint('Return params: $returnScreenParams');
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
        VisualizeUserScreen.user = params.isNotEmpty? params[0] as User : selfUser!;
        return VisualizeUserScreen.buildFullDetails(context);
      case 'Login':
        return LoginScreen();
      case 'Chats':
        return ChatsScreen();
      case 'Chat':
        return VisualizeChatScreen(chat: params.isNotEmpty ? params[0] as Chat : chats.first); //Placeholder for ChatScreen
      case 'Home':
        return HomeScreen();
      case 'Friends':
        return FriendsScreen();
      case 'Group':
        VisualizeGroupScreen.group = params.isNotEmpty? params[0] as Group : null;
        return VisualizeGroupScreen.buildFullDetails(context);
      case 'Calendar':
        return ExpeditionsScreen();
      case 'Event':
        VisualizeEventScreen.event = params.isNotEmpty? params[0] as Event : null;
        return VisualizeEventScreen.buildFullDetails(context);
      case 'EditEvent':
        return EditEventScreen(event: params.isNotEmpty? params[0] as Event : null,);
      case 'Settings':
        return SettingsScreen();
      default:
        return Center(child: Text('Screen not found: $currentScreenTitle'));
    }
  }
  
}
