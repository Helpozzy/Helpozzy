import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/project_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/project_counter_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

import 'project_details_card.dart';
import 'project_details.dart';

class ProjectListScreen extends StatefulWidget {
  ProjectListScreen({required this.projectTabType, required this.projectsBloc});
  final ProjectTabType projectTabType;
  final ProjectsBloc projectsBloc;
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState(
      projectTabType: projectTabType, projectsBloc: projectsBloc);
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  _ProjectListScreenState(
      {required this.projectTabType, required this.projectsBloc});
  final ProjectTabType projectTabType;
  final ProjectsBloc projectsBloc;
  late ThemeData _themeData;
  late double height;
  late double width;
  late bool isExpanded = false;

  @override
  void initState() {
    projectsBloc.getProjects(projectTabType: projectTabType);
    if (projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB) {
      projectsBloc.getOnGoingProjects(
          projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB);
    }
    if (projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB) {
      projectsBloc.getProjectsActivityStatus();
    }
    if (projectTabType == ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB) {
      projectsBloc.getProjectsActivityStatus();
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
        ListDividerLabel(
            label: projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
                ? NEW_PROJECT_LABEL
                : projectTabType == ProjectTabType.PROJECT_INPROGRESS_TAB
                    ? ONGOING_PROJECT_LABEL
                    : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                        ? RECENTLY_COMPLETED_LABEL
                        : LATEST_CONTRIBUTION_HOURS_LABEL),
        Expanded(child: projectList(projectsBloc.getProjectsStream)),
        projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB ||
                projectTabType ==
                    ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
            ? ListDividerLabel(label: DateTime.now().year.toString())
            : SizedBox(),
        projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
            ? Expanded(child: monthlyProjectsStatus())
            : projectTabType == ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                ? Expanded(child: monthlyProjectsStatus())
                : SizedBox(),
      ],
    );
  }

  Widget projectList(Stream<List<ProjectModel>>? stream) {
    return StreamBuilder<List<ProjectModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        final List<ProjectModel> projects = snapshot.data!;
        return projects.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = projects[index];
                  return StreamBuilder<bool>(
                    initialData: false,
                    stream: projectsBloc.getProjectExpandStream,
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
                          projectsBloc: projectsBloc,
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  NO_RECORD_FOUND,
                  style: _themeData.textTheme.headline6!
                      .copyWith(color: SHADOW_GRAY),
                ),
              );
      },
    );
  }

  Widget monthlyProjectsStatus() {
    return StreamBuilder<ProjectHelper>(
      stream: projectsBloc.getMonthlyProjectsStream,
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
                  NO_RECORD_FOUND,
                  style: _themeData.textTheme.headline6!
                      .copyWith(color: SHADOW_GRAY),
                ),
              );
      },
    );
  }
}