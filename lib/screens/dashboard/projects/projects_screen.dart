import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

import 'create_project.dart';
import 'project_list.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late double width;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        elevation: 1,
        backButton: true,
        title: PROJECTS_APPBAR,
        bottom: topSearchWithTab(),
      ),
      body: body,
    );
  }

  PreferredSize topSearchWithTab() => PreferredSize(
        preferredSize: Size(width, width / 4),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.05, right: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: CommonRoundedTextfield(
                        textAlignCenter: true,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: DARK_GRAY,
                          size: 20,
                        ),
                        fillColor: GRAY,
                        controller: _searchController,
                        hintText: SEARCH_PROJECT_HINT,
                        validator: (val) => null,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: FloatingActionButton(
                      elevation: 0,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProject(),
                        ),
                      ),
                      backgroundColor: GRAY,
                      child: Icon(
                        CupertinoIcons.add,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
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
        isScrollable: true,
        tabs: [
          _tab(PROJECT_UPCOMING_TAB),
          _tab(PROJECT_INPROGRESS_TAB),
          _tab(PROJECT_COMPLETED_TAB),
          _tab(PROJECT_CONTRIBUTION_TRACKER_TAB),
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
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: TabBarView(
          controller: _tabController,
          children: [
            ProjectListScreen(
                projectTabType: ProjectTabType.PROJECT_UPCOMING_TAB),
            ProjectListScreen(
                projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB),
            ProjectListScreen(
                projectTabType: ProjectTabType.PROJECT_COMPLETED_TAB),
            ProjectListScreen(
                projectTabType:
                    ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB),
          ],
        ),
      );
}
