
import 'dart:io';
import 'dart:convert';
import 'package:nexus_app/classes/group.dart';
import 'package:nexus_app/classes/friend_request.dart';
import 'package:nexus_app/classes/login.dart';
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
    // Only set Content-Type for methods that typically have a body
    if (method != 'GET' && method != 'DELETE') {
      request.headers.set('Content-Type', 'application/json');
    }
    if (token != null) {
      request.headers.set('Authorization', 'Bearer $token');
    }
    return request;
  }

  static Future<HttpClientResponse> sendRequest(
    HttpClientRequest request, [String? body]) async {
  if (body != null) {
    request.add(utf8.encode(body));
  }
  final response = await request.close();

  // Accept all 2xx status codes as success
  if (response.statusCode < 200 || response.statusCode >= 300) {
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
    debugPrint('Fetch self user response body: $responseBody');
    final data = jsonDecode(responseBody);
    final selfUser = User(id: data['id'], username: data['username'] ?? 'Unknown', avatarUrl: data['avatarUrl'] ?? '', email: data['email'] ?? '', bannerGradient: data['bannerGradient'] as Map<String, dynamic>? ?? {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0});
    return selfUser;
    }

  static Future<List<User>> fetchUsers() async {
    final request = await createRequest('users', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<User> users = [];
    for (var userData in data['data']) {
      users.add(User(id: userData['id'], username: userData['username'] ?? 'Unknown', avatarUrl: userData['avatarUrl'] ?? '', email: userData['email'] ?? '', bannerGradient: userData['bannerGradient'] as Map<String, dynamic>? ?? {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0}));
    }
    return users;
  }

  static Future<User> fetchUserById(int id) async {
    final request = await createRequest('users/$id', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    return User(id: data['id'], username: data['username'] ?? 'Unknown', avatarUrl: data['avatarUrl'] ?? '', email: data['email'] ?? '', bannerGradient: data['bannerGradient'] as Map<String, dynamic>? ?? {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0});
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
        links: [eventData['discordVoiceLink'] ?? ''],
        numPlayers: eventData['playerCount'] ?? 0,
        numSpectators: eventData['spectatorCount'] ?? 0,
        groupId: eventData['groupId'] ?? 0,
        onlyFriends: eventData['onlyFriends'] ?? false,
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
    debugPrint('Particpants data: ${data['participants']}');
    for (var eventPlayerId in (data['participants'] as List<dynamic>)) {
      if(eventPlayerId['role'] == 'player'){
        players.add(User(id: eventPlayerId['userId'], username: eventPlayerId['user']['username'], avatarUrl: eventPlayerId['user']['avatarUrl'] ?? ''));
      } else if(eventPlayerId['role'] == 'spectator'){
        spectators.add(User(id: eventPlayerId['userId'], username: eventPlayerId['user']['username'], avatarUrl: eventPlayerId['user']['avatarUrl'] ?? ''));
      }
    }
    debugPrint('Fetched event: ${data['title']} (ID: ${data['id']})');
    debugPrint('  Author: ${author.username} (ID: ${author.id})');
    debugPrint('  Players: ${players.map((p) => p.username).join(', ')}');
    debugPrint('  Spectators: ${spectators.map((s) => s.username).join(', ')}');
    debugPrint('  Date: ${data['startTime']}');
    debugPrint('  Max Players: ${data['maxPlayers']}');
    debugPrint('  Max Spectators: ${data['maxSpectators']}');

    return Event(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      date: DateTime.parse(data['startTime']),
      author: author,
      maxPlayers: data['maxPlayers'],
      maxSpectators: data['maxSpectators'],
      games: [data['game']],
      links: [data['discordVoiceLink'] ?? ''],
      players: players,
      spectators: spectators,
      numPlayers: data['playerCount'] ?? 0,
      numSpectators: data['spectatorCount'] ?? 0,
      groupId: data['groupId'] ?? 0,
      onlyFriends: data['onlyFriends'] ?? false,
      );
    }

    static Future<int> postEvent(Event event) async {
    final request = await createRequest('events', 'POST');
    
    // Convert date to UTC and format
    final utcDate = event.date.toUtc();
    final formattedDate = utcDate.toIso8601String();
    
    // Build the body with required fields
    final Map<String, dynamic> bodyMap = {
      'title': event.title,
      'game': event.games != null && event.games!.isNotEmpty ? event.games![0] : '',
      'startTime': formattedDate,
      'groupId': event.groupId,
      'onlyFriends': event.onlyFriends,
    };
    
    // Add optional fields only if they have valid values
    if (event.description != null && event.description!.isNotEmpty) {
      bodyMap['description'] = event.description;
    }
    
    // Only include discordVoiceLink if it looks like a valid URL
    if (event.links != null && event.links!.isNotEmpty && event.links![0].isNotEmpty) {
      final link = event.links![0];
      if (link.startsWith('http://') || link.startsWith('https://')) {
        bodyMap['discordVoiceLink'] = link;
      }
    }
    
    if (event.maxPlayers != null) {
      bodyMap['maxPlayers'] = event.maxPlayers;
    }
    
    if (event.maxSpectators != null) {
      bodyMap['maxSpectators'] = event.maxSpectators;
    }
    
    final body = jsonEncode(bodyMap);
    
    // Log the request details
    print('=== POST Event Request ===');
    print('URL: ${webInterfaceUrl}events');
    print('Original date: ${event.date} (isUtc: ${event.date.isUtc})');
    print('UTC date: $utcDate (isUtc: ${utcDate.isUtc})');
    print('Formatted: $formattedDate');
    print('Body JSON: $body');
    print('\nBody Map Contents:');
    bodyMap.forEach((key, value) {
      print('  $key: $value (${value.runtimeType})');
    });
    print('========================');
    
    HttpClientResponse response = await sendRequest(request, body);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    return data['id'];
    }

    static Future<void> patchEvent(Event event) async {
    final request = await createRequest('events/${event.id}', 'PATCH');

    final Map<String, dynamic> body = {
      'title': event.title,
      'description': event.description,
      'startTime': event.date.toUtc().toIso8601String(),
      'maxPlayers': event.maxPlayers,
      'maxSpectators': event.maxSpectators,
      'game': event.games!.isNotEmpty ? event.games![0] : '',
      'groupId': event.groupId,
      'onlyFriends': event.onlyFriends,
      };

      final link = event.links![0];
      if (link.startsWith('http://') || link.startsWith('https://')) {
        body['discordVoiceLink'] = link;
      }
      debugPrint("=== PATCH Event Request ===");
      final bodyJson = jsonEncode(body);
    await sendRequest(request, bodyJson);
    }

  static Future<void> deleteEvent(int id) async {
    debugPrint('=== DELETE Event Request ===');
    debugPrint('Deleting event with ID: $id');
    debugPrint('URL: ${webInterfaceUrl}events/$id');
    debugPrint('Token present: ${token != null}');
    debugPrint('Token value: ${token != null ? token!.substring(0, 20) + "..." : "null"}');
    final request = await createRequest('events/$id', 'DELETE');
    debugPrint('Request headers: ${request.headers}');
    try {
      final response = await sendRequest(request);
      debugPrint('Delete response status: ${response.statusCode}');
      debugPrint('========================');
    } catch (e) {
      debugPrint('Delete failed with error: $e');
      debugPrint('========================');
      rethrow;
    }
  }

  static Future<void> joinEvent(int eventId, String role) async {
    final request = await createRequest('events/$eventId/join', 'POST');
    final body = jsonEncode({
      'role': role,
    });
    final response = await sendRequest(request, body);
    debugPrint('Join event response status: ${response.statusCode}');
  }

  static Future<void> leaveEvent(int eventId) async {
    final request = await createRequest('events/$eventId/leave', 'POST');
    final body = jsonEncode({});
    await sendRequest(request, body);
  }

  //Friends

  static Future<List<User>> fetchFriends() async {
    final request = await createRequest('friends', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<User> friends = [];
    for (var friendData in data['data']) {
      debugPrint('Processing friend request: ${friendData['username'] ?? 'Unknown'} (ID: ${friendData['id']})');
      debugPrint('  Avatar URL: ${friendData['avatarUrl'] ?? ''}');
      friends.add(User(id: friendData['id'], username: friendData['username'] ?? 'Unknown', avatarUrl: friendData['avatarUrl'] ?? ''));
    }
    return friends;
  }

  static Future<List<FriendRequest>> fetchFriendRequests() async {
    final request = await createRequest('friends/requests', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as List<dynamic>;
    List<FriendRequest> friendRequests = [];
    for (var requestData in data) {
      debugPrint('Processing friend request: ${requestData['username'] ?? 'Unknown'} (ID: ${requestData['requesterId']})');
      debugPrint('  Avatar URL: ${requestData['avatarUrl'] ?? ''}');
      debugPrint('  Sent at: ${requestData['sentAt'] ?? ''}');
      friendRequests.add(FriendRequest(id: requestData['requesterId'] , username: requestData['username'] ?? 'Unknown', imageUrl: requestData['avatarUrl'] ?? '', date: DateTime.parse(requestData['sentAt'] ?? DateTime.now().toIso8601String())));
    }
    return friendRequests;
  }

  static Future<void> sendFriendRequest(int userId) async {
    final request = await createRequest('friends/request', 'POST');
    final body = jsonEncode({
      'targetUserId': userId,
    });
    await sendRequest(request, body);
  }

  static Future<void> acceptFriendRequest(int userId) async {
    final request = await createRequest('friends/accept', 'POST');
    final body = jsonEncode({
      'requesterId': userId,
    });
    final response = await sendRequest(request, body);
    debugPrint('Accept friend request response status: ${response.statusCode}');
  }

  static Future<void> deleteFriend(int userId) async {
    final request = await createRequest('friends/${userId}', 'DELETE');
    await sendRequest(request);
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
    List<User> groupFriends = await fetchGroupFriends(data['id']);
    return Group(id: data['id'], name: data['name'], friends: groupFriends);
  }

  static Future<void> patchGroup(Group group) async {
    final request = await createRequest('groups/${group.id}', 'PATCH');
    final body = jsonEncode({
      'name': group.name,
    });
    await sendRequest(request, body);
  }

  static Future<void> deleteGroup(int id) async {
    final request = await createRequest('groups/$id', 'DELETE');
    await sendRequest(request);
  }

  static Future<void> addFriendToGroup(int groupId, int friendId) async {
    final request = await createRequest('groups/$groupId/members', 'POST');
    final body = jsonEncode({
      'userId': friendId,
    });
    debugPrint('Add friend to group request body: $body');
    final response = await sendRequest(request, body);
    debugPrint('Add friend to group response status: ${response.statusCode}');
  }

  static Future<List<User>> fetchGroupFriends(int groupId) async {
    final request = await createRequest('groups/$groupId/members', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    List<User> groupFriends = [];
    for (var friendData in data['data'] ?? []) {
      debugPrint('  Friend: ${friendData['username']} (ID: ${friendData['id']})');
      groupFriends.add(User(id: friendData['id'], username: friendData['username'] ?? '', avatarUrl: friendData['avatarUrl'] ?? ''));
    }
    return groupFriends;
  }

  static Future<void> removeFriendFromGroup(int groupId, int friendId) async {
    final request = await createRequest('groups/$groupId/members/$friendId', 'DELETE');
    await sendRequest(request);
  }

  static Future<void> leaveGroup(int groupId) async {
    final request = await createRequest('groups/$groupId/leave', 'POST');
    await sendRequest(request);
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

  static Future<void> saveUserBanner(Map<String, dynamic> gradientJson) async {
    final request = await createRequest('users/me', 'PATCH');
    final body = jsonEncode({
      'bannerGradient': gradientJson,
    });
    debugPrint('Save user banner request body: $body');
    final response = await sendRequest(request, body);
    debugPrint('Save user banner response status: ${response.statusCode}');
    debugPrint('Saved banner gradient');
    debugPrint('  Type: ${gradientJson['type']}');
    debugPrint('  Colors: ${gradientJson['colors']}');
    debugPrint('  Parameter: ${gradientJson['parameter']}');
  }

  static Future<LoginResponse> loginWithProvider(String idToken, String provider) async {
    final request = await createRequest('auth/login', 'POST');
    final body = jsonEncode({
      'provider': provider,
      'token': idToken,
    });
    HttpClientResponse response = await sendRequest(request, body);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    token = data['token'];
    return LoginResponse.fromJson(data);
  }

  static Future<User> fetchMe() async {
    final request = await createRequest('me', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody);
    return User(id: data['id'], username: data['username'], avatarUrl: data['avatarUrl'], email: data['email'], bannerGradient: data['bannerGradient'] as Map<String, dynamic>? ?? {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': 0.0});
  }

  static Future<void> deleteFriendRequest(int id) async {
    final request = await createRequest('friends/requests/$id', 'DELETE');
    await sendRequest(request);
  }

  static Future<List<User>> searchUsers(String query) async {
    final request = await createRequest('users/search?q=${Uri.encodeComponent(query)}', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as List;
    List<User> users = [];
    for (var userData in data) {
      users.add(User(
        id: userData['id'],
        username: userData['username'],
        avatarUrl: userData['avatarUrl'] ?? '',
        ));
    }
    return users;
  }

  static Future<List<FriendRequest>> fetchMyFriendRequests() async {
    final request = await createRequest('friends/sent', 'GET');
    HttpClientResponse response = await sendRequest(request);
    final responseBody = await response.transform(utf8.decoder).join();
    final data = jsonDecode(responseBody) as List<dynamic>;
    List<FriendRequest> friendRequests = [];
    for (var requestData in data) {
      debugPrint('Processing friend request: ${requestData['username'] ?? 'Unknown'} (ID: ${requestData['requesterId']})');
      debugPrint('  Avatar URL: ${requestData['avatarUrl'] ?? ''}');
      debugPrint('  Sent at: ${requestData['sentAt'] ?? ''}');
      friendRequests.add(FriendRequest(id: requestData['requesterId'] , username: requestData['username'] ?? 'Unknown', imageUrl: requestData['avatarUrl'] ?? '', date: DateTime.parse(requestData['sentAt'] ?? DateTime.now().toIso8601String())));
    }
    return friendRequests;
  }

}
