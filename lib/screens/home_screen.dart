import 'package:flutter/material.dart';
import '../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: TextStyle(color: AppConstants.textColor, fontSize: 24.0),
      ),
    );
  }
}
