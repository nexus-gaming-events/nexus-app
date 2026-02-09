import 'package:flutter/material.dart';
import '../constants.dart';
import '../classes/user.dart';

class UserStackIcon extends StatelessWidget {
  final List<User> users;
  final double? size;

  const UserStackIcon({
    Key? key,
    required this.users,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? AppConstants.iconSizeLarge(context);

    if (users.isEmpty) {
      return Image.asset(
        'assets/icons/Friends.png',
        width: iconSize,
        height: iconSize,
        color: AppConstants.textColor,
      );
    }

    if (users.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
        child: Image.network(
          users[0].avatarUrl,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.cover,
        ),
      );
    }

    if (users.length == 2) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
                child: Image.network(
                  users[0].avatarUrl,
                  width: iconSize * 0.6,
                  height: iconSize * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
                child: Image.network(
                  users[1].avatarUrl,
                  width: iconSize * 0.6,
                  height: iconSize * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 3 or more users
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: iconSize * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
              child: Image.network(
                users[0].avatarUrl,
                width: iconSize * 0.5,
                height: iconSize * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
              child: Image.network(
                users[1].avatarUrl,
                width: iconSize * 0.5,
                height: iconSize * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
              child: Image.network(
                users[2].avatarUrl,
                width: iconSize * 0.5,
                height: iconSize * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
