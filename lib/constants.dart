import 'package:flutter/material.dart';

/// App-wide constants for colors, typography, spacing, and other values
class AppConstants {
    /// Device type detection
    /// Returns true if the device is considered a tablet (screen width >= 600 logical pixels)
    static bool isTablet(BuildContext context) {
        final width = MediaQuery.of(context).size.shortestSide;
        return width >= 600;
    }

    /// Usage example:
    /// double width = AppConstants.isTablet(context)
    ///   ? AppConstants.mainContainerWidthTablet(context)
    ///   : AppConstants.mainContainerWidth(context);
  // Responsive Component Sizes for Tablet
  /// Main container dimensions (Tablet)
  static double mainContainerWidthTablet(BuildContext context) =>
      screenWidth(context, 0.95).clamp(500.0, 1200.0);
  static double mainContainerHeightTablet(BuildContext context) =>
      screenHeight(context, 0.73).clamp(400.0, 1200.0);

  /// Calendar event list height (Tablet)
  static double eventListHeightTablet(BuildContext context) =>
      screenHeight(context, 0.18).clamp(180.0, 300.0);

  /// Event detail header height (Tablet)
  static double headerHeightTablet(BuildContext context) =>
      screenHeight(context, 0.1).clamp(100.0, 160.0);

  /// Description box dimensions (Tablet)
  static double descriptionWidthTablet(BuildContext context) =>
      mainContainerWidthTablet(context) * 0.95;
  static double descriptionHeightTablet(BuildContext context) =>
      screenHeight(context, 0.2).clamp(180.0, 300.0);

  /// Players/Spectators box dimensions (Tablet)
  static double playerBoxWidthTablet(BuildContext context) =>
      (mainContainerWidthTablet(context) * 0.95 - 40) / 2;
  static double playerBoxHeightTablet(BuildContext context) =>
      screenHeight(context, 0.30).clamp(180.0, 350.0);

  /// Section header height (Tablet)
  static double sectionHeaderHeightTablet(BuildContext context) =>
      screenHeight(context, 0.037).clamp(40.0, 60.0);

  /// Games/Links box dimensions (Tablet)
  static double infoBoxWidthTablet(BuildContext context) =>
      mainContainerWidthTablet(context) * 0.75;
  static double infoBoxHeightTablet(BuildContext context) =>
      screenHeight(context, 0.11).clamp(120.0, 180.0);

  /// Button/Badge dimensions (Tablet)
  static double joinButtonHeightTablet(BuildContext context) =>
      responsiveSize(context, 0.025).clamp(28.0, 40.0);
  static double joinButtonWidthTablet(BuildContext context) =>
      (playerBoxWidthTablet(context) > 32 ? playerBoxWidthTablet(context) - 32 : 0);

  /// Icon dimensions for visual links (Tablet)
  static double linkIconSizeTablet(BuildContext context) =>
      responsiveSize(context, 0.065).clamp(70.0, 100.0);

  /// Responsive padding and margins (Tablet)
  static double paddingSmallTablet(BuildContext context) =>
      responsiveSize(context, 0.01).clamp(8.0, 16.0);
  static double paddingMediumTablet(BuildContext context) =>
      responsiveSize(context, 0.015).clamp(16.0, 24.0);
  static double paddingLargeTablet(BuildContext context) =>
      responsiveSize(context, 0.02).clamp(24.0, 32.0);

  /// Responsive border radius (Tablet)
  static double borderRadiusSmallTablet(BuildContext context) =>
      responsiveSize(context, 0.015).clamp(16.0, 24.0);
  static double borderRadiusMediumTablet(BuildContext context) =>
      responsiveSize(context, 0.02).clamp(24.0, 32.0);
  static double borderRadiusMaxTablet = 512.0;

  /// Navbar icon sizes (Tablet)
  static double navbarIconSizeTablet(BuildContext context) =>
      responsiveSize(context, 0.05).clamp(60.0, 80.0);
  static double navbarIconSizeSelectedTablet(BuildContext context) =>
      responsiveSize(context, 0.1).clamp(120.0, 160.0);

  /// Responsive icon sizes (Tablet)
  static double iconSizeExtraSmallTablet(BuildContext context) =>
      responsiveSize(context, 0.04).clamp(40.0, 60.0);
  static double iconSizeSmallTablet(BuildContext context) =>
      responsiveSize(context, 0.05).clamp(60.0, 80.0);
  static double iconSizeMediumTablet(BuildContext context) =>
      responsiveSize(context, 0.07).clamp(80.0, 120.0);
  static double iconSizeLargeTablet(BuildContext context) =>
      responsiveSize(context, 0.09).clamp(120.0, 160.0);

  /// Responsive font sizes (Tablet)
  static double fontSizeSmallResponsiveTablet(BuildContext context) =>
      responsiveSize(context, 0.03).clamp(18.0, 22.0);
  static double fontSizeMediumResponsiveTablet(BuildContext context) =>
      responsiveSize(context, 0.032).clamp(22.0, 26.0);
  static double fontSizeLargeResponsiveTablet(BuildContext context) =>
      responsiveSize(context, 0.035).clamp(28.0, 32.0);
  static double fontSizeXLargeResponsiveTablet(BuildContext context) =>
      responsiveSize(context, 0.04).clamp(34.0, 40.0);

  // The existing methods are for phone format
  // Colors
  static const Color primaryColor = Color.fromRGBO(36, 36, 36, 0.70);
  static const Color secondaryColor = Color.fromRGBO(24, 24, 24, 1);
  static const Color successColor = Color.fromRGBO(76, 175, 80, 1);
  static const Color errorColor = Color.fromRGBO(244, 67, 54, 1);
  static const Color warningColor = Color.fromRGBO(255, 160, 7, 1);

  //description colors
  static const Color descriptionPrimaryColor = Color.fromRGBO(60, 60, 87, 1);
  static const Color descriptionSecondaryColor = Color.fromRGBO(
    53,
    53,
    82,
    0.30,
  );

  //players colors
  static const Color playersPrimaryColor = Color.fromRGBO(60, 87, 68, 1);
  static const Color playersSecondaryColor = Color.fromRGBO(53, 82, 53, 0.30);
  static const Color playersButtonColor = Color.fromRGBO(46, 121, 16, 1);
  static const Color playerUserColor = Color.fromRGBO(19, 30, 18, 1);
  static const Color playerUserTextColor = Color.fromRGBO(202, 208, 98, 1);

  //spectators colors
  static const Color spectatorsPrimaryColor = Color.fromRGBO(142, 83, 51, 1);
  static const Color spectatorsSecondaryColor = Color.fromRGBO(104, 83, 63, 0.30);
  static const Color spectatorsButtonColor = Color.fromRGBO(121, 72, 16, 1);
  static const Color spectatorUserColor = Color.fromRGBO(50, 33, 19, 1);
  static const Color spectatorUserTextColor = Color.fromRGBO(230, 140, 76, 1);

  //games colors
  static const Color gamesPrimaryColor = Color.fromRGBO(17, 107, 145, 1);
  static const Color gamesSecondaryColor = Color.fromRGBO(62, 107, 116, 0.30);

  //links colors
  static const Color linksPrimaryColor = Color.fromRGBO(145, 43, 17, 1);
  static const Color linksSecondaryColor = Color.fromRGBO(116, 62, 62, 0.30);
  //background color
  static const Color primaryBackgroundColor = Color.fromRGBO(11, 32, 63, 1);
  static const Color secondaryBackgroundColor = Color.fromRGBO(34, 11, 63, 1);
  //text colors
  static const Color textColor = Colors.white;
  static const Color semitransparentTextColor = Color.fromRGBO(
    255,
    255,
    255,
    0.30,
  );
  static const Color bodyTextColor = Color.fromRGBO(36, 36, 36, 0.58);

  //chat colors
  static const Color messageBackgroundColor = Color.fromRGBO(43, 43, 43, 1);
  static const List<Color> userChatColors = [
    // Reds
    Colors.red,
    Colors.redAccent,
    // Oranges
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    // Yellows/Ambers
    Colors.amber,
    Colors.amberAccent,
    Colors.yellow,
    // Greens
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    // Teals/Cyans
    Colors.teal,
    Colors.tealAccent,
    Colors.cyan,
    Colors.cyanAccent,
    // Blues
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    // Purples/Indigos
    Colors.indigo,
    Colors.indigoAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    // Pinks
    Colors.pink,
    Colors.pinkAccent,
  ];
  //accent colors
  static const Color accentColor1 = Color.fromRGBO(194, 148, 10, 1);
  static const Color accentColor2 = Color.fromRGBO(44, 171, 255, 1);
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
  static const Color selectionBackgroundColor1 = Color.fromRGBO(
    66,
    21,
    228,
    1,
  ); // Semi-transparent background
  static const Color selectionBackgroundColor2 = Color.fromRGBO(
    36,
    12,
    126,
    1,
  ); // Semi-transparent background
  static const LinearGradient selectionBackgroundGradient = LinearGradient(
    colors: [selectionBackgroundColor1, selectionBackgroundColor2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Calendar styles
  static const Color todayColor = Color.fromRGBO(26, 26, 26, 0.934);

  // Responsive Design Utilities
  /// Get responsive width based on screen width
  /// [context] BuildContext to get MediaQuery
  /// [percentage] Percentage of screen width (0.0 to 1.0)
  static double screenWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Get responsive height based on screen height
  /// [context] BuildContext to get MediaQuery
  /// [percentage] Percentage of screen height (0.0 to 1.0)
  static double screenHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  /// Get responsive size based on smaller dimension (for square elements)
  /// [context] BuildContext to get MediaQuery
  /// [percentage] Percentage of smaller dimension (0.0 to 1.0)
  static double responsiveSize(BuildContext context, double percentage) {
    final size = MediaQuery.of(context).size;
    return (size.width < size.height ? size.width : size.height) * percentage;
  }

  // Responsive Component Sizes
  /// Main container dimensions
  static double mainContainerWidth(BuildContext context) =>
      isTablet(context)
          ? mainContainerWidthTablet(context)
          : screenWidth(context, 0.95).clamp(300.0, 600.0);
  static double mainContainerHeight(BuildContext context) =>
      isTablet(context)
          ? mainContainerHeightTablet(context)
          : screenHeight(context, 0.82).clamp(400.0, 800.0);

  /// Calendar event list height
  static double eventListHeight(BuildContext context) =>
      isTablet(context)
          ? eventListHeightTablet(context)
          : screenHeight(context, 0.18).clamp(120.0, 150.0);

  /// Event detail header height
  static double headerHeight(BuildContext context) =>
      isTablet(context)
          ? headerHeightTablet(context)
          : screenHeight(context, 0.1).clamp(70.0, 80.0);

  /// Description box dimensions
  static double descriptionWidth(BuildContext context) =>
      isTablet(context)
          ? mainContainerWidthTablet(context) * 0.95
          : mainContainerWidth(context) * 0.95;
  static double descriptionHeight(BuildContext context) =>
      isTablet(context)
          ? descriptionHeightTablet(context)
          : screenHeight(context, 0.2).clamp(110.0, 150.0);

  /// Players/Spectators box dimensions
  static double playerBoxWidth(BuildContext context) =>
      isTablet(context)
          ? (mainContainerWidthTablet(context) * 0.95 - 40) / 2
          : (mainContainerWidth(context) * 0.95 - 20) / 2;
  static double playerBoxHeight(BuildContext context) =>
      isTablet(context)
          ? playerBoxHeightTablet(context)
          : screenHeight(context, 0.30).clamp(110.0, 200.0);

  /// Section header height
  static double sectionHeaderHeight(BuildContext context) =>
      isTablet(context)
          ? sectionHeaderHeightTablet(context)
          : screenHeight(context, 0.037).clamp(28.0, 30.0);

  /// Games/Links box dimensions
  static double infoBoxWidth(BuildContext context) =>
      isTablet(context)
          ? mainContainerWidthTablet(context) * 0.75
          : mainContainerWidth(context) * 0.75;
  static double infoBoxHeight(BuildContext context) =>
      isTablet(context)
          ? infoBoxHeightTablet(context)
          : screenHeight(context, 0.11).clamp(80.0, 90.0);

  /// Button/Badge dimensions
  static double joinButtonHeight(BuildContext context) =>
      isTablet(context)
          ? joinButtonHeightTablet(context)
          : responsiveSize(context, 0.025).clamp(18.0, 20.0);
  static double joinButtonWidth(BuildContext context) =>
      isTablet(context)
          ? (playerBoxWidthTablet(context) > 32 ? playerBoxWidthTablet(context) - 32 : 0)
          : (playerBoxWidth(context) > 16 ? playerBoxWidth(context) - 16 : 0);

  /// Icon dimensions for visual links
  static double linkIconSize(BuildContext context) =>
      isTablet(context)
          ? linkIconSizeTablet(context)
          : responsiveSize(context, 0.065).clamp(45.0, 50.0);

  /// Responsive padding and margins
  static double paddingSmall(BuildContext context) =>
      isTablet(context)
          ? paddingSmallTablet(context)
          : responsiveSize(context, 0.01).clamp(4.0, 8.0);
  static double paddingMedium(BuildContext context) =>
      isTablet(context)
          ? paddingMediumTablet(context)
          : responsiveSize(context, 0.015).clamp(8.0, 12.0);
  static double paddingLarge(BuildContext context) =>
      isTablet(context)
          ? paddingLargeTablet(context)
          : responsiveSize(context, 0.02).clamp(12.0, 16.0);

  /// Responsive border radius
  static double borderRadiusSmall(BuildContext context) =>
      isTablet(context)
          ? borderRadiusSmallTablet(context)
          : responsiveSize(context, 0.015).clamp(8.0, 12.0);
  static double borderRadiusMedium(BuildContext context) =>
      isTablet(context)
          ? borderRadiusMediumTablet(context)
          : responsiveSize(context, 0.02).clamp(12.0, 16.0);
    static double borderRadiusMax = 256.0;

  /// Navbar icon sizes
  static double navbarIconSize(BuildContext context) =>
      isTablet(context)
          ? navbarIconSizeTablet(context)
          : responsiveSize(context, 0.05).clamp(35.0, 40.0);
  static double navbarIconSizeSelected(BuildContext context) =>
      isTablet(context)
          ? navbarIconSizeSelectedTablet(context)
          : responsiveSize(context, 0.1).clamp(75.0, 80.0);

  /// Responsive icon sizes (scaling with screen size)
  static double iconSizeExtraSmall(BuildContext context) =>
      isTablet(context)
          ? iconSizeExtraSmallTablet(context)
          : responsiveSize(context, 0.04).clamp(25.0, 30.0);
  static double iconSizeSmall(BuildContext context) =>
      isTablet(context)
          ? iconSizeSmallTablet(context)
          : responsiveSize(context, 0.05).clamp(35.0, 45.0);
  static double iconSizeMedium(BuildContext context) =>
      isTablet(context)
          ? iconSizeMediumTablet(context)
          : responsiveSize(context, 0.07).clamp(50.0, 60.0);
  static double iconSizeLarge(BuildContext context) =>
      isTablet(context)
          ? iconSizeLargeTablet(context)
          : responsiveSize(context, 0.09).clamp(70.0, 80.0);

  /// Responsive font sizes (scaling with screen size)
  static double fontSizeSmallResponsive(BuildContext context) =>
      isTablet(context)
          ? fontSizeSmallResponsiveTablet(context)
          : responsiveSize(context, 0.03).clamp(11.0, 13.0);
  static double fontSizeMediumResponsive(BuildContext context) =>
      isTablet(context)
          ? fontSizeMediumResponsiveTablet(context)
          : responsiveSize(context, 0.032).clamp(13.0, 14.0);
  static double fontSizeLargeResponsive(BuildContext context) =>
      isTablet(context)
          ? fontSizeLargeResponsiveTablet(context)
          : responsiveSize(context, 0.035).clamp(16.0, 18.0);
  static double fontSizeXLargeResponsive(BuildContext context) =>
      isTablet(context)
          ? fontSizeXLargeResponsiveTablet(context)
          : responsiveSize(context, 0.04).clamp(18.0, 22.0);
}
