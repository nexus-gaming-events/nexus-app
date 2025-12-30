import 'package:flutter/material.dart';

/// App-wide constants for colors, typography, spacing, and other values
class AppConstants {
  // Colors
  static const Color primaryColor = Color.fromRGBO(36, 36, 36, 0.70);
  static const Color secondaryColor = Color.fromRGBO(24, 24, 24, 1);

  //description colors
  static const Color descriptionPrimaryColor = Color.fromRGBO(60, 60, 87, 1);
  static const Color descriptionSecondaryColor = Color.fromRGBO(53, 53, 82, 0.70);

  //players colors
  static const Color playersPrimaryColor = Color.fromRGBO(60, 87, 68, 1);
  static const Color playersSecondaryColor = Color.fromRGBO(53, 82, 53, 0.70);
  static const Color playersButtonColor = Color.fromRGBO(46, 121, 16, 1);

  //spectators colors
  static const Color spectatorsPrimaryColor = Color.fromRGBO(142, 83, 51, 1);
  static const Color spectatorsSecondaryColor = Color.fromRGBO(104, 83, 63, 0.70);
  static const Color spectatorsButtonColor = Color.fromRGBO(121, 72, 16, 1);

  //games colors
  static const Color gamesPrimaryColor = Color.fromRGBO(17, 107, 145, 1);
  static const Color gamesSecondaryColor = Color.fromRGBO(62, 107, 116, 0.70);

  //links colors
  static const Color linksPrimaryColor = Color.fromRGBO(145, 43, 17, 1);
  static const Color linksSecondaryColor = Color.fromRGBO(116, 62, 62, 0.70);

  //background color
  static const Color backgroundColor = Color.fromRGBO(11, 32, 63, 1);

  //text colors
  static const Color textColor = Colors.white;
  static const Color semitransparentTextColor = Color.fromRGBO(255, 255, 255, 0.30);
  static const Color bodyTextColor = Color.fromRGBO(36, 36, 36, 0.58);



  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;

  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Icon sizes
  static const double iconSize = 40.0;

  // Other common constants
  static const String appTitle = 'Welcome to the Nexus';
  static const String appName = 'Nexus';

  // Selection color for navbar 
  static const Color selectionBackgroundColor1 = Color.fromRGBO(66, 21, 228, 1); // Semi-transparent background
  static const Color selectionBackgroundColor2 = Color.fromRGBO(36, 12, 126, 1); // Semi-transparent background
  static const LinearGradient selectionBackgroundGradient =LinearGradient(colors: [selectionBackgroundColor1, selectionBackgroundColor2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Calendar styles
  static const LinearGradient todayGradient = LinearGradient(colors: [selectionBackgroundColor1, selectionBackgroundColor2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color selectedDayColor = Color.fromRGBO(26, 26, 26, 0.934);
  }
