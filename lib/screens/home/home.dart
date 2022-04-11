import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/dashboard/dashboard_menu.dart';
import 'package:helpozzy/screens/explore/explore.dart';
import 'package:helpozzy/screens/notification/notification_inbox.dart';
import 'package:helpozzy/screens/profile/profile_screen.dart';
import 'package:helpozzy/screens/sign_out_prompt/sign_out_prompt.dart';
import 'package:helpozzy/utils/constants.dart';
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
  final List<Widget> _children = [
    DashboardScreen(),
    ExploreScreen(),
    // RewardsScreen(initialIndex: 1, fromBottomBar: true),
    // ChatListScreen(),
    NotificationInbox(),
    ProfileScreen(),
    FullScreenSignOutPrompt(),
  ];

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
                label: INBOX_TAB,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person, size: 16),
                activeIcon: Icon(CupertinoIcons.person_solid, size: 20),
                label: PROFILE_TAB,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout_rounded, size: 16),
                activeIcon: Icon(Icons.logout_rounded, size: 20),
                label: LOGOUT_TAB,
                backgroundColor: Colors.white,
              ),
            ],
            onTap: (position) =>
                ctx.read<HomeBloc>().add(HomeUpdateTab(tabIndex: position)),
            currentIndex: state.currentIndex,
            selectedItemColor: DARK_MARUN,
            unselectedItemColor: PRIMARY_COLOR,
          ),
        );
      },
    );
  }
}
