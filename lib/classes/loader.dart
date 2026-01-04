import 'user.dart';
import 'event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loader {
  static User? selfUser;
  static List<Event> events = [];
  static List<User> friends = [];

  static Future<void> authenticateGoogle(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://nexus.orciuolo.it/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          {
            "provider": "google", 
            "token": token
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        selfUser = User(
          id: data['id'],
          username: data['username'],
          email: data['email'],
          imageUrl: data['avatarUrl'] ?? '',
        );
        selfUser!.setToken(data['token']);
        // Save token, navigate to home
        
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      debugPrint('Error during authentication: $e');
    }
  }

  static Future<void> authenticateDiscord(String token) async {
    // Similar implementation as authenticateGoogle
  }
}
