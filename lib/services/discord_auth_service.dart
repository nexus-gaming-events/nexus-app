import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiscordAuthService {
  // Replace these with your actual Discord OAuth credentials
  static const String clientId = 'YOUR_DISCORD_CLIENT_ID';
  static const String clientSecret = 'YOUR_DISCORD_CLIENT_SECRET';
  // Discord requires an HTTPS redirect. Use an App/Universal Link you own.
  static const String redirectUrl = 'https://your-domain.com/oauth/discord';
  
  static const String discordAuthUrl = 'https://discord.com/api/oauth2/authorize';
  static const String discordTokenUrl = 'https://discord.com/api/oauth2/token';
  static const String discordUserUrl = 'https://discord.com/api/users/@me';

  static final FlutterAppAuth _appAuth = FlutterAppAuth();

  /// Initiate Discord OAuth login flow using flutter_app_auth
  static Future<Map<String, dynamic>> loginWithDiscord() async {
    try {
      final authResult = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          clientSecret: clientSecret,
          scopes: const ['identify', 'email', 'guilds'],
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: discordAuthUrl,
            tokenEndpoint: discordTokenUrl,
          ),
          // Set to false if you prefer reusing browser session
          //preferEphemeralSession: true,
        ),
      );

      final accessToken = authResult.accessToken;
      final refreshToken = authResult.refreshToken;

      // Fetch user info
      final userResponse = await http.get(
        Uri.parse(discordUserUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (userResponse.statusCode != 200) {
        throw Exception('Failed to fetch user data: ${userResponse.body}');
      }

      final userData = jsonDecode(userResponse.body);

      return {
        'success': true,
        'user': {
          'id': userData['id'],
          'username': userData['username'],
          'discriminator': userData['discriminator'],
          'email': userData['email'],
          'avatar': userData['avatar'],
          'avatarUrl': userData['avatar'] != null
              ? 'https://cdn.discordapp.com/avatars/${userData['id']}/${userData['avatar']}.png'
              : null,
        },
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      debugPrint('Discord login error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Refresh the access token using refresh token
  static Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(discordTokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'accessToken': data['access_token'],
          'refreshToken': data['refresh_token'],
        };
      } else {
        throw Exception('Token refresh failed: ${response.body}');
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
