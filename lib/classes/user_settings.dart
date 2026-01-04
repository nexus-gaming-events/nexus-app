import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserSettings {
  static String userImagePath = 'assets/icons/Neil.png';
  static Gradient bannerGradient = const LinearGradient(
    colors: [Colors.blue, Colors.purple],
  );
 static double paramter = 0.0;
  // Dictionary for selectable images
  static Map<String, String> availableImages = {
    'Neil': 'assets/pfps/Neil.png',
    'Cyclo': 'assets/pfps/Cyclo.png',
    'Extra': 'assets/pfps/Extra.png',
    'Psyino': 'assets/pfps/Psyino.png'
  };


  UserSettings({
    userImagePath = 'assets/icons/Neil.png',
    bannerGradient = const LinearGradient(
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
      
      // Update static variables from JSON
      userImagePath = json['userImagePath'] ?? 'assets/icons/Neil.png';
      bannerGradient = _gradientFromJson(json['bannerGradient']);
      paramter = json['bannerGradient']?['parameter'] ?? 0.0;
      
      return UserSettings.fromJson(json);
    } else {
      // File doesn't exist, create it with default settings
      final defaultSettings = UserSettings();
      await defaultSettings.saveToJson();
      return defaultSettings;
    }
  } catch (e) {
    debugPrint('Error loading user settings: $e');
    final defaultSettings = UserSettings();
    await defaultSettings.saveToJson();
    return defaultSettings;
  }
}

  /// Convert Gradient to JSON (stores as LinearGradient with colors and stops)
  static Map<String, dynamic> _gradientToJson(Gradient gradient) {
    if (gradient is LinearGradient) {
      return {
        'type': 'linear',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
        'parameter': paramter,
      };
    }
    if (gradient is RadialGradient) {
      return {
        'type': 'radial',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
        'parameter': paramter,
      };
    }
    if (gradient is SweepGradient) {
      return {
        'type': 'sweep',
        'colors': gradient.colors
            .map((c) => c.value.toRadixString(16))
            .toList(),
        'parameter': paramter,
      };
    }
    return {'type': 'linear', 'colors': ['0xFF0000FF', '0xFFFF00FF'], 'parameter': paramter};
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
      if (json['type'] == 'linear') {
        return LinearGradient(colors: colors.isEmpty ? [Colors.blue, Colors.purple] : colors, begin: Alignment(-1, 0.0), end: Alignment(paramter + 1, 0.0));
      }
      if (json['type'] == 'radial') {
        return RadialGradient(colors: colors.isEmpty ? [Colors.blue, Colors.purple] : colors, radius: paramter + 1);
      }
      if (json['type'] == 'sweep') {
        return SweepGradient(colors: colors.isEmpty ? [Colors.blue, Colors.purple] : colors, startAngle: 0, endAngle: (4 * (3.141592653589793 + 1) * (paramter/2.0 + 0.5)).clamp(0.000000000001, (4*3.141592653589793 + 1)));
      }
      return LinearGradient(colors: colors.isEmpty ? [Colors.blue, Colors.purple] : colors, begin: Alignment(-1, 0.0), end: Alignment(paramter + 1, 0.0));
    } catch (e) {
      debugPrint('Error parsing gradient: $e');
      return const LinearGradient(colors: [Colors.blue, Colors.purple], begin: Alignment(-1, 0.0), end: Alignment(0.5, 0.0));
    }
  }

  /// Set image from available dictionary
  void setImageByKey(String key) {
    if (availableImages.containsKey(key)) {
      userImagePath = availableImages[key]!;
    }
  }

  /// Set gradient from available dictionary
  void setGradient(Gradient gradient) {
    bannerGradient = gradient;
  }
}
