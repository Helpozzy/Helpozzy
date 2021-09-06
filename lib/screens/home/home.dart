import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/common_screen.dart';
import 'package:helpozzy/screens/explore/explore.dart';
import 'package:helpozzy/screens/home/bloc/bloc/home_bloc.dart';
import 'package:helpozzy/screens/rewards/rewards.dart';
import 'package:helpozzy/utils/constants.dart';

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
    CommonSampleScreen('Profile \nComing Soon!'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (ctx, state) {
      return Scaffold(
        body: Center(child: _children[state.currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Explore',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              label: 'Rewards',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'Projects',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Inbox',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
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
