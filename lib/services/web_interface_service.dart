
import 'dart:io';
import 'dart:convert';
import 'package:nexus_app/classes/group.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/classes/chat.dart';
import '../classes/event.dart';
import '../classes/user.dart';
import '../classes/message.dart';
import 'package:flutter/material.dart';


class WebInterfaceService {
  static final String webInterfaceUrl =
      'https://nexus.orciuolo.it/';

  static final HttpClient httpClient = HttpClient();

  static Future<HttpClientRequest> createRequest(
      String endpoint, String method) async {
    final uri = Uri.parse('$webInterfaceUrl$endpoint');
    final request = await httpClient.openUrl(method, uri);
    request.headers.set('Content-Type', 'application/json');
    return request;
  }

  static Future<HttpClientResponse> sendRequest(
    HttpClientRequest request, [String? body]) async {
  if (body != null) {
    request.add(utf8.encode(body));
  }
  final response = await request.close();
  
  if (response.statusCode != 200) {
    final responseBody = await response.transform(utf8.decoder).join();
    throw Exception('HTTP Error ${response.statusCode}: $responseBody');
  }
  
  return response;
  }

  // Objects
  static String? token;
 
  // Users
  static Future<User> fetchSelfUser() async {
    final request = await createRequest('me', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    final selfUser = User(id: data['id'], username: data['username'], imageUrl: data['avatarUrl'], email: data['email']);
    return selfUser;
    }

  static Future<List<User>> fetchUsers() async {
    final request = await createRequest('users', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<User> users = [];
    for (var userData in data['data']) {
      users.add(User(id: userData['id'], username: userData['username'], imageUrl: userData['avatarUrl'], email: userData['email']));
    }
    return users;
  }
  
  static Future<User> fetchUserById(int id) async {
    final request = await createRequest('users/$id', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    return User(id: data['id'], username: data['username'], imageUrl: data['avatarUrl'], email: data['email']);
  }

  // Events

  static Future<List<Event>> fetchEvents() async {
    final request = await createRequest('events', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<Event> events = [];
    User author;
    for (var eventData in data['data']) {
      author = await fetchUserById(eventData['hostId']);
      events.add(Event(
        id: eventData['id'],
        title: eventData['title'],
        description: eventData['description'],
        date: DateTime.parse(eventData['startTime']),
        author: author,
        maxPlayers: eventData['maxPlayers'],
        maxSpectators: eventData['maxSpectators'],
        games: [eventData['game']],
        links: [eventData['discordVoiceLink']],
        ));
    }
    return events;
  }

  static Future<Event> fetchEventById(int id) async {
    final request = await createRequest('events/$id', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    User author = await fetchUserById(data['hostId']);
    List<User> players = [];
    List<User> spectators = [];
    for (var eventPlayerId in data['participants']){
      if(eventPlayerId['role'] == 'player'){
        players.add(User(id: eventPlayerId['user']['id'], username: eventPlayerId['user']['username'], imageUrl: eventPlayerId['user']['avatarUrl']));
      } else if(eventPlayerId['role'] == 'spectator'){
        spectators.add(User(id: eventPlayerId['user']['id'], username: eventPlayerId['user']['username'], imageUrl: eventPlayerId['user']['avatarUrl']));
      }
    }
    return Event(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      date: DateTime.parse(data['startTime']),
      author: author,
      maxPlayers: data['maxPlayers'],
      maxSpectators: data['maxSpectators'],
      games: [data['game']],
      links: [data['discordVoiceLink']],
      players: players,
      spectators: spectators,
      );
    }

    static Future<int> postEvent(Event event) async {
    final request = await createRequest('events', 'POST');
    final body = jsonEncode({
      'title': event.title,
      'description': event.description,
      'startTime': event.date.toIso8601String(),
      'maxPlayers': event.maxPlayers,
      'maxSpectators': event.maxSpectators,
      'game': event.games!.isNotEmpty ? event.games![0] : '',
      'discordVoiceLink': event.links!.isNotEmpty ? event.links![0] : '',
    });
    HttpClientResponse response = await sendRequest(request, body);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    return data['id'];
    }

    static Future<void> patchEvent(Event event) async {
    final request = await createRequest('events/${event.id}', 'PATCH');
    final body = jsonEncode({
      'title': event.title,
      'description': event.description,
      'startTime': event.date.toIso8601String(),
      'maxPlayers': event.maxPlayers,
      'maxSpectators': event.maxSpectators,
      'game': event.games!.isNotEmpty ? event.games![0] : '',
      'discordVoiceLink': event.links!.isNotEmpty ? event.links![0] : '',
      }
      );
    HttpClientResponse response = await sendRequest(request, body);
    }

  static Future<void> deleteEvent(int id) async {
    final request = await createRequest('events/$id', 'DELETE');
    HttpClientResponse response = await sendRequest(request);
  }

  static Future<void> joinEvent(int eventId, String role) async {
    final request = await createRequest('events/$eventId/join', 'POST');
    final body = jsonEncode({
      'role': role,
    });
    HttpClientResponse response = await sendRequest(request, body);
  }

  static Future<void> leaveEvent(int eventId) async {
    final request = await createRequest('events/$eventId/leave', 'POST');
    HttpClientResponse response = await sendRequest(request);
  }

  //Friends

  static Future<List<User>> fetchFriends() async {
    final request = await createRequest('friends', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<User> friends = [];
    for (var friendData in data['data']) {
      friends.add(User(id: friendData['id'], username: friendData['username'], imageUrl: friendData['avatarUrl'], email: friendData['email']));
    }
    return friends;
  }

  static Future<List<FriendRequest>> fetchFriendRequests() async {
    final request = await createRequest('friend/requests', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as List<dynamic>;
    List<FriendRequest> friendRequests = [];
    for (var requestData in data) {
      friendRequests.add(FriendRequest(id: requestData['id'], username: requestData['username'], imageUrl: requestData['avatarUrl'], date: DateTime.parse(requestData['sentAt'])));
    }
    return friendRequests;
  }

  static Future<void> sendFriendRequest(int userId) async {
    final request = await createRequest('friend/request', 'POST');
    final body = jsonEncode({
      'targetUserId': userId,
    });
    HttpClientResponse response = await sendRequest(request, body);
  }

  static Future<void> acceptFriendRequest(int userId) async {
    final request = await createRequest('friend/accept', 'POST');
    final body = jsonEncode({
      'requesterId': userId,
    });
    HttpClientResponse response = await sendRequest(request);
  } 

  static Future<void> deleteFriend(int userId) async {
    final request = await createRequest('friend/${userId}', 'POST');
    HttpClientResponse response = await sendRequest(request);
  }
  // Groups

  static Future<int> postGroup(String name) async {
    final request = await createRequest('groups', 'POST');
    final body = jsonEncode({
      'name': name,
    });
    HttpClientResponse response = await sendRequest(request, body);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    return data['id'];
    }
  
  static Future<List<Group>> fetchGroups() async {
    final request = await createRequest('groups', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<Group> groups = [];
    for (var groupData in data['data']) {
      groups.add(Group(id: groupData['id'], name: groupData['name'], friends: []));
    }
    return groups;
  }

  static Future<Group> fetchGroupById(int id) async {
    final request = await createRequest('groups/$id', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    List<User> groupFriends = [];
    for (var friendData in data['friends']) {
      groupFriends.add(User(id: friendData['id'], username: friendData['username'], imageUrl: friendData['avatarUrl'], email: friendData['email']));
    }
    return Group(id: data['id'], name: data['name'], friends: groupFriends);
  }

  static Future<void> patchGroup(Group group) async {
    final request = await createRequest('groups/${group.id}', 'PATCH');
    final body = jsonEncode({
      'name': group.name,
    });
    HttpClientResponse response = await sendRequest(request, body);
  }

  static Future<void> deleteGroup(int id) async {
    final request = await createRequest('groups/$id', 'DELETE');
    HttpClientResponse response = await sendRequest(request);
  }

  static Future<void> addFriendToGroup(int groupId, int friendId) async {
    final request = await createRequest('groups/$groupId/memebers', 'POST');
    final body = jsonEncode({
      'userId': friendId,
    });
    HttpClientResponse response = await sendRequest(request, body);
  }

  static Future<List<User>> fetchGroupFriends(int groupId) async {
    final request = await createRequest('groups/$groupId/members', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<User> groupFriends = [];
    for (var friendData in data['data']) {
      groupFriends.add(User(id: friendData['id'], username: friendData['username'], imageUrl: friendData['avatarUrl']));
    }
    return groupFriends;
  }

  static Future<void> removeFriendFromGroup(int groupId, int friendId) async {
    final request = await createRequest('groups/$groupId/members/$friendId', 'DELETE');
    HttpClientResponse response = await sendRequest(request);
  }

  static Future<void> leaveGroup(int groupId) async {
    final request = await createRequest('groups/$groupId/leave', 'POST');
    HttpClientResponse response = await sendRequest(request);
  }

  // Chats

  static Future<List<Message>> fetchChatMessages(int eventId) async {
    final request = await createRequest('events/$eventId/messages', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as List;
    List<Message> messages = [];
    for (var messageData in data) {
      messages.add(Message(
        messageData['userid'],
        eventId,
        messageData['content'],
        DateTime.parse(messageData['createdAt']),
        Colors.grey, // Placeholder, as color is not provided by the API
      ));
    }
    return messages;
  }


}