import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/report_bloc.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/screens/dashboard/tasks/task_details.dart';
import 'package:helpozzy/screens/dashboard/tasks/task_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportProjectTile extends StatefulWidget {
  ReportProjectTile({
    required this.project,
    required this.isExpanded,
    required this.reportBloc,
  });
  final ProjectModel project;
  final bool isExpanded;
  final ReportBloc reportBloc;
  @override
  _ReportProjectTileState createState() => _ReportProjectTileState(
        project: project,
        isExpanded: isExpanded,
        reportBloc: reportBloc,
      );
}

class _ReportProjectTileState extends State<ReportProjectTile> {
  _ReportProjectTileState({
    required this.project,
    required this.isExpanded,
    required this.reportBloc,
  });
  final ProjectModel project;
  final bool isExpanded;
  final ReportBloc reportBloc;
  late ThemeData _theme;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return simpleInfoTile();
  }

  Widget simpleInfoTile() {
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
                      project.isDetailsExpanded = !project.isDetailsExpanded!;
                      reportBloc.isExpanded(isExpanded);
                      if (project.isDetailsExpanded!) {
                        reportBloc.getSignedUpProjectCompletedTasks(
                            project.projectId!);
                      }
                    },
                    icon: project.isDetailsExpanded!
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    fontSize: 10,
                    iconSize: 10,
                    text: TASK_DETAILS_BUTTON,
                    buttonColor:
                        project.isDetailsExpanded! ? PRIMARY_COLOR : GRAY,
                    iconColor:
                        project.isDetailsExpanded! ? WHITE : PRIMARY_COLOR,
                    fontColor:
                        project.isDetailsExpanded! ? WHITE : PRIMARY_COLOR,
                  ),
                ],
              ),
              project.isDetailsExpanded!
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: CommonDivider(),
                    )
                  : SizedBox(),
              project.isDetailsExpanded! ? tasksOfProject() : SizedBox(),
            ],
          ),
        ),
        CommonDivider(),
      ],
    );
  }

  Widget tasksOfProject() {
    return StreamBuilder<Tasks>(
      stream: reportBloc.getSignedUpProjectCompletedTaskStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: width * 0.04),
            child: LinearLoader(),
          );
        }
        return snapshot.data!.tasks.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data!.tasks.length,
                itemBuilder: (context, index) {
                  TaskModel task = snapshot.data!.tasks[index];
                  return TaskCard(
                    task: task,
                    onTapItem: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetails(task: task),
                        ),
                      );
                      reportBloc
                          .getSignedUpProjectCompletedTasks(project.projectId!);
                    },
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  NO_COMPLETED_TASKS_FOUND,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    color: DARK_GRAY,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
      },
    );
  }
}
