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
      padding: EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'Profile', 'assets/icons/Neil.png', context),
          _buildNavItem(1, 'Chat', 'assets/icons/chat.png', context),
          _buildNavItem(2, 'Home', 'assets/icons/House.png', context),
          _buildNavItem(3, 'Friends', 'assets/icons/Friends.png', context),
          _buildNavItem(4, 'Expeditions', 'assets/icons/Space ship.png', context),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath, BuildContext context) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppConstants.paddingMedium(context)),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? AppConstants.selectionBackgroundGradient
                  : LinearGradient(
                      colors: [Colors.transparent, Colors.transparent],
                    ),
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall(context),
              ),
            ),
            child: Image.asset(
              iconPath,
              width: isSelected
                  ? AppConstants.navbarIconSizeSelected(context)
                  : AppConstants.navbarIconSize(context),
              height: isSelected
                  ? AppConstants.navbarIconSizeSelected(context)
                  : AppConstants.navbarIconSize(context),
            ),
          ),
          SizedBox(height: (AppConstants.paddingSmall(context) > 4 ? AppConstants.paddingSmall(context) - 4 : 0)),
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


