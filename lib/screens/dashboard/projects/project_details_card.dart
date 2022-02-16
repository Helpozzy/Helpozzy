import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/project_counter_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

class ProjectTile extends StatefulWidget {
  ProjectTile({
    required this.project,
    required this.projectTabType,
    required this.isExpanded,
    required this.projectsBloc,
  });
  final ProjectTabType projectTabType;
  final ProjectModel project;
  final bool isExpanded;
  final ProjectsBloc projectsBloc;
  @override
  _ProjectTileState createState() => _ProjectTileState(
      project: project,
      projectTabType: projectTabType,
      isExpanded: isExpanded,
      projectsBloc: projectsBloc);
}

class _ProjectTileState extends State<ProjectTile> {
  _ProjectTileState({
    required this.project,
    required this.projectTabType,
    required this.isExpanded,
    required this.projectsBloc,
  });
  final ProjectTabType projectTabType;
  final ProjectModel project;
  final bool isExpanded;
  final ProjectsBloc projectsBloc;
  late ThemeData _theme;
  late double width;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return slidableInfoTile();
  }

  Widget slidableInfoTile() {
    return Slidable(
      key: const ValueKey(0),
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {},
            backgroundColor: RED_COLOR,
            foregroundColor: Colors.white,
            label: DELETE_BUTTON,
          ),
        ],
      ),
      child: shortInfoTile(),
    );
  }

  Widget shortInfoTile() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        project.projectName,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 13,
                          color: DARK_PINK_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 3),
                      project.projectOwner ==
                              prefsObject.getString(CURRENT_USER_ID)
                          ? CommonBadge(color: PINK_COLOR, size: 8)
                          : SizedBox(),
                    ],
                  ),
                  project.status == PROJECT_COMPLETED &&
                          projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                      ? Text(
                          PROJECT_COMPLETED,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            color: ACCENT_GREEN,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : SizedBox()
                ],
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        project.organization,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: DARK_PINK_COLOR,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                            timeStamp: project.startDate),
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: BLUE_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SmallCommonButtonWithIcon(
                    height: 20,
                    width: 135,
                    onPressed: () {
                      project.isProjectDetailsExpanded =
                          !project.isProjectDetailsExpanded;
                      projectsBloc.isExpanded(isExpanded);
                      if (project.isProjectDetailsExpanded &&
                          project.isTaskDetailsExpanded) {
                        _projectTaskBloc
                            .getProjectTaskDetails(project.projectId);
                      }
                    },
                    icon: project.isProjectDetailsExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    fontSize: 10,
                    iconSize: 15,
                    text: project.isProjectDetailsExpanded
                        ? HIDE_DETAILS_BUTTON
                        : SHOW_DETAILS_BUTTON,
                    buttonColor: GRAY,
                    iconColor: PRIMARY_COLOR,
                    fontColor: PRIMARY_COLOR,
                  ),
                ],
              ),
              project.isProjectDetailsExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(right: 21.0, top: 6),
                      child: CommonDivider(),
                    )
                  : SizedBox(),
              project.isProjectDetailsExpanded
                  ? projectDetails(project)
                  : SizedBox(),
              project.isTaskDetailsExpanded && project.isProjectDetailsExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(right: 21.0, top: 10),
                      child: CommonDivider(),
                    )
                  : SizedBox(),
              project.isProjectDetailsExpanded
                  ? project.isTaskDetailsExpanded
                      ? taskDetails()
                      : SizedBox()
                  : SizedBox()
            ],
          ),
        ),
        CommonDivider(),
      ],
    );
  }

  Widget projectDetails(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          projectExpandDetails(
            title: LOCATION,
            detail: project.location,
            hasIcon: true,
            icon: Icons.directions,
            iconOnPressed: () {
              CommonUrlLauncher().launchMap(project.location);
            },
          ),
          projectExpandDetails(
            title: CONTACT,
            detail: project.contactName + '\n' + project.contactNumber,
            hasIcon: true,
            icon: Icons.call_rounded,
            iconOnPressed: () {
              CommonUrlLauncher().launchCall(project.contactNumber);
            },
          ),
          projectExpandDetails(
            title: ENROLLMENT_STATUS,
            detail: project.enrollmentCount.toString() + MEMBERS_SIGNED_UP,
            hasIcon: false,
          ),
          SizedBox(height: 3),
          SmallCommonButtonWithIcon(
            height: 20,
            width: 135,
            onPressed: () {
              setState(() => project.isTaskDetailsExpanded =
                  !project.isTaskDetailsExpanded);
              if (project.isTaskDetailsExpanded) {
                _projectTaskBloc.getProjectTaskDetails(project.projectId);
              }
            },
            icon: project.isTaskDetailsExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            fontSize: 10,
            iconSize: 15,
            text: project.isTaskDetailsExpanded
                ? HIDE_TASK_DETAILS_BUTTON
                : SHOW_TASK_DETAILS_BUTTON,
            buttonColor: GRAY,
            iconColor: PRIMARY_COLOR,
            fontColor: PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }

  Widget projectExpandDetails(
      {required String title,
      required String detail,
      required bool hasIcon,
      IconData? icon,
      Function()? iconOnPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.w500, color: PRIMARY_COLOR),
            ),
          ),
          Text(
            ': ',
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w500, color: PRIMARY_COLOR),
          ),
          Expanded(
            child: Text(
              detail,
              style: _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
            ),
          ),
          hasIcon
              ? IconButton(
                  icon: Icon(icon, color: DARK_GRAY_FONT_COLOR),
                  onPressed: iconOnPressed,
                )
              : SizedBox(width: width * 0.12),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  Widget taskDetails() {
    return StreamBuilder<TaskHelper>(
      stream: _projectTaskBloc.getProjectTaskDetailsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearLoader(),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(top: 8.0, right: width * 0.05),
          child: Column(
            children: [
              tasksStatusTile(
                color: GREEN,
                title: COMPLETED_TASKS,
                icon: Icons.checklist_rtl_outlined,
                count: snapshot.data!.projectCompleted,
              ),
              tasksStatusTile(
                color: AMBER_COLOR,
                title: INPROGRESS_TASKS,
                icon: Icons.access_time,
                count: snapshot.data!.projectInProgress,
              ),
              tasksStatusTile(
                color: Colors.red,
                title: NOT_STARTED_TASKS,
                icon: Icons.warning_amber_rounded,
                count: snapshot.data!.projectNotStarted,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget tasksStatusTile({
    required String title,
    IconData? icon,
    Color? color,
    int? count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Text(
            count.toString(),
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

//Project Activity Tile
class ActivityTrackerListItem extends StatelessWidget {
  const ActivityTrackerListItem({
    required this.projectActivity,
    required this.projectTabType,
  });
  final ProjectActivityModel projectActivity;
  final ProjectTabType projectTabType;
  @override
  Widget build(BuildContext context) {
    final TextTheme _textTheme = Theme.of(context).textTheme;
    return Container(
      color: ACCENT_GRAY_COLOR,
      padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectActivity.month,
                  style: _textTheme.bodyText2!.copyWith(
                    color: BLACK,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                      ? '${projectActivity.projectCounter} projects'
                      : '${projectActivity.activities} activities',
                  style: _textTheme.bodyText2!.copyWith(
                    color: DARK_PINK_COLOR,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14)
        ],
      ),
    );
  }
}
