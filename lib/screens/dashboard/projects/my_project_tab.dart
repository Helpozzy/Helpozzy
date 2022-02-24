import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'project_list.dart';

class MyProjectTab extends StatefulWidget {
  MyProjectTab({required this.projectsBloc});
  final ProjectsBloc projectsBloc;
  @override
  _MyProjectTabState createState() =>
      _MyProjectTabState(projectsBloc: projectsBloc);
}

class _MyProjectTabState extends State<MyProjectTab>
    with TickerProviderStateMixin {
  _MyProjectTabState({required this.projectsBloc});
  final ProjectsBloc projectsBloc;
  late TabController _tabController;
  late double width;
  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() => FocusScope.of(context).unfocus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return body;
  }

  Widget _tabBar() => SizedBox(
        height: 38,
        child: TabBar(
          controller: _tabController,
          indicatorColor: PRIMARY_COLOR,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2.5,
          isScrollable: false,
          tabs: [
            _tab(OWN_TAB),
            _tab(ENROLLED_TAB),
          ],
        ),
      );

  Tab _tab(String text) => Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 13,
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  Widget get body => Column(
        children: [
          _tabBar(),
          CommonDivider(),
          Expanded(
            child: GestureDetector(
              onPanDown: (_) => FocusScope.of(context).unfocus(),
              child: TabBarView(
                controller: _tabController,
                children: [
                  ProjectListScreen(
                    projectTabType: ProjectTabType.OWN_TAB,
                    projectsBloc: _projectsBloc,
                  ),
                  ProjectListScreen(
                    projectTabType: ProjectTabType.MY_ENROLLED_TAB,
                    projectsBloc: _projectsBloc,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
