import 'package:flutter/material.dart';
import 'package:helpozzy/screens/common_screen.dart';
import 'package:helpozzy/screens/rewards/tabs/my_rewards_tab.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

import 'tabs/details_tab.dart';
import 'tabs/points_tab.dart';
import 'tabs/transfer_point_tab.dart';

class RewardsScreen extends StatefulWidget {
  RewardsScreen({required this.initialIndex});
  late final int initialIndex;
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: 5, initialIndex: widget.initialIndex, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: WHITE,
        appBar: appBar(),
        body: body(),
      ),
    );
  }

  AppBar appBar() => AppBar(
        centerTitle: true,
        backgroundColor: WHITE,
        elevation: 1.0,
        title: Text(
          REWARDS_APPBAR,
          style: appBarTextStyle(),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded, color: DARK_PINK_COLOR),
        ),
        bottom: _tabBar(),
      );

  TabBar _tabBar() => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3.0,
        tabs: [
          _tab(text: DETAILS_TAB),
          _tab(text: POINT_TAB),
          _tab(text: MY_REWARDS_TAB),
          _tab(text: REDEEM_TAB),
          _tab(text: TRANSFER_POINT_TAB),
        ],
      );

  Tab _tab({required String text}) => Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontFamily: QUICKSAND,
            color: DARK_PINK_COLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget body() {
    return TabBarView(
      controller: _tabController,
      children: [
        DetailsTabScreen(),
        PointsTabScreen(),
        MyRewardsTabScreen(),
        CommonSampleScreen('Redeem\nComing Soon!'),
        TransferPointTabScreen(),
      ],
    );
  }
}
