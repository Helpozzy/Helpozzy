import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/screens/chat/chat_list.dart';
import 'package:helpozzy/screens/dashboard/dashboard_menu.dart';
import 'package:helpozzy/screens/explore/explore.dart';
import 'package:helpozzy/screens/notification/notification_inbox.dart';
import 'package:helpozzy/screens/profile/profile_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(homeBloc: context.read<HomeBloc>()),
      child: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ChatBloc _chatBloc = ChatBloc();
  final List<Widget> _children = [
    DashboardScreen(),
    ExploreScreen(),
    // RewardsScreen(initialIndex: 1, fromBottomBar: true),
    NotificationInbox(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    _chatBloc.getOneToOneChatHistory(prefsObject.getString(CURRENT_USER_ID)!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (ctx, state) {
        return Scaffold(
          body: _children[state.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 1,
            selectedLabelStyle:
                TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 10),
            unselectedIconTheme: IconThemeData(color: DARK_GRAY),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house, size: 16),
                activeIcon: Icon(CupertinoIcons.house_fill, size: 20),
                label: HOME_TAB,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search, size: 16),
                activeIcon: Icon(CupertinoIcons.search, size: 20),
                label: EXPLORE_TAB,
                backgroundColor: Colors.white,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CupertinoIcons.gift_alt, size: 18),
              //   activeIcon: Icon(CupertinoIcons.gift_alt_fill, size: 20),
              //   label: REWARD_TAB,
              //   backgroundColor: Colors.white,
              // ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bell, size: 16),
                activeIcon: Icon(CupertinoIcons.bell_fill, size: 20),
                label: NOTIFICATIONS_TAB,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: chatBottomBarItem(CupertinoIcons.chat_bubble_2, 18),
                activeIcon:
                    chatBottomBarItem(CupertinoIcons.chat_bubble_2_fill, 22),
                label: CHAT_TAB,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person, size: 16),
                activeIcon: Icon(CupertinoIcons.person_solid, size: 20),
                label: PROFILE_TAB,
                backgroundColor: Colors.white,
              ),
            ],
            onTap: (position) {
              _chatBloc.getOneToOneChatHistory(
                  prefsObject.getString(CURRENT_USER_ID)!);
              ctx.read<HomeBloc>().add(HomeUpdateTab(tabIndex: position));
            },
            currentIndex: state.currentIndex,
            selectedItemColor: DARK_MARUN,
            unselectedItemColor: PRIMARY_COLOR,
          ),
        );
      },
    );
  }

  Widget chatBottomBarItem(IconData icon, double size) => Stack(
        children: [
          Icon(icon, size: size),
          StreamBuilder<ChatList>(
            stream: _chatBloc.getOneToOneChatListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              final List<ChatListItem> chatHistory =
                  snapshot.data!.chats.where((e) => e.badge != 0).toList();
              return chatHistory.isNotEmpty
                  ? Positioned(right: 0, top: 0, child: Badge())
                  : SizedBox();
            },
          ),
        ],
      );
}
