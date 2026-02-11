import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:nexus_app/services/secure_storage_service.dart';
import 'package:nexus_app/services/web_interface_service.dart';

import '../data_manager.dart';
import '../main.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // Initialize the listener
  void init(BuildContext context) {
    debugPrint("Initializing DeepLinkService...");
    // 1. Handle app started from a cold state (Terminated)
    _checkInitialLink(context);

    // 2. Handle app resumed from background (Running)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(context, uri);
    }, onError: (err) {
      debugPrint("Deep Link Error: $err");
    });
  }

  Future<void> _checkInitialLink(BuildContext context) async {
    debugPrint("Checking for initial deep link...");
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleDeepLink(context, uri);
      }
    } catch (e) {
      debugPrint("Error getting initial link: $e");
    }
  }

  void _handleDeepLink(BuildContext context, Uri uri) async {
    debugPrint("Received Deep Link: $uri");

    // Check if this is the auth callback
    // Matches: nexusapp://discord-callback?access_token=...
    if (uri.host == 'discord-callback') {
      final discordToken = uri.queryParameters['access_token'];

      if (discordToken != null) {
        debugPrint("Extracted Discord Token: $discordToken");
        SecureStorageService().saveDiscordToken(discordToken);

        final loginResponse = await WebInterfaceService.loginWithProvider(discordToken, 'discord');
        SecureStorageService().saveNexusToken(loginResponse.token);
        await DataManager.initialize();

        final me = await WebInterfaceService.fetchMe();

        debugPrint('Logged in as: ${me.username}');
        debugPrint('Email: ${me.email}');
        debugPrint('Photo URL: ${me.avatarUrl}');
        debugPrint('Discord Access Token: $discordToken');
        debugPrint('Nexus Access Token: ${loginResponse.token}');

        // Navigate to home screen after successful login
        NexusAppState.instance!.updateState('Home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
