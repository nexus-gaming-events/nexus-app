import 'package:flutter/material.dart';
import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: TextStyle(color: AppConstants.textColor, fontSize: 24.0),
      ),
    );
  }
}
