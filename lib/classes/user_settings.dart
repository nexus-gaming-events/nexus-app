import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserSettings {
  String userImagePath;
  Gradient bannerGradient;

  // Dictionary for selectable images
  static final Map<String, String> availableImages = {
    'Neil': 'assets/icons/Neil.png',
  };

  // Dictionary for selectable gradients (empty for now)
  static final Map<String, Gradient> availableGradients = {};

  UserSettings({
    this.userImagePath = 'assets/icons/Neil.png',
    this.bannerGradient = const LinearGradient(
      colors: [Colors.blue, Colors.purple],
    ),
  });

  /// Convert UserSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'userImagePath': userImagePath,
      'bannerGradient': _gradientToJson(bannerGradient),
    };
  }

  /// Create UserSettings from JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userImagePath: json['userImagePath'] ?? 'assets/icons/Neil.png',
      bannerGradient: _gradientFromJson(json['bannerGradient']),
    );
  }

  /// Get the settings file path
  static Future<File> _getSettingsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_settings.json');
  }

  /// Save settings to JSON file
  Future<void> saveToJson() async {
    try {
      final file = await _getSettingsFile();
      final jsonString = jsonEncode(toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving user settings: $e');
    }
  }

  /// Load settings from JSON file
  static Future<UserSettings> loadFromJson() async {
    try {
      final file = await _getSettingsFile();
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return UserSettings.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading user settings: $e');
    }
    return UserSettings();
  }

  /// Convert Gradient to JSON (stores as LinearGradient with colors and stops)
  static Map<String, dynamic> _gradientToJson(Gradient gradient) {
    if (gradient is LinearGradient) {
      return {
        'type': 'linear',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
      };
    }
    return {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF']};
  }

  /// Convert JSON to Gradient
  static Gradient _gradientFromJson(dynamic json) {
    if (json == null) {
      return const LinearGradient(colors: [Colors.blue, Colors.purple]);
    }

    try {
      final colors = (json['colors'] as List)
          .map((c) => Color(int.parse(c, radix: 16)))
          .toList();
      return LinearGradient(colors: colors);
    } catch (e) {
      debugPrint('Error parsing gradient: $e');
      return const LinearGradient(colors: [Colors.blue, Colors.purple]);
    }
  }

  /// Set image from available dictionary
  void setImageByKey(String key) {
    if (availableImages.containsKey(key)) {
      userImagePath = availableImages[key]!;
    }
  }

  /// Set gradient from available dictionary
  void setGradientByKey(String key) {
    if (availableGradients.containsKey(key)) {
      bannerGradient = availableGradients[key]!;
    }
  }
}
