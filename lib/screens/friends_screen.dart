import 'package:flutter/material.dart';
import '../constants.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Friends',
        style: TextStyle(color: AppConstants.textColor, fontSize: 24.0),
      ),
    );
  }
}
