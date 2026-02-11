import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DiscordAuthService {
  static final FlutterAppAuth _appAuth = const FlutterAppAuth();

  // CONFIGURATION
  static const String _clientId = '1470226256405594356';
  static const String _redirectUrl = 'https://nexus.orciuolo.it/auth/discord/callback';

  static Future<void> loginWithDiscord() async {
    final authUrl = Uri.https('discord.com', '/api/oauth2/authorize', {
      'client_id': _clientId,
      'redirect_uri': _redirectUrl,
      'response_type': 'code',
      'scope': 'identify email',
    });

    if (!await launchUrl(
      authUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $authUrl');
    }
  }
}
