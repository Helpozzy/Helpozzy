import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'project_list.dart';

class MyProjectTab extends StatefulWidget {
  MyProjectTab({required this.projectsBloc, required this.tabController});
  final ProjectsBloc projectsBloc;
  final TabController tabController;
  @override
  _MyProjectTabState createState() => _MyProjectTabState(
      projectsBloc: projectsBloc, tabController: tabController);
}

class _MyProjectTabState extends State<MyProjectTab>
    with TickerProviderStateMixin {
  _MyProjectTabState({required this.projectsBloc, required this.tabController});
  final ProjectsBloc projectsBloc;
  final TabController tabController;
  late double width;

  @override
  void initState() {
    tabController.addListener(() => FocusScope.of(context).unfocus());
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
          controller: tabController,
          indicatorColor: DARK_PINK_COLOR,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2,
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
                controller: tabController,
                children: [
                  ProjectListScreen(
                    projectTabType: ProjectTabType.OWN_TAB,
                    projectsBloc: projectsBloc,
                  ),
                  ProjectListScreen(
                    projectTabType: ProjectTabType.MY_ENROLLED_TAB,
                    projectsBloc: projectsBloc,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
