
import 'package:flutter/material.dart';
import 'package:nexus_app/classes/user.dart';
import 'package:nexus_app/constants.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:nexus_app/main.dart';
import 'package:nexus_app/widgets/back_button_widget.dart';
import 'package:nexus_app/widgets/base_screen_container.dart';
import 'package:nexus_app/widgets/header_container.dart';

import 'dart:async';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({Key? key}) : super(key: key);

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {

  List<User> searchResults = [];
  String searchQuery = '';
  bool isLoading = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  } 

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
          )),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.only(
              left: AppConstants.paddingMedium(context),
              right: AppConstants.paddingMedium(context),
              top: AppConstants.paddingSmall(context),
            ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppConstants.semitransparentTextColor)),),
        child: SearchBar(
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
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () async {
              setState(() {
                isLoading = true;
              });
              if (value.isEmpty) {
                setState(() {
                  searchResults = [];
                  searchQuery = '';
                  isLoading = false;
                });
                return;
              }
              if (value.length < 3) {
                setState(() {
                  searchResults = [];
                  searchQuery = value;
                  isLoading = false;
                });
                return;
              }
              List<User> results = await DataManager.searchUsers(value);
              setState(() {
                searchQuery = value;
                searchResults = results;
                isLoading = false;
              });
            });
          },
          onSubmitted: (value) {
            // Implement search logic here
          },
        ),
      ),
    ),
    isLoading
      ? CircularProgressIndicator(color: AppConstants.textColor)
      : Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: AppConstants.paddingMedium(context),
              right: AppConstants.paddingMedium(context),
            ),
            child: searchResults.isEmpty
              ? Center(
                  child: Text(
                    searchQuery.isEmpty ? 'Enter a username to search' : 'No users found',
                    style: TextStyle(
                      color: AppConstants.semitransparentTextColor,
                      fontSize: AppConstants.fontSizeMediumResponsive(context),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    User? user = searchResults[index];
                    return InkWell(
                      child: VisualizeUserPreview(user: user),
                      onTap: () async {
                        NexusAppState.instance!.returnScreenParams.add([]);
                        NexusAppState.instance!.returnScreenPath.add('SearchUser');
                        NexusAppState.instance!.updateState(
                          'UserProfile',
                          params: [await DataManager.getUserById(user.id) ?? user],
                        );
                      },
                    );
                  },
                ),
          ),
        ),
  ],
));
  }
}