import 'package:flutter/material.dart';
import 'package:nexus_app/classes/application_object.dart';
import 'visual_link.dart';
import '../constants.dart';
import 'event.dart';

class User extends ApplicationObject {
  final String id;
  final String name;
  final List<VisualLink>? games;
  final List<Event>? organizedEvents;
  final List<Event>? recentEvents;

  User({
    required this.id,
    required this.name,
    this.games,
    this.organizedEvents,
    this.recentEvents,
  });
}

class VisualizeUserScreen{

  static Widget buildFullDetails(User user) {
    return Container();
  }
}

class VisualizeUserPreview extends StatelessWidget {
  final User user;

  const VisualizeUserPreview({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.secondaryColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(  
              'assets/icons/assets/icons/Neil.png',
              width: AppConstants.iconSize/2,
              height: AppConstants.iconSize/2,
            ),
            Expanded(
              child: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
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
