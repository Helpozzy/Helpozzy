import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/screens/projects/project_list.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectsScreen extends StatefulWidget {
  ProjectsScreen({required this.fromAdmin});
  final bool fromAdmin;
  @override
  _ProjectsScreenState createState() =>
      _ProjectsScreenState(fromAdmin: fromAdmin);
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  _ProjectsScreenState({required this.fromAdmin});
  final bool fromAdmin;
  late TabController _tabController;
  late double width;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        elevation: 1,
        backButton: fromAdmin ? true : false,
        title: PROJECTS_APPBAR,
        bottom: fromAdmin ? _tabBar() : topSearchWithTab(),
        onBackPressed: () {
          if (fromAdmin) Navigator.of(context).pop();
        },
      ),
      body: body(),
    );
  }

  PreferredSize topSearchWithTab() => PreferredSize(
        preferredSize: Size(width, width / 4.5),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: CommonRoundedTextfield(
                  textAlignCenter: true,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: DARK_GRAY,
                  ),
                  fillColor: GRAY,
                  controller: _searchController,
                  hintText: SEARCH_HINT,
                  validator: (val) {}),
            ),
            _tabBar(),
          ],
        ),
      );

  TabBar _tabBar() => TabBar(
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        isScrollable: fromAdmin ? false : true,
        tabs: [
          _tab(text: PROJECT_UPCOMING_TAB),
          _tab(
            text: fromAdmin ? PROJECT_INPROGRESS_TAB : PROJECT_COMPLETED_TAB,
          ),
          _tab(
            text: fromAdmin
                ? PROJECT_COMPLETED_TAB
                : PROJECT_CONTRIBUTION_TRACKER_TAB,
          ),
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
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: TabBarView(
        controller: _tabController,
        children: [
          ProjectListScreen(
            fromAdmin: fromAdmin,
            projectTabType: ProjectTabType.PROJECT_UPCOMING_TAB,
          ),
          fromAdmin
              ? ProjectListScreen(
                  fromAdmin: fromAdmin,
                  projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB,
                )
              : ProjectListScreen(
                  fromAdmin: fromAdmin,
                  projectTabType: ProjectTabType.PROJECT_COMPLETED_TAB,
                ),
          fromAdmin
              ? ProjectListScreen(
                  fromAdmin: fromAdmin,
                  projectTabType: ProjectTabType.PROJECT_COMPLETED_TAB,
                )
              : ProjectListScreen(
                  fromAdmin: fromAdmin,
                  projectTabType:
                      ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB,
                ),
        ],
      ),
    );
  }
}
