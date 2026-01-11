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
  
  static Future<void> initialize() async {
    await loadSelfUser();
    await loadFriendRequests();
    await loadEvents();
  }

  static Future<void> loadSelfUser() async{
    _selfUser = await WebInterfaceService.fetchSelfUser();
  }

  static User? getSelfUser() {
    if (_selfUser == null){
      loadSelfUser();
    }
    return _selfUser;
  }

  static Future<void> loadFriendRequests() async{
    _friendRequests = await WebInterfaceService.fetchFriendRequests();
  }

  static List<FriendRequest> getFriendRequests() {
    if (_friendRequests == null){
      loadFriendRequests();
    }
    return _friendRequests ?? [];
  }

  static Future<void> loadEvents() async{
    _events = await WebInterfaceService.fetchEvents();
  }

  static List<Event> getEvents() {
    if (_events == null){
      loadEvents();
    }
    return _events ?? [];
  }

  static Future<void> loadFriends() async{
    _friends = await WebInterfaceService.fetchFriends();
  } 

  static List<User> getFriends() {
    if (_friends == null){
      loadFriends();
    }
    return _friends ?? [];
  }

  static Future<void> loadGroups() async{
    _friendGroups = await WebInterfaceService.fetchGroups();
  }

  static List<Group> getGroups() {
    if (_friendGroups == null){
      loadGroups();
    }
    return _friendGroups ?? [];
  }

  static Future<Group?> getGroupById(int groupId) async{
    return await WebInterfaceService.fetchGroupById(groupId);
  }

  static Future<List<Message>> getMessagesForEvent(int eventId) async{
    return await WebInterfaceService.fetchChatMessages(eventId);
  }
  
  static Future<void> loadChat(int eventId) async{
    _chats ??= [];
    _chats?.add(Chat(eventId: eventId, messages: await getMessagesForEvent(eventId)));
  }

  static List<Chat> getChats() {
    if (_chats == null){
      for (var event in _events ?? []) {
        loadChat(event.id);
      }
    }
    return _chats ?? [];
  }

  static Future<Chat> getChatByEventId(int eventId) async {
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
    loadEventById(eventId);
    return _currentEvent != null && _currentEvent!.id == eventId ? _currentEvent : null;
  }

  static void joinEvent(int eventId, String role) async {
    await WebInterfaceService.joinEvent(eventId, role);
    // Optionally refresh events list
    loadEvents();
  }

  static void leaveEvent(int eventId) async {
    await WebInterfaceService.leaveEvent(eventId);
    // Optionally refresh events list
    loadEvents();
  }

  static void patchEvent(Event event) async {
    await WebInterfaceService.patchEvent(event);
    // Optionally refresh events list
    loadEvents();
  }

  static void deleteEvent(int eventId) async {
    await WebInterfaceService.deleteEvent(eventId);
    // Optionally refresh events list
    loadEvents();
  }

  static Future<int> createEvent(Event event) async {
    int newEventId = await WebInterfaceService.postEvent(event);
    // Optionally refresh events list
    loadEvents();
    return newEventId;
  }

  static void loadUserbyId(int userId) async {
    _currentUser = await WebInterfaceService.fetchUserById(userId);
  }

  static User? getUserById(int userId) {
    loadUserbyId(userId);
    return _currentUser != null && _currentUser!.id == userId ? _currentUser : null;
  }

  static void sendFriendRequest(int id) async {
    await WebInterfaceService.sendFriendRequest(id);
    _myFriendRequests.add(id);
  }

  static void deleteFriend(int id) async {
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
        Event event = WebInterfaceService.fetchEventById(eventId) as Event;
        return event.author.id == userId;
      } catch (e){
        return false;
      }
    }
  }

  static bool isUserInPlayers(int userId, int eventId) {
   try{
        Event event = WebInterfaceService.fetchEventById(eventId) as Event;
        return event.players!.any((player) => player.id == userId);
      } catch (e){
        return false;
      }
    }

  static bool isUserInSpectators(int userId, int eventId) {
   try{
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