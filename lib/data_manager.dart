import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nexus_app/classes/event.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/classes/message.dart';
import 'package:nexus_app/classes/user.dart';
import 'package:nexus_app/classes/chat.dart';
import 'package:nexus_app/classes/group.dart';
import 'services/web_interface_service.dart';

class DataManager {
  static User? _selfUser;
  static User? _currentUser;

  static List<User>? _friends;
  static List<FriendRequest>? _friendRequests;
  static List<Group>? _friendGroups;

  static List<int> _myFriendRequests = [];

  static List<Event>? _events;
  static List<Event>? _eventsInvolved;
  static Event? _currentEvent;  
  static List<Chat>? _chats;

  static final bool isOfflineMode = true;
  
  static Future<void> initialize() async {
    if (isOfflineMode) {
      _selfUser = User(id: 0, username: 'OfflineUser', email: 'offline@example.com', imageUrl: 'https://imgur.com/Fjiw4cX.png');
      _friends = [User(id: 1, username: 'Friend1', email: 'friend1@example.com', imageUrl: 'https://imgur.com/N4Q6fcZ.png')];
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
          spectators: [User(id: 1, username: 'Friend1', email: 'friend1@example.com', imageUrl: 'https://imgur.com/N4Q6fcZ.png')],
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
          players: [_friends!.first, User(id: 2, username: 'Requester1', imageUrl: 'https://imgur.com/BVayEBY.png', email: '')],
          spectators: [User(id: 3, username: 'Spectator1', email: 'spectator1@example.com', imageUrl: 'https://imgur.com/JEnJCBW.png')],
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
    await loadSelfUser();
    await loadFriendRequests();
    await loadEvents();
  }

  static Future<void> loadSelfUser() async{
    _selfUser = await WebInterfaceService.fetchSelfUser();
  }

  static User? getSelfUser() {
    if (isOfflineMode){
      return _selfUser;
    }
    if (_selfUser == null){
      loadSelfUser();
    }
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

  static Future<List<Message>> getMessagesForEvent(int eventId) async{
    if (isOfflineMode){
      return _chats?.firstWhere((chat) => chat.eventId == eventId)?.messages ?? [];
    }
    return await WebInterfaceService.fetchChatMessages(eventId);
  }
  
  static Future<void> loadChat(int eventId) async{
    _chats ??= [];
    _chats?.add(Chat(eventId: eventId, messages: await getMessagesForEvent(eventId)));
  }

  static List<Chat> getChats() {
    if (isOfflineMode){
      return _chats ?? [];
    }
    if (_chats == null){
      for (var event in _events ?? []) {
        loadChat(event.id);
      }
    }
    return _chats ?? [];
  }

  static Future<Chat> getChatByEventId(int eventId) async {
    if (isOfflineMode){
      return _chats!.firstWhere((chat) => chat.eventId == eventId);
    }
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

    
  static void loadEventById(int eventId) async{
    _currentEvent = await WebInterfaceService.fetchEventById(eventId);
  }

  static Event? getEventById(int eventId) {
    if (isOfflineMode){
      return _events?.firstWhere((event) => event.id == eventId);
    }
    loadEventById(eventId);
    return _currentEvent != null && _currentEvent!.id == eventId ? _currentEvent : null;
  }

  static void joinEvent(int eventId, String role) async {
    if (isOfflineMode){
      return;
    }
    await WebInterfaceService.joinEvent(eventId, role);
    // Optionally refresh events list
    loadEvents();
  }

  static void leaveEvent(int eventId) async {
    if (isOfflineMode){
      return;
    }
    await WebInterfaceService.leaveEvent(eventId);
    // Optionally refresh events list
    loadEvents();
  }

  static void patchEvent(Event event) async {
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
      return 10;
    }
    int newEventId = await WebInterfaceService.postEvent(event);
    // Optionally refresh events list
    loadEvents();
    return newEventId;
  }

  static void loadUserbyId(int userId) async {
    _currentUser = await WebInterfaceService.fetchUserById(userId);
  }

  static User? getUserById(int userId) {
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
          return User(id: request.id, username: request.username, email: '', imageUrl: request.imageUrl);
        }
      }
      return null;
    }
    loadUserbyId(userId);
    return _currentUser != null && _currentUser!.id == userId ? _currentUser : null;
  }

  static void sendFriendRequest(int id) async {
    if (isOfflineMode){
      _myFriendRequests.add(id);
      return;
    }
    await WebInterfaceService.sendFriendRequest(id);
    _myFriendRequests.add(id);
  }

  static void deleteFriend(int id) async {
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

  static bool hasSentFriendRequest(int id) { // If I sent them a request
    return _myFriendRequests.contains(id);
  }

  static bool isAuthor(int userId, int eventId) {
    try {
      Event event = _events!.firstWhere((e) => e.id == eventId);
      return event.author.id == userId;
    } catch (e) {
      try{
        if (isOfflineMode){
          return false;
        }
        Event event = WebInterfaceService.fetchEventById(eventId) as Event;
        return event.author.id == userId;
      } catch (e){
        return false;
      }
    }
  }

  static bool isUserInPlayers(int userId, int eventId) {
   try{
        if (isOfflineMode){
          Event event = _events!.firstWhere((e) => e.id == eventId);
          return event.players!.any((player) => player.id == userId);
        }
        Event event = WebInterfaceService.fetchEventById(eventId) as Event;
        return event.players!.any((player) => player.id == userId);
      } catch (e){
        return false;
      }
    }

  static bool isUserInSpectators(int userId, int eventId) {
   try{
        if (isOfflineMode){
          Event event = _events!.firstWhere((e) => e.id == eventId);
          return event.spectators!.any((spectator) => spectator.id == userId);
        }
        Event event = WebInterfaceService.fetchEventById(eventId) as Event;
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

  static void editEvent(Event event) async {
    int id;
    if (event.id == -1) {
      id = await createEvent(event);
      _currentEvent = new Event(id: id, title: event.title, author: event.author, description: event.description, date: event.date, maxPlayers: event.maxPlayers, maxSpectators: event.maxSpectators);
    } else {
      patchEvent(event);
      _currentEvent = event;
    }
  }
  
  static Event editAndGetEvent(Event event) {
    editEvent(event);
    return _currentEvent!;
  }

  static void acceptFriendRequest(int id) async {
    await WebInterfaceService.acceptFriendRequest(id);
    // Optionally refresh friends and friend requests list
    loadFriends();
    loadFriendRequests();
  }
}