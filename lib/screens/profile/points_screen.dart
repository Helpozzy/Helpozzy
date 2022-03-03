import 'package:flutter/material.dart';
import 'package:helpozzy/screens/rewards/tabs/points_tab.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(title: POINT_TAB),
      body: PointsTabScreen(),
    );
  }
}
