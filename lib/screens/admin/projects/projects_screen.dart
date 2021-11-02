import 'package:flutter/material.dart';
import 'package:helpozzy/screens/admin/projects/tabs/project_list.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context).show(
          elevation: 1,
          title: PROJECTS_APPBAR,
          bottom: _tabBar(),
          onBackPressed: () {
            Navigator.of(context).pop();
          }),
      body: body(),
    );
  }

  TabBar _tabBar() => TabBar(
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        tabs: [
          _tab(text: PROJECT_UPCOMING_TAB),
          _tab(text: PROJECT_INPROGRESS_TAB),
          _tab(text: PROJECT_PAST_TAB),
        ],
      );

  Tab _tab({required String text}) => Tab(
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

  Widget body() {
    return TabBarView(
      controller: _tabController,
      children: [
        ProjectListScreen(
          projectTabType: ProjectTabType.PROJECT_UPCOMING_TAB,
        ),
        ProjectListScreen(
          projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB,
        ),
        ProjectListScreen(
          projectTabType: ProjectTabType.PROJECT_PAST_TAB,
        ),
      ],
    );
  }
}
