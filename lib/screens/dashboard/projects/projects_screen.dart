import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

import 'create_edit_project.dart';
import 'my_project_tab.dart';
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
  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
    _tabController.addListener(() => FocusScope.of(context).unfocus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        elevation: 0.4,
        backButton: true,
        title: PROJECTS_APPBAR,
        bottom: topSearchWithTab(),
      ),
      body: body,
    );
  }

  PreferredSize topSearchWithTab() => PreferredSize(
        preferredSize: Size(width, width / 5),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: CommonRoundedTextfield(
                        textAlignCenter: true,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: DARK_GRAY,
                          size: 18,
                        ),
                        fillColor: GRAY,
                        controller: _searchController,
                        hintText: SEARCH_PROJECT_HINT,
                        onChanged: (val) => _projectsBloc.searchProject(val),
                        validator: (val) => null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SmallCommonButtonWithIcon(
                    text: ADD_PROJECT_BUTTON,
                    icon: Icons.add,
                    fontSize: 13,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateOrEditProject(fromEdit: false),
                        ),
                      );
                      await _projectsBloc.getProjects(
                        projectTabType: _tabController.index == 0
                            ? ProjectTabType.MY_PROJECTS_TAB
                            : _tabController.index == 1
                                ? ProjectTabType.PROJECT_UPCOMING_TAB
                                : _tabController.index == 2
                                    ? ProjectTabType.PROJECT_INPROGRESS_TAB
                                    : _tabController.index == 3
                                        ? ProjectTabType.PROJECT_COMPLETED_TAB
                                        : null,
                      );
                    },
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
        indicatorWeight: 2.5,
        isScrollable: true,
        tabs: [
          _tab(MY_PROJECTS_TAB),
          _tab(PROJECT_UPCOMING_TAB),
          _tab(PROJECT_INPROGRESS_TAB),
          _tab(PROJECT_COMPLETED_TAB),
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
            MyProjectTab(projectsBloc: _projectsBloc),
            ProjectListScreen(
              projectTabType: ProjectTabType.PROJECT_UPCOMING_TAB,
              projectsBloc: _projectsBloc,
            ),
            ProjectListScreen(
              projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB,
              projectsBloc: _projectsBloc,
            ),
            ProjectListScreen(
              projectTabType: ProjectTabType.PROJECT_COMPLETED_TAB,
              projectsBloc: _projectsBloc,
            ),
          ],
        ),
      );
}
