import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';
import '../classes/chat.dart';
import '../main.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Chat> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load chats
    await DataManager.ensureChatsLoaded();
    final chats = DataManager.getChats();

    if (mounted) {
    setState(() {
      _chats = chats;
      _isLoading = false;
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return BaseScreenContainer(
        child: Center(
          child: CircularProgressIndicator(
            color: AppConstants.textColor,
          ),
        ),
       );
    }
    return BaseScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderContainer(
            child: Row(
              children: [
                BackButtonWidget(),
                SizedBox(
                  width: AppConstants.mainContainerWidth(context) * 0.01,
                ),
                Expanded(
                  child: Text(
                    'Chats',
                    style: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: () {
                        final baseFontSize =
                            AppConstants.fontSizeXLargeResponsive(context) + 2;
                        final titleLength = 'Chats'.length;
                        if (titleLength <= 15) return baseFontSize;
                        if (titleLength <= 25) return baseFontSize - 2;
                        if (titleLength <= 35) return baseFontSize - 4;
                        return (baseFontSize - 6).clamp(
                          AppConstants.fontSizeMediumResponsive(context),
                          baseFontSize,
                        );
                      }(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.mainContainerHeight(context) * 0.01),
          Container(
            alignment: Alignment.topCenter,
            width: AppConstants.mainContainerWidth(context) * 0.9,
            height: AppConstants.mainContainerHeight(context) * 0.821,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.textColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _chats
                          .map(
                            (chat) => InkWell(
                              onTap: () {
                                NexusAppState.instance!.returnScreenParams.add([]);
                                NexusAppState.instance!.returnScreenPath.add('Chats');
                                NexusAppState.instance!.updateState(
                                  'Chat',
                                  params: [chat],
                                );
                              },
                              child: VisualizeChatPreview(chat: chat),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
