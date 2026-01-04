import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'event.dart';

class User extends ApplicationObject {
  final String _token;
  final int id;
  final String username;
  final String email;
  final String imageUrl;
  final List<VisualLink>? games;
  final List<Event>? organizedEvents;
  final List<Event>? recentEvents;

  User({
    required this.id,
    required this.username,
    this.games,
    this.organizedEvents,
    this.recentEvents,
    this.email = '',
    this.imageUrl = '',
  }) : _token = '';

  String setToken(String token) {
    return token;
  }

  String getToken() {
    return _token;
  }
}

class VisualizeUserScreen {
  static Widget buildFullDetails(User user) {
    return Builder(
      builder: (context) => Container(
        width: AppConstants.mainContainerWidth(context),
        height: AppConstants.mainContainerHeight(context),
        color: AppConstants.backgroundColor,
        child: Stack(children: [Column(children: [

      ],)]),
      ),
    );
  }
}

class VisualizeUserPreview extends StatelessWidget {
  final User user;

  const VisualizeUserPreview({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.secondaryColor,
      margin: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
        horizontal: AppConstants.paddingSmall(context) - 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
        child: Row(
          children: [
            user.imageUrl.isEmpty
                ? Image.asset(
                    'assets/icons/Neil.png',
                    width: AppConstants.iconSizeSmall(context),
                    height: AppConstants.iconSizeSmall(context),
                  )
                : Image.network(
                    user.imageUrl,
                    width: AppConstants.iconSizeSmall(context),
                    height: AppConstants.iconSizeSmall(context),
                  ),
            Expanded(
              child: Text(
                user.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSizeMediumResponsive(context),
                  color: AppConstants.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
