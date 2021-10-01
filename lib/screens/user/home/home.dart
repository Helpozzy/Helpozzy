import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/user/common_screen.dart';
import 'package:helpozzy/screens/user/explore/explore.dart';
import 'package:helpozzy/screens/user/profile/profile_screen.dart';
import 'package:helpozzy/screens/user/rewards/rewards.dart';
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
    ExploreScreen(),
    RewardsScreen(initialIndex: 1),
    CommonSampleScreen('Projects \nComing Soon!'),
    CommonSampleScreen('Inbox \nComing Soon!'),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (ctx, state) {
      return Scaffold(
        body: Center(child: _children[state.currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Explore',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gift),
              label: 'Rewards',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.rectangle_3_offgrid),
              label: 'Projects',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Inbox',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
              backgroundColor: Colors.white,
            ),
          ],
          onTap: (position) => ctx.read<HomeBloc>().add(
                HomeUpdateTab(tabIndex: position),
              ),
          currentIndex: state.currentIndex,
          selectedItemColor: DARK_MARUN,
          unselectedItemColor: PRIMARY_COLOR,
        ),
      );
    });
  }
}