
import 'package:flutter/material.dart';
import 'package:nexus_app/classes/user.dart';
import 'package:nexus_app/constants.dart';
import 'package:nexus_app/widgets/back_button_widget.dart';
import 'package:nexus_app/widgets/base_screen_container.dart';
import 'package:nexus_app/widgets/header_container.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({Key? key}) : super(key: key);

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {

  List<User> searchResults = [];
  String searchQuery = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

  } 
  
  @override
  Widget build(BuildContext context) {
    return BaseScreenContainer(
      child: 
      Column(
        children: [
          HeaderContainer(
            child: Row(
            children: [
              BackButtonWidget(),
              Text('Search Users', style: TextStyle(
                fontSize: AppConstants.fontSizeXLargeResponsive(context), 
                color: AppConstants.textColor,
                fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ),
          SearchBar(
            leading: Icon(Icons.search, color: AppConstants.semitransparentTextColor),
            backgroundColor: MaterialStateProperty.all(Color.fromARGB(0, 0, 0, 0)),
            elevation: MaterialStateProperty.all(0),
            
            hintText: 'Search by username',
            hintStyle: MaterialStateProperty.all(TextStyle(
              color: AppConstants.semitransparentTextColor,
              fontSize: AppConstants.fontSizeMediumResponsive(context),
            )),
            textStyle: MaterialStateProperty.all(TextStyle(
              color: AppConstants.textColor,
              fontSize: AppConstants.fontSizeMediumResponsive(context),
            )),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onSubmitted: (value) {
              // Implement search logic here
            },
          ),
        ],
        )
      );
  }
}