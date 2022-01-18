import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/project_helper.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/project_counter_model.dart';
import 'package:helpozzy/screens/projects/project_and_activity_tile.dart';
import 'package:helpozzy/screens/projects/project_details.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectListScreen extends StatefulWidget {
  ProjectListScreen({required this.projectTabType});
  final ProjectTabType projectTabType;
  @override
  _ProjectListScreenState createState() =>
      _ProjectListScreenState(projectTabType: projectTabType);
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  _ProjectListScreenState({required this.projectTabType});
  final ProjectTabType projectTabType;
  late ThemeData _themeData;
  late double height;
  late double width;
  late bool isExpanded = false;

  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _projectsBloc.getProjects(projectTabType: projectTabType);
    if (projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB) {
      _projectsBloc.getOnGoingProjects(
          projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB);
    }
    if (projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB) {
      _projectsBloc.getProjectsActivityStatus();
    }
    if (projectTabType == ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB) {
      _projectsBloc.getProjectsActivityStatus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? ListDividerLabel(label: NEW_PROJECT_LABEL)
            : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                ? ListDividerLabel(label: RECENTLY_COMPLETED_LABEL)
                : projectTabType ==
                        ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                    ? ListDividerLabel(label: LATEST_CONTRIBUTION_HOURS_LABEL)
                    : SizedBox(),
        Expanded(child: projectList(_projectsBloc.getProjectsStream)),
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? ListDividerLabel(label: ONGOING_PROJECT_LABEL)
            : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                ? ListDividerLabel(label: DateTime.now().year.toString())
                : projectTabType ==
                        ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                    ? ListDividerLabel(label: DateTime.now().year.toString())
                    : SizedBox(),
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? Expanded(
                child: projectList(_projectsBloc.getOnGoingProjectsStream))
            : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                ? Expanded(child: monthlyProjectsStatus())
                : projectTabType ==
                        ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                    ? Expanded(child: monthlyProjectsStatus())
                    : SizedBox(),
      ],
    );
  }

  Widget projectList(Stream<Projects>? stream) {
    return StreamBuilder<Projects>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        final List<ProjectModel> projects = snapshot.data!.projectList;
        return projects.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = projects[index];
                  return StreamBuilder<bool>(
                    initialData: false,
                    stream: _projectsBloc.getProjectExpandStream,
                    builder: (context, snapshot) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailsInfo(project: project))),
                        child: ProjectTile(
                          projectTabType: projectTabType,
                          project: project,
                          isExpanded: snapshot.data!,
                          adminProjectsBloc: _projectsBloc,
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'No Projects Available',
                  style: _themeData.textTheme.headline6!
                      .copyWith(color: SHADOW_GRAY),
                ),
              );
      },
    );
  }

  Widget monthlyProjectsStatus() {
    return StreamBuilder<ProjectHelper>(
      stream: _projectsBloc.getMonthlyProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        final List<ProjectActivityModel> monthlyList =
            snapshot.data!.monthlyList;
        return monthlyList.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: WHITE,
                  height: 2,
                ),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: monthlyList.length,
                itemBuilder: (context, index) {
                  return ActivityTrackerListItem(
                    projectTabType: projectTabType,
                    projectActivity: monthlyList[index],
                  );
                },
              )
            : Center(
                child: Text(
                  'No Records Available',
                  style: _themeData.textTheme.headline6!
                      .copyWith(color: SHADOW_GRAY),
                ),
              );
      },
    );
  }
}
