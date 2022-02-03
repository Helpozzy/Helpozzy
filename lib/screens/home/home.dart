import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/dashboard/dashboard_menu.dart';
import 'package:helpozzy/screens/explore/explore.dart';
import 'package:helpozzy/screens/profile/profile_screen.dart';
import 'package:helpozzy/screens/sign_out_dialog/sign_out_dialog.dart';
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
        child: Home());
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
    ProfileScreen(),
    FullScreenSignOutDialog(),
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
                TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            unselectedIconTheme: IconThemeData(color: DARK_GRAY),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home, size: 17),
                activeIcon: Icon(CupertinoIcons.home),
                label: HOME_TAB,
                backgroundColor: Colors.white,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CupertinoIcons.gift),
              //   label: REWARD_TAB,
              //   backgroundColor: Colors.white,
              // ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search, size: 17),
                activeIcon: Icon(CupertinoIcons.search),
                label: EXPLORE_TAB,
                backgroundColor: Colors.white,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CupertinoIcons.chat_bubble),
              //   label: INBOX_TAB,
              //   backgroundColor: Colors.white,
              // ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person, size: 17),
                activeIcon: Icon(CupertinoIcons.person),
                label: PROFILE_TAB,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout_rounded, size: 17),
                activeIcon: Icon(Icons.logout_rounded),
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
