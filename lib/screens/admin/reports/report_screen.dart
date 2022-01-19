import 'package:flutter/material.dart';
import 'package:helpozzy/screens/admin/reports/reports_tab/reports.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with TickerProviderStateMixin {
  late double height;
  late double width;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        title: REPORTS_APPBAR,
        elevation: 0,
        bottom: _tabBar(),
      ),
      body: body,
    );
  }

  TabBar _tabBar() => TabBar(
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        isScrollable: true,
        tabs: [
          _tab(REPORT_MONTHLY_TAB),
          _tab(REPORT_YEARLY_TAB),
        ],
      );

  Tab _tab(String text) => Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 13,
                color: DARK_PINK_COLOR,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  Widget get body => GestureDetector(
        onPanDown: (_) {
          FocusScope.of(context).unfocus();
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            ReportsDetails(),
            ReportsDetails(),
          ],
        ),
      );
}
