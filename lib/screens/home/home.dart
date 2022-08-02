import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/models/notification_model.dart';
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
  final NotificationBloc _notificationBloc = NotificationBloc();

  final List<Widget> _children = [
    DashboardScreen(),
    ExploreScreen(),
    NotificationInbox(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    _notificationBloc.getNotifications();
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
              BottomNavigationBarItem(
                icon: notificationBottomBarItem(CupertinoIcons.bell, 16),
                activeIcon:
                    notificationBottomBarItem(CupertinoIcons.bell_fill, 20),
                label: NOTIFICATIONS_TAB,
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
              _notificationBloc.getNotifications();
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

  Widget notificationBottomBarItem(IconData icon, double size) => Stack(
        children: [
          Icon(icon, size: size),
          StreamBuilder<Notifications>(
            stream: _notificationBloc.getNotificationsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              final int previousNotificationLength =
                  prefsObject.getInt(NOTIFICATION_LENGTH) ?? 0;
              return snapshot.data!.notifications.length >
                      previousNotificationLength
                  ? Positioned(right: 0, top: 0, child: NotifyBadge())
                  : SizedBox();
            },
          ),
        ],
      );
}
