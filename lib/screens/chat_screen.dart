import 'package:flutter/material.dart';
import '../constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chat',
        style: TextStyle(color: AppConstants.textColor, fontSize: 24.0),
      ),
    );
  }
}
