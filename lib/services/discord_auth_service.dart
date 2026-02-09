import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class DiscordAuthService {
  static final FlutterAppAuth _appAuth = const FlutterAppAuth();

  // CONFIGURATION
  static const String _clientId = '1470226256405594356';
  static const String _redirectUrl = 'nexusapp://discord-callback/';

  // Discord Endpoints
  static const String _authorizationEndpoint = 'https://discord.com/api/oauth2/authorize';
  static const String _tokenEndpoint = 'https://discord.com/api/oauth2/token';

  static Future<AuthorizationTokenResponse?> loginWithDiscord() async {
    try {
      // Perform PKCE Flow (Authorize + Exchange Code)
      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: _authorizationEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          scopes: ['identify', 'email'],
        ),
      );

      if (result.accessToken != null) {
        debugPrint("Discord Access Token: ${result.accessToken}");
        return result;
      } else {
        debugPrint("OAuth failed: No token returned");
      }
    } catch (e) {
      debugPrint("Login Error: $e");
    }
    return null;
  }
}
