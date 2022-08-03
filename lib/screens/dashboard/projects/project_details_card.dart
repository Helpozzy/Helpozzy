import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/project_counter_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

class ProjectTile extends StatelessWidget {
  ProjectTile({
    required this.project,
    required this.projectTabType,
    required this.isExpanded,
    required this.projectsBloc,
    required this.projectTaskBloc,
    required this.onPressedTaskDetail,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });
  final ProjectTabType projectTabType;
  final ProjectModel project;
  final bool isExpanded;
  final ProjectsBloc projectsBloc;
  final ProjectTaskBloc projectTaskBloc;
  final void Function()? onPressedTaskDetail;
  final SlidableActionCallback? onPressedEdit;
  final SlidableActionCallback? onPressedDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    return projectTabType == ProjectTabType.OWN_TAB
        ? slidableInfoTile(_theme, width)
        : simpleInfoTile(_theme, width);
  }

  Widget slidableInfoTile(ThemeData _theme, double width) {
    return Slidable(
      key: const ValueKey(0),
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 0.35,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: onPressedEdit,
            backgroundColor: DARK_GRAY,
            foregroundColor: WHITE,
            icon: CupertinoIcons.pencil_ellipsis_rectangle,
            autoClose: true,
          ),
          SlidableAction(
            flex: 1,
            onPressed: onPressedDelete,
            backgroundColor: RED_COLOR,
            foregroundColor: WHITE,
            icon: CupertinoIcons.trash,
            autoClose: true,
          ),
        ],
      ),
      child: simpleInfoTile(_theme, width),
    );
  }

  Widget simpleInfoTile(ThemeData _theme, double width) {
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
                        project.projectName!,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          color: DARK_PINK_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 3),
                      project.ownerId == prefsObject.getString(CURRENT_USER_ID)
                          ? CommonBadge(color: PINK_COLOR, size: 8)
                          : SizedBox(),
                    ],
                  ),
                  StatusWidget(label: project.status!),
                ],
              ),
              Text(
                project.organization != null && project.organization!.isNotEmpty
                    ? project.organization!
                    : project.categoryId == 0
                        ? DOT + VOLUNTEER_0
                        : project.categoryId == 1
                            ? DOT + FOOD_BANK_1
                            : project.categoryId == 2
                                ? DOT + TEACHING_2
                                : project.categoryId == 3
                                    ? DOT + HOMELESS_SHELTER_3
                                    : project.categoryId == 4
                                        ? DOT + ANIMAL_CARE_4
                                        : project.categoryId == 5
                                            ? DOT + SENIOR_CENTER_5
                                            : project.categoryId == 6
                                                ? DOT + CHILDREN_AND_YOUTH_6
                                                : DOT + OTHER_7,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 10,
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      project.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 10,
                        color: UNSELECTED_TAB_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SmallCommonButtonWithIcon(
                    onPressed: () {
                      project.isProjectDetailsExpanded =
                          !project.isProjectDetailsExpanded!;
                      projectsBloc.isExpanded(isExpanded);
                      if (project.isProjectDetailsExpanded! &&
                          project.isTaskDetailsExpanded!) {
                        projectTaskBloc
                            .getProjectTaskDetails(project.projectId!);
                      }
                    },
                    icon: project.isProjectDetailsExpanded!
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    fontSize: 10,
                    iconSize: 10,
                    text: DETAILS_BUTTON,
                    buttonColor: project.isProjectDetailsExpanded!
                        ? PRIMARY_COLOR
                        : GRAY,
                    iconColor: project.isProjectDetailsExpanded!
                        ? WHITE
                        : PRIMARY_COLOR,
                    fontColor: project.isProjectDetailsExpanded!
                        ? WHITE
                        : PRIMARY_COLOR,
                  ),
                ],
              ),
              project.isProjectDetailsExpanded!
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: CommonDivider(),
                    )
                  : SizedBox(),
              project.isProjectDetailsExpanded!
                  ? projectDetails(project, _theme, width)
                  : SizedBox(),
              project.isTaskDetailsExpanded! &&
                      project.isProjectDetailsExpanded!
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: CommonDivider(),
                    )
                  : SizedBox(),
              project.isProjectDetailsExpanded!
                  ? project.isTaskDetailsExpanded!
                      ? taskDetails(_theme, width)
                      : SizedBox()
                  : SizedBox()
            ],
          ),
        ),
        CommonDivider(),
      ],
    );
  }

  Widget projectDetails(ProjectModel project, ThemeData _theme, double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          projectExpandDetails(
            _theme,
            width,
            title: LOCATION,
            detail: project.location!,
            hasIcon: true,
            icon: Icons.directions,
            iconOnPressed: () {
              CommonUrlLauncher().launchMap(project.location!);
            },
          ),
          projectExpandDetails(
            _theme,
            width,
            title: CONTACT,
            detail: project.contactName! + '\n' + project.contactNumber!,
            hasIcon: true,
            icon: Icons.call_rounded,
            iconOnPressed: () {
              CommonUrlLauncher().launchCall(project.contactNumber!);
            },
          ),
          projectExpandDetails(
            _theme,
            width,
            title: STATUS_LABEL,
            detail: project.status!,
            hasIcon: false,
          ),
          SizedBox(height: 3),
          projectExpandDetails(
            _theme,
            width,
            title: ENROLLMENTS_LABEL,
            detail: project.enrollmentCount.toString() + MEMBERS_SIGNED_UP,
            hasIcon: false,
          ),
          SizedBox(height: 4),
          SmallCommonButtonWithIcon(
            onPressed: onPressedTaskDetail,
            icon: project.isTaskDetailsExpanded!
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            fontSize: 10,
            iconSize: 10,
            text: TASK_DETAILS_BUTTON,
            buttonColor: project.isTaskDetailsExpanded! ? PRIMARY_COLOR : GRAY,
            iconColor: project.isTaskDetailsExpanded! ? WHITE : PRIMARY_COLOR,
            fontColor: project.isTaskDetailsExpanded! ? WHITE : PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }

  Widget projectExpandDetails(ThemeData _theme, double width,
      {required String title,
      required String detail,
      required bool hasIcon,
      IconData? icon,
      Function()? iconOnPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w500,
                color: PRIMARY_COLOR,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            ': ',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w500,
              color: PRIMARY_COLOR,
              fontSize: 12,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              detail,
              style: _theme.textTheme.bodyText2!.copyWith(
                color: DARK_GRAY,
                fontSize: 12,
              ),
            ),
          ),
          hasIcon
              ? IconButton(
                  icon: Icon(icon, color: DARK_GRAY_FONT_COLOR),
                  onPressed: iconOnPressed,
                  iconSize: 20,
                )
              : SizedBox(width: width * 0.12),
          SizedBox(width: 5)
        ],
      ),
    );
  }

  Widget taskDetails(ThemeData _theme, double width) {
    return StreamBuilder<TasksStatusHelper>(
      stream: projectTaskBloc.getProjectTaskDetailsStream,
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
          padding: EdgeInsets.only(top: 8.0, right: width * 0.04),
          child: Column(
            children: [
              tasksStatusTile(
                _theme,
                color: GREEN,
                title: COMPLETED_TASKS,
                icon: Icons.checklist_rtl_outlined,
                count: snapshot.data!.projectCompleted,
              ),
              tasksStatusTile(
                _theme,
                color: AMBER_COLOR,
                title: INPROGRESS_TASKS,
                icon: Icons.access_time,
                count: snapshot.data!.projectInProgress,
              ),
              tasksStatusTile(
                _theme,
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

  Widget tasksStatusTile(
    ThemeData _theme, {
    required String title,
    IconData? icon,
    Color? color,
    int? count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
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
