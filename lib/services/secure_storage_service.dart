import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving sensitive data like tokens
class SecureStorageService {
  // Storage keys
  static const String _keyNexusAccessToken = 'nexus_access_token';
  static const String _keyDiscordAccessToken = 'discord_access_token';
  static const String _keyGoogleIdToken = 'google_id_token';
  static const String _keyGoogleAccessToken = 'google_access_token';

  // Singleton instance
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // Storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  // ==================== Nexus Token ====================

  /// Save the Nexus access token
  Future<void> saveNexusToken(String token) async {
    await _storage.write(key: _keyNexusAccessToken, value: token);
  }

  /// Retrieve the Nexus access token
  Future<String?> getNexusToken() async {
    return await _storage.read(key: _keyNexusAccessToken);
  }

  /// Delete the Nexus access token
  Future<void> deleteNexusToken() async {
    await _storage.delete(key: _keyNexusAccessToken);
  }

  // ==================== Discord Tokens ====================

  /// Save the Discord access token
  Future<void> saveDiscordToken(String token) async {
    await _storage.write(key: _keyDiscordAccessToken, value: token);
  }

  /// Retrieve the Discord access token
  Future<String?> getDiscordToken() async {
    return await _storage.read(key: _keyDiscordAccessToken);
  }

  /// Delete the Discord access token
  Future<void> deleteDiscordToken() async {
    await _storage.delete(key: _keyDiscordAccessToken);
  }

  // ==================== Google Tokens ====================

  /// Save the Google ID token
  Future<void> saveGoogleIdToken(String token) async {
    await _storage.write(key: _keyGoogleIdToken, value: token);
  }

  /// Retrieve the Google ID token
  Future<String?> getGoogleIdToken() async {
    return await _storage.read(key: _keyGoogleIdToken);
  }

   /// Delete the Google ID token

  Future<void> deleteGoogleIdToken() async {
    await _storage.delete(key: _keyGoogleIdToken);
  }

  /// Save the Google access token
  Future<void> saveGoogleAccessToken(String token) async {
    await _storage.write(key: _keyGoogleAccessToken, value: token);
  }

  /// Retrieve the Google access token
  Future<String?> getGoogleAccessToken() async {
    return await _storage.read(key: _keyGoogleAccessToken);

  }

  /// Delete the Google access token
  Future<void> deleteGoogleAccessToken() async {
    await _storage.delete(key: _keyGoogleAccessToken);
  }

  // ==================== Utility Methods ====================

  /// Delete all stored tokens
  Future<void> deleteAllTokens() async {
    await Future.wait([
      deleteNexusToken(),
      deleteDiscordToken(),
      deleteGoogleIdToken(),
      deleteGoogleAccessToken(),
    ]);
  }

  /// Check if user has a valid Nexus token stored
  Future<bool> hasNexusToken() async {
    String? token = await getNexusToken();
    return token != null && token.isNotEmpty;
  }
}
