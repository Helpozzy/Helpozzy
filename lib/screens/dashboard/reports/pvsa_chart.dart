import 'package:flutter/material.dart';
import 'package:helpozzy/screens/rewards/tabs/details_tab.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class PVSAChart extends StatefulWidget {
  const PVSAChart({Key? key}) : super(key: key);

  @override
  State<PVSAChart> createState() => _PVSAChartState();
}

class _PVSAChartState extends State<PVSAChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(title: PVSA_CHART),
      body: DetailsTabScreen(),
    );
  }
}
