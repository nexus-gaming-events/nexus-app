
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nexus_app/classes/event.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/classes/message.dart';
import 'package:nexus_app/classes/user.dart';
import 'package:nexus_app/classes/chat.dart';
import 'package:nexus_app/classes/group.dart';
import 'package:nexus_app/main.dart';
import 'package:nexus_app/services/secure_storage_service.dart';
import 'package:web_socket_channel/io.dart';
import 'services/web_interface_service.dart';

class DataManager {
  static User? _selfUser;
  static User? _currentUser;

  static List<User>? _friends;
  static List<FriendRequest>? _friendRequests;
  static List<Group>? _friendGroups;

  static List<int> _myFriendRequests = [];

  static List<Event>? _events;
  static Event? _currentEvent;
  static List<Chat>? _chats;

  static final bool isOfflineMode = false;
  static bool isLoggedIn = false;

  static Future<void> initialize() async {
    if (isOfflineMode) {
      _selfUser = User(id: 0, username: 'OfflineUser', email: 'offline@example.com', avatarUrl: 'https://imgur.com/Fjiw4cX.png', bannerGradient: {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0});
      _friends = [User(id: 1, username: 'Friend1', email: 'friend1@example.com', avatarUrl: 'https://imgur.com/N4Q6fcZ.png', bannerGradient: {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0})];
      _friendRequests = [FriendRequest(id: 2, username: 'Requester1', imageUrl: 'https://imgur.com/BVayEBY.png', date: DateTime(2025,1,7))];
      _myFriendRequests = [3];
      _events = [
        Event(
          id: 0,
          title: 'My event',
          author: _selfUser!,
          description: 'This is my event description.',
          date: DateTime.now().add(Duration(days: 5)),
          maxPlayers: 10,
          maxSpectators: 5,
          games: ['Metal Gear Solid'],
          links: ['https://www.example.com'],
          players: [_selfUser!],
          spectators: [User(id: 1, username: 'Friend1', email: 'friend1@example.com', avatarUrl: 'https://imgur.com/N4Q6fcZ.png', bannerGradient: {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0})],
          groupId: 0,
          onlyFriends: false,
          ),
        Event(
          id: 1,
          title: 'Friend1\'s event',
          author: _friends!.first,
          description: 'This is Friend1\'s event description.',
          date: DateTime.now().add(Duration(days: 10)),
          maxPlayers: 8,
          maxSpectators: 3,
          games: ['The Legend of Zelda'],
          links: ['https://www.example2.com'],
          players: [_friends!.first, User(id: 2, username: 'Requester1', avatarUrl: 'https://imgur.com/BVayEBY.png', email: '', bannerGradient: {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0})],
          spectators: [User(id: 3, username: 'Spectator1', email: 'spectator1@example.com', avatarUrl: 'https://imgur.com/JEnJCBW.png', bannerGradient: {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0})],
          groupId: 0,
          onlyFriends: true,
        )
          ];
          _friendGroups = [
            Group(id: 0, name: 'Group1', friends: [ _friends!.first]),
          ];
          _chats = [
            Chat(eventId: 0, messages: [
              Message( 0, 0, 'Hello, this is a message in my event chat.', DateTime.now().subtract(Duration(days: 1)), Colors.blue),
              Message( 1, 1, 'Hi! This is a reply from Friend1.', DateTime.now().subtract(Duration(hours: 20)), Colors.green),
            ]),
          ];
      return;
    }

    if (WebInterfaceService.token == null) {
      debugPrint('No token found, skipping self user load');
      return;
    }

  try{
    await loadSelfUser();
  }catch (e){
    SecureStorageService().deleteAllTokens();
    NexusAppState.instance!.updateState('Login');
    return;
  }
    
    await loadFriends();
    await loadFriendRequests();
    await loadEvents();

    isLoggedIn = await SecureStorageService().hasNexusToken();

    debugPrint('DataManager initialized. Self user: ${_selfUser?.username}, Friends: ${_friends?.length}, Friend Requests: ${_friendRequests?.length}, Events: ${_events?.length}');
  }

  static Future<void> loadSelfUser() async{
    _selfUser = await WebInterfaceService.fetchSelfUser();
    debugPrint("=====Loaded self user=====");
    debugPrint('ID: ${_selfUser?.id}');
    debugPrint('Username: ${_selfUser?.username}');
    debugPrint('Email: ${_selfUser?.email}');
    debugPrint('Avatar URL: ${_selfUser?.avatarUrl}');
    debugPrint('Banner Gradient:');
    debugPrint('  Type: ${_selfUser?.bannerGradient?['type']}');
    debugPrint('  Colors: ${_selfUser?.bannerGradient?['colors']}');
    debugPrint('  Parameter: ${_selfUser?.bannerGradient?['parameter']}');
  }

  static User? getSelfUser() {
    return _selfUser;
  }

  static Future<void> loadFriendRequests() async{
    _friendRequests = await WebInterfaceService.fetchFriendRequests();
  }

  static List<FriendRequest> getFriendRequests() {
    if (isOfflineMode){
      return _friendRequests ?? [];
    }
    if (_friendRequests == null){
      loadFriendRequests();
    }
    return _friendRequests ?? [];
  }

  static Future<void> loadEvents() async{
    _events = await WebInterfaceService.fetchEvents();
    for (var event in _events!) {
      for (var player in event.players ?? []) {
        debugPrint('Event ${event.title} has player: ${player.username}');
      }
    }
  }

  static List<Event> getEvents() {
    if (isOfflineMode){
      return _events ?? [];
    }
    if (_events == null){
      loadEvents();
    }
    return _events ?? [];
  }

  static Future<void> loadFriends() async{
    _friends = await WebInterfaceService.fetchFriends();
  }

  static List<User> getFriends() {
    if (isOfflineMode){
      return _friends ?? [];
    }
    if (_friends == null){
      loadFriends();
    }
    return _friends ?? [];
  }

  static Future<void> loadGroups() async{
    _friendGroups = await WebInterfaceService.fetchGroups();
  }

  static List<Group> getGroups() {
    if (isOfflineMode){
      return _friendGroups ?? [];
    }
    if (_friendGroups == null){
      loadGroups();
    }
    return _friendGroups ?? [];
  }

  static Future<Group?> getGroupById(int groupId) async{
    if (isOfflineMode){
      return _friendGroups?.firstWhere((group) => group.id == groupId);
    }
    return await WebInterfaceService.fetchGroupById(groupId);
  }

  static Future<void> createGroup(String groupName) async{
    if (isOfflineMode){
      int newId = (_friendGroups != null && _friendGroups!.isNotEmpty) ? _friendGroups!.map((g) => g.id).reduce(max) + 1 : 0;
      _friendGroups ??= [];
      _friendGroups!.add(Group(id: newId, name: groupName, friends: []));
      return;
    }
    await WebInterfaceService.postGroup(groupName);
    // Optionally refresh groups list
    loadGroups();
  }

  static Future<void> deleteGroup(int groupId) async{
    if (isOfflineMode){
      _friendGroups?.removeWhere((group) => group.id == groupId);
      return;
    }
    await WebInterfaceService.deleteGroup(groupId);
    // Optionally refresh groups list
    loadGroups();
  }

  static Future<void> addFriendToGroup(int groupId, int friendId) async{
    if (isOfflineMode){
      Group? group = _friendGroups?.firstWhere((group) => group.id == groupId);
      User? friend = _friends?.firstWhere((friend) => friend.id == friendId);
      if (group != null && friend != null && !group.friends.any((f) => f.id == friendId)){
        group.friends.add(friend);
      }
      return;
    }
    await WebInterfaceService.addFriendToGroup(groupId, friendId);
    // Optionally refresh groups list
    loadGroups();
  }

  static Future<void> addFriendsToGroup(int groupId, List<User> friends) async{
    for (var friend in friends) {
      await addFriendToGroup(groupId, friend.id);
    }
  }

  static Future<void> removeFriendFromGroup(int groupId, int friendId) async{
    if (isOfflineMode){
      Group? group = _friendGroups?.firstWhere((group) => group.id == groupId);
      if (group != null){
        group.friends.removeWhere((f) => f.id == friendId);
      }
      return;
    }
    await WebInterfaceService.removeFriendFromGroup(groupId, friendId);
    // Optionally refresh groups list
    loadGroups();
  }

  static Future<void> removeFriendsFromGroup(int groupId, List<User> friends) async{
    for (var friend in friends) {
      await removeFriendFromGroup(groupId, friend.id);
    }
  }

  static Future<List<Message>> getMessagesForEvent(int eventId) async{
    if (isOfflineMode){
      return _chats?.firstWhere((chat) => chat.eventId == eventId).messages ?? [];
    }
    return await WebInterfaceService.fetchChatMessages(eventId);
  }

  static void insertMessagesIntoChat(int eventId, List<Message> messages) {
    Chat? chat;
    try {
      chat = _chats?.firstWhere((chat) => chat.eventId == eventId);
    } catch (e) {
      chat = null;
    }
    if (chat != null) {
      chat.messages.addAll(messages);
      chat.messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    else {
      _chats ??= [];
      _chats!.add(Chat(eventId: eventId, messages: messages));
    }
  }

  static Future<void> loadChat(int eventId) async{
    insertMessagesIntoChat(eventId, await getMessagesForEvent(eventId));
  }

  static Future<void> ensureChatsLoaded() async {
      if (isOfflineMode || _chats != null) {
        return;
      }
      for (var event in _events ?? []) {
        await loadChat(event.id);
        await ChatWebSocketManager.openChatConnection(event.id);
      }
  }

  static List<Chat> getChats() {
    return _chats ?? [];
  }

  static Future<Chat> getChatByEventId(int eventId) async {
    if (isOfflineMode){
      return _chats!.firstWhere((chat) => chat.eventId == eventId);
    }
    await ensureChatsLoaded();
    try {
      return getChats().firstWhere((chat) => chat.eventId == eventId);
    } catch (e) {
      // Chat not found, create a new one
      final messages = await getMessagesForEvent(eventId);
      final newChat = Chat(eventId: eventId, messages: messages);
      _chats ??= [];
      _chats!.add(newChat);
      return newChat;
    }
  }


  static Future<Event?> loadEventById(int eventId) async{
    _currentEvent = await WebInterfaceService.fetchEventById(eventId);
    return _currentEvent;
  }

  static Future<Event?> getEventById(int eventId) async {
    if (isOfflineMode){
      return _events?.firstWhere((event) => event.id == eventId);
    }
    return await loadEventById(eventId);
  }

  static Future<void> joinEvent(int eventId, String role) async {
    if (isOfflineMode){
      return;
    }
    await WebInterfaceService.joinEvent(eventId, role);
    // Optionally refresh events list
    loadEvents();
  }

  static Future<void> leaveEvent(int eventId) async {
    if (isOfflineMode){
      return;
    }
    await WebInterfaceService.leaveEvent(eventId);
    // Optionally refresh events list
    loadEvents();
  }

  static Future<void> patchEvent(Event event) async {
    if (isOfflineMode){
      return;
    }
    await WebInterfaceService.patchEvent(event);
    // Optionally refresh events list
    loadEvents();
  }

  static void deleteEvent(int eventId) async {
    if (isOfflineMode){
      return;
    }
    await WebInterfaceService.deleteEvent(eventId);
    // Optionally refresh events list
    loadEvents();
  }

  static Future<int> createEvent(Event event) async {
    if (isOfflineMode){
      debugPrint('Creating event in offline mode: ${event.title}');
      return 10;
    }
    int newEventId = await WebInterfaceService.postEvent(event);
    // Optionally refresh events list
    loadEvents();
    return newEventId;
  }

  static Future<User?> loadUserbyId(int userId) async {
    _currentUser = await WebInterfaceService.fetchUserById(userId);
    return _currentUser;
  }

  static Future<User?> getUserById(int userId) async {
    if (isOfflineMode){
      if (_selfUser != null && _selfUser!.id == userId){
        return _selfUser;
      }
      for (var friend in _friends ?? []) {
        if (friend.id == userId){
          return friend;
        }
      }
      for (var request in _friendRequests ?? []) {
        if (request.id == userId){
          return User(id: request.id, username: request.username, email: '', avatarUrl: request.avatarUrl);
        }
      }
      return null;
    }
    return await loadUserbyId(userId);
  }

  static Future<void> sendFriendRequest(int id) async {
    if (isOfflineMode){
      _myFriendRequests.add(id);
      return;
    }
    await WebInterfaceService.sendFriendRequest(id);
    _myFriendRequests.add(id);
  }

  static Future<void> deleteFriend(int id) async {
    if (isOfflineMode){
      _friends?.removeWhere((friend) => friend.id == id);
      return;
    }
    await WebInterfaceService.deleteFriend(id);
  }

  static bool isFriend(int id) {
    return getFriends().any((friend) => friend.id == id);
  }

  static bool isSelf(int id) {
    return _selfUser != null && _selfUser!.id == id;
  }

  static bool hasPendingFriendRequest(int id) { // If they sent me a request
    return getFriendRequests().any((request) => request.id == id);
  }

  static Future<void> loadMyFriendRequests() async {
    if (isOfflineMode){
      return;
    }
    final myRequests = await WebInterfaceService.fetchMyFriendRequests();
    _myFriendRequests = myRequests?.map((request) => request.id).toList() ?? [];
  }

  static bool hasSentFriendRequest(int id) { // If I sent them a request
    return _myFriendRequests.contains(id);    
  }

  static Future<bool> isAuthor(int userId, int eventId) async {
    try {
      Event event = _events!.firstWhere((e) => e.id == eventId);
      return event.author.id == userId;
    } catch (e) {
      try{
        if (isOfflineMode){
          return false;
        }
        Event event = await WebInterfaceService.fetchEventById(eventId) as Event;
        return event.author.id == userId;
      } catch (e){
        return false;
      }
    }
  }

  static Future<bool> isUserInPlayers(int userId, int eventId) async {
   try{
        if (isOfflineMode){
          Event event = _events!.firstWhere((e) => e.id == eventId);
          return event.players!.any((player) => player.id == userId);
        }

        Event event = await WebInterfaceService.fetchEventById(eventId) as Event;
        debugPrint('Checking if user $userId is in players for event ${event.title}');
        for (var player in event.players ?? []) {
          debugPrint('Player in event: ${player.username} (ID: ${player.id})');
        }
        return event.players!.any((player) => player.id == userId);
      } catch (e){
        return false;
      }
    }

  static Future<bool> isUserInSpectators(int userId, int eventId) async {
   try{
        if (isOfflineMode){
          Event event = _events!.firstWhere((e) => e.id == eventId);
          return event.spectators!.any((spectator) => spectator.id == userId);
        }
        Event event = await WebInterfaceService.fetchEventById(eventId) as Event;
        return event.spectators!.any((spectator) => spectator.id == userId);
      } catch (e){
        return false;
      }


  }

  static List<Event>? getEventsAuthored(int userId) {
    return _events?.where((event) => event.author.id == userId).toList();
  }

  static List<Event>? getEventsInvolved() {
    return [];
    // This function can be implemented to return events the user is involved in
  }

  static Future<Event> editEvent(Event event) async {
    int id;
    if (event.id == -1) {
      debugPrint('Creating new event: ${event.title}');
      id = await createEvent(event);
      //joinEvent(id, "player"); // Refresh events to get the new event with its assigned ID
      debugPrint('Event created with ID: $id');
      _currentEvent = await getEventById(id);
      debugPrint('Current event set to: ${_currentEvent!.title} with ID: ${_currentEvent!.id}');
    } else {
      await patchEvent(event);
      _currentEvent = event;
    }
    return _currentEvent!;
  }

  static Future<Event> editAndGetEvent(Event event) async {
    debugPrint('Editing event: ${event.title} with ID: ${event.id}');
    return await editEvent(event);
  }

  static Future<void> acceptFriendRequest(int id) async {
    await WebInterfaceService.acceptFriendRequest(id);
    debugPrint('Accepted friend request with ID: $id');
    // Optionally refresh friends and friend requests list
    await loadFriends();
    await loadFriendRequests();
  }

  // Helper method to add months accounting for varying month lengths
  static DateTime addMonths(DateTime date, int months) {
    int newYear = date.year;
    int newMonth = date.month + months;

    // Handle year overflow/underflow
    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear -= 1;
    }

    // Handle day overflow (e.g., Jan 31 + 1 month = Feb 28/29)
    int newDay = date.day;
    int maxDayInMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > maxDayInMonth) {
      newDay = maxDayInMonth;
    }

    return DateTime(
      newYear,
      newMonth,
      newDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  static Future<List<Event>> createRecurrentEvents(Event newEvent, String periodicity, String recurrenceTime) async {
    List<Event> createdEvents = [];
    DateTime currentDate = newEvent.date;
    DateTime endDate;
    if (recurrenceTime == '1 week') {
      endDate = newEvent.date.add(Duration(days: 7));
    } else if (recurrenceTime == '1 month') {
      endDate = addMonths(newEvent.date, 1);
    } else if (recurrenceTime == '3 month') {
      endDate = addMonths(newEvent.date, 3);
    } else if (recurrenceTime == '6 month') {
      endDate = addMonths(newEvent.date, 6);
    } else if (recurrenceTime == '1 year') {
      endDate = addMonths(newEvent.date, 12);
    }
    else {
      return createdEvents; // Invalid recurrence time
    }

    while (currentDate.isBefore(endDate)) {
      Event eventCopy = Event(
        id: -1, // New event, ID will be assigned by backend
        title: newEvent.title,
        author: newEvent.author,
        description: newEvent.description,
        date: currentDate,
        maxPlayers: newEvent.maxPlayers,
        maxSpectators: newEvent.maxSpectators,
        players: newEvent.players,
        spectators: newEvent.spectators,
        games: newEvent.games,
        links: newEvent.links,
        groupId: newEvent.groupId,
        onlyFriends: newEvent.onlyFriends,
      );
      createdEvents.add(eventCopy);
      if (periodicity == 'Daily') {
        currentDate = currentDate.add(Duration(days: 1));
      } else if (periodicity == 'Weekly') {
        currentDate = currentDate.add(Duration(days: 7));
      } else if (periodicity == 'Monthly') {
        currentDate = addMonths(currentDate, 1);
      } else {
      currentDate = currentDate.add(Duration(days: 1));
      } // Adjust this based on your periodicity logic
      }
     for (var event in createdEvents) {
      Event savedEvent = await editAndGetEvent(event); // Save event and get assigned ID
      event.id = savedEvent.id;
      }
    return createdEvents;
  }

  static Future<void> saveUserBanner(Gradient gradient, double parameter) async {
    Map<String, dynamic> gradientJson;
    if (gradient is LinearGradient) {
      gradientJson = {
        'type': 'linear',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
        'parameter': parameter,
      };
    }
    else if (gradient is RadialGradient) {
      gradientJson = {
        'type': 'radial',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
        'parameter': parameter,
      };
    }
    else if (gradient is SweepGradient) {
      gradientJson = {
        'type': 'sweep',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
        'parameter': parameter,
      };
    }
    else gradientJson = {'type': 'linear', 'colors': ['ff0000ff', 'ffff00ff'], 'parameter': parameter};
    await WebInterfaceService.saveUserBanner(gradientJson);
    await loadSelfUser(); // Refresh self user to get updated banner
  }

  static Color _parseColorFromJson(dynamic colorValue) {
    if (colorValue is int) {
      return Color(colorValue);
    }
    if (colorValue is String) {
      String cleaned = colorValue
          .replaceAll('0x', '')
          .replaceAll('0X', '')
          .replaceAll('#', '');
      return Color(int.parse(cleaned, radix: 16));
    }
    throw FormatException('Invalid color format: $colorValue');
  }

  static Gradient? getGradientFromJson(Map<String, dynamic>? bannerGradient) {
    if (bannerGradient == null) return null;

    try {
      String selectedBlendMode = bannerGradient['type'] ?? 'linear';
      List<Color> colors = (bannerGradient['colors'] as List)
          .map((c) => _parseColorFromJson(c))
          .toList();
      double paramter = (bannerGradient['parameter'] as num?)?.toDouble() ?? 0.0;

      if (colors.length < 2) {
        colors = [Colors.blue, Colors.purple];
      }

      Gradient selectedGradient;
      if (selectedBlendMode == 'linear') {
        selectedGradient = LinearGradient(
          colors: [colors[0], colors[1]],
          begin: Alignment(-1, 0.0),
          end: Alignment(paramter + 1, 0.0),
        );
      } else if (selectedBlendMode == 'radial') {
        selectedGradient = RadialGradient(
          colors: [colors[0], colors[1]],
          radius: paramter + 1,
        );
      } else if (selectedBlendMode == 'sweep') {
        selectedGradient = SweepGradient(
          colors: [colors[0], colors[1]],
          startAngle: 0,
          endAngle: (4 * (math.pi + 1) * (paramter / 2.0 + 0.5)).clamp(
            0.000000000001,
            (4 * math.pi + 1),
          ),
        );
      } else {
        selectedGradient = LinearGradient(
          colors: [colors[0], colors[1]],
          begin: Alignment(-1, 0.0),
          end: Alignment(paramter + 1, 0.0),
        );
      }
      return selectedGradient;
    } catch (e) {
      print('Error parsing gradient from JSON: $e');
      // Return default gradient on error
      return LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment(-1, 0.0),
        end: Alignment(1, 0.0),
      );
    }
  }

  static bool isLogged() {
    return isLoggedIn;
  }

  static void logout() {
    _selfUser = null;
    _friends = null;
    _friendRequests = null;
    _friendGroups = null;
    _events = null;
    _currentEvent = null;
    _chats = null;
    isLoggedIn = false;
    SecureStorageService().deleteAllTokens();
    NexusAppState.instance!.returnScreenParams.clear();
    NexusAppState.instance!.returnScreenPath.clear();
    NexusAppState.instance!.updateState('Login');
  }

  static Future<void> removeFriendRequest(int id) async {
    if (isOfflineMode){
      _friendRequests?.removeWhere((request) => request.id == id);
      return;
    }
    await WebInterfaceService.deleteFriendRequest(id);
    // Optionally refresh friend requests list
    await loadFriendRequests();
  }

  static Future<List<User>> searchUsers(String query) async {
    if (isOfflineMode){
      return [];
    }
    return await WebInterfaceService.searchUsers(query);
  }

}

/// Manages WebSocket connections for event chats
class ChatWebSocketManager {
  static Map<int, IOWebSocketChannel> _chatSockets = {};
  static Map<int, StreamSubscription> _chatSubscriptions = {};
  static Map<int, List<void Function(int eventId)>> _chatCallbacks = {};
  static final String _webSocketUrlTemplate = 'wss://nexus.orciuolo.it/chat?token={token}&eventId={eventId}';

  /// Opens a WebSocket connection for the given eventId and registers a callback
  static Future<IOWebSocketChannel?> openChatConnection(int eventId, [void Function(int eventId)? onNewMessage]) async {
    if (!DataManager.isLogged()) {
      debugPrint('User not logged in, cannot open chat connection');
      return null;
    }
    // Register callback
    if (onNewMessage != null) {
      _chatCallbacks.putIfAbsent(eventId, () => []);
      _chatCallbacks[eventId]!.add(onNewMessage);
    }
    if (_chatSockets.containsKey(eventId)) {
      debugPrint('WebSocket connection for event $eventId already exists');
      return _chatSockets[eventId];
    }
    final String websocketUrl = _webSocketUrlTemplate
        .replaceFirst('{token}', await SecureStorageService().getNexusToken() ?? '')
        .replaceFirst('{eventId}', eventId.toString());
    try {
      _chatSockets[eventId] = IOWebSocketChannel.connect(Uri.parse(websocketUrl));
    } catch (e) {
      debugPrint('Error connecting to WebSocket for event $eventId: $e');
      return null;
    }
    try {
      _chatSubscriptions[eventId] = _chatSockets[eventId]!.stream.listen(
        (message) {
          debugPrint('Received message on WebSocket for event $eventId: $message');
          Map<String, dynamic> messageData;
          try {
            messageData = Map<String, dynamic>.from(jsonDecode(message));
          } catch (e) {
            debugPrint('Error parsing WebSocket message for event $eventId: $e');
            return;
          }
          Message newMessage = Message(
            messageData['userid'],
            eventId,
            messageData['content'],
            DateTime.parse(messageData['createdAt']),
            Colors.blue, // Default color, can be enhanced to include color info in the message data
          );
          DataManager.insertMessagesIntoChat(eventId, [newMessage]);
          if (_chatCallbacks.containsKey(eventId)) {
            for (var callback in _chatCallbacks[eventId]!) {
              callback(eventId);
            }
          }
        },
        onError: (error) {
          debugPrint('WebSocket error for event $eventId: $error');
          _chatSockets.remove(eventId);
        },
        onDone: () {
        },
      );
    } catch (e) {
      debugPrint('Error setting up WebSocket listeners for event $eventId: $e');
      _chatSockets.remove(eventId);
      return null;
    }
    return _chatSockets[eventId];
  }

  /// Closes the WebSocket connection for the given eventId and removes callbacks
  static Future<void> closeChatConnection(int eventId) async {
    if (!DataManager.isLogged()) {
      debugPrint('User not logged in, cannot close chat connection');
      return;
    }
    if (!_chatSockets.containsKey(eventId)) {
      debugPrint('No WebSocket connection found for event $eventId');
      return;
    }
    try {
      await _chatSubscriptions[eventId]?.cancel();
    } catch (e) {
      debugPrint('Error cancelling WebSocket subscription for event $eventId: $e');
    }
    try {
      await _chatSockets[eventId]?.sink.close();
    } catch (e) {
      debugPrint('Error closing WebSocket sink for event $eventId: $e');
    }
    _chatSubscriptions.remove(eventId);
    _chatSockets.remove(eventId);
    _chatCallbacks.remove(eventId);
  }

  /// Sends a message to the chat for the given eventId
  static Future<void> sendMessage(int eventId, String message) async {
    if (!DataManager.isLogged()) {
      debugPrint('User not logged in, cannot send message');
      return;
    }
    if (!_chatSockets.containsKey(eventId)) {
      debugPrint('No WebSocket connection found for event $eventId, cannot send message');
      return;
    }
    try {
      _chatSockets[eventId]!.sink.add(message);
      debugPrint('Sent message on WebSocket for event $eventId: $message');
    } catch (e) {
      debugPrint('Error sending message on WebSocket for event $eventId: $e');
    }
  }

  static IOWebSocketChannel? getChatSocket(int eventId) {
    return _chatSockets[eventId];
  }

  static StreamSubscription? getChatSubscription(int eventId) {
    return _chatSubscriptions[eventId];
  }

    /// Registers a callback for the given eventId without opening a new connection
  static void addChatCallback(int eventId, void Function(int eventId) callback) {
    _chatCallbacks.putIfAbsent(eventId, () => []);
    _chatCallbacks[eventId]!.add(callback);
  }
}
