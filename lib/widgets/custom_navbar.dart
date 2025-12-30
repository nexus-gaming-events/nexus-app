import 'package:flutter/material.dart';
import '../constants.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'Profile', 'assets/icons/Neil.png'),
          _buildNavItem(1, 'Chat', 'assets/icons/chat.png'),
          _buildNavItem(2, 'Home', 'assets/icons/House.png'),
          _buildNavItem(3, 'Friends', 'assets/icons/Friends.png'),
          _buildNavItem(4, 'Expeditions', 'assets/icons/Space ship.png'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? AppConstants.selectionBackgroundGradient
                  : LinearGradient(
                      colors: [Colors.transparent, Colors.transparent],
                    ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Image.asset(
              iconPath,
              width: isSelected
                  ? AppConstants.iconSize + 40
                  : AppConstants.iconSize,
              height: isSelected
                  ? AppConstants.iconSize + 40
                  : AppConstants.iconSize,
            ),
          ),
          const SizedBox(height: 4.0),
          /*Text(
                label,
                style: TextStyle(
                  color: AppConstants.textColor,
                  fontSize: 12.0,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),*/
        ],
      ),
    );
  }
}
