import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/task_details.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/task_widget.dart';
import 'package:helpozzy/screens/dashboard/projects/volunteer_sign_up.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TaskTab extends StatefulWidget {
  TaskTab({required this.project});
  final ProjectModel project;
  @override
  _TaskTabState createState() => _TaskTabState(project: project);
}

class _TaskTabState extends State<TaskTab> {
  _TaskTabState({required this.project});
  final ProjectModel project;
  late ThemeData _theme;
  late double height;
  late double width;
  late bool myTaskExpanded = false;
  late bool allTasksExpanded = false;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  final TaskBloc _taskBloc = TaskBloc();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(body: taskDivisions());
  }

  Widget taskDivisions() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<bool>(
            initialData: myTaskExpanded,
            stream: _projectTaskBloc.getMyTaskExpandedStream,
            builder: (context, snapshot) {
              return tasksCategoriesCard(
                prefixWidget: CommonUserProfileOrPlaceholder(
                  imgUrl: prefsObject.getString(CURRENT_USER_PROFILE_URL)!,
                  size: width / 12,
                ),
                label: MY_TASKS_LABEL,
                isMyTask: true,
                isExpanded: snapshot.data!,
              );
            },
          ),
          StreamBuilder<bool>(
            initialData: allTasksExpanded,
            stream: _projectTaskBloc.geAllTaskExpandedStream,
            builder: (context, snapshot) {
              return tasksCategoriesCard(
                prefixWidget: Icon(
                  CupertinoIcons.square_list,
                  size: width / 12,
                  color: BLUE_GRAY,
                ),
                label: VIEW_ALL_TASKS_LABEL,
                isMyTask: false,
                isExpanded: snapshot.data!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget tasksCategoriesCard({
    required Widget prefixWidget,
    required String label,
    required bool isMyTask,
    required bool isExpanded,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      child: InkWell(
        onTap: () {
          if (isMyTask) {
            setState(() => myTaskExpanded = !myTaskExpanded);
            _projectTaskBloc.myTaskIsExpanded(myTaskExpanded);
            _projectTaskBloc.getProjectEnrolledTasks(project.projectId);
          } else {
            setState(() => allTasksExpanded = !allTasksExpanded);
            _projectTaskBloc.allTaskIsExpanded(allTasksExpanded);
            _projectTaskBloc.getProjectAllTasks(project.projectId);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          prefixWidget,
                          SizedBox(width: 8),
                          Text(
                            label,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              color: DARK_PINK_COLOR,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
                  ],
                ),
                isExpanded ? tasksOfProject(isMyTask) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tasksOfProject(bool isMyTask) {
    return StreamBuilder<Tasks>(
      stream: isMyTask
          ? _projectTaskBloc.getProjectEnrolledTasksStream
          : _projectTaskBloc.getProjectTasksStream,
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
                  return Row(
                    children: [
                      isMyTask
                          ? CommonBadge(
                              color: task.status == TOGGLE_NOT_STARTED
                                  ? LIGHT_GRAY
                                  : task.status == TOGGLE_INPROGRESS
                                      ? AMBER_COLOR
                                      : ACCENT_GREEN,
                              size: 15,
                            )
                          : SizedBox(),
                      Expanded(
                        child: TaskCard(
                          task: task,
                          eventButton: isMyTask
                              ? task.status == TOGGLE_NOT_STARTED
                                  ? processButton(
                                      taskIsInProgress: false,
                                      isMyTask: isMyTask,
                                      task: task)
                                  : task.status == TOGGLE_INPROGRESS
                                      ? processButton(
                                          taskIsInProgress: true,
                                          isMyTask: isMyTask,
                                          task: task)
                                      : task.status == TOGGLE_COMPLETE
                                          ? SmallCommonButton(
                                              text: LOG_HOURS_BUTTON,
                                              buttonColor: BUTTON_GRAY_COLOR,
                                              fontSize: 12,
                                              onPressed: () {},
                                            )
                                          : SizedBox()
                              : task.taskOwnerId ==
                                      prefsObject.getString(CURRENT_USER_ID)
                                  ? SmallCommonButton(
                                      text: SIGN_UP,
                                      fontSize: 12,
                                      buttonColor: DARK_GRAY,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                VolunteerProjectTaskSignUp(
                                              fromTask: true,
                                              project: project,
                                              task: task,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(),
                          onTapItem: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetails(taskId: task.taskId!),
                              ),
                            );
                            if (isMyTask) {
                              _projectTaskBloc
                                  .getProjectEnrolledTasks(project.projectId);
                            } else {
                              _projectTaskBloc
                                  .getProjectAllTasks(project.projectId);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  NO_RECORD_FOUND,
                  style: _theme.textTheme.bodyText2!.copyWith(color: GRAY),
                ),
              );
      },
    );
  }

  Widget processButton({
    required bool taskIsInProgress,
    required bool isMyTask,
    required TaskModel task,
  }) {
    return taskIsInProgress
        ? SmallCommonButton(
            fontSize: 12,
            text: COMPLETED_BUTTON,
            buttonColor: DARK_PINK_COLOR,
            onPressed: () async {
              final TaskModel taskModel = TaskModel(
                enrollTaskId: task.enrollTaskId,
                taskId: task.taskId,
                projectId: task.projectId,
                taskOwnerId: task.taskOwnerId,
                signUpUserId: task.signUpUserId,
                taskName: task.taskName,
                description: task.description,
                memberRequirement: task.memberRequirement,
                ageRestriction: task.ageRestriction,
                qualification: task.qualification,
                startDate: task.startDate,
                endDate: task.endDate,
                estimatedHrs: task.estimatedHrs,
                totalVolunteerHrs: task.totalVolunteerHrs,
                status: TOGGLE_COMPLETE,
              );
              final ResponseModel response =
                  await _taskBloc.updateEnrollTask(taskModel);
              if (response.success!) {
                if (isMyTask) {
                  _projectTaskBloc.getProjectEnrolledTasks(project.projectId);
                } else {
                  _projectTaskBloc.getProjectAllTasks(project.projectId);
                }
                ScaffoldSnakBar().show(context, msg: TASK_COMPLETED_POPUP_MSG);
              } else {
                ScaffoldSnakBar()
                    .show(context, msg: TASK_NOT_UPDATED_POPUP_MSG);
              }
            },
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SmallCommonButton(
                fontSize: 12,
                text: START_BUTTON,
                buttonColor: GRAY,
                fontColor: DARK_GRAY,
                onPressed: () async {
                  final TaskModel taskModel = TaskModel(
                    enrollTaskId: task.enrollTaskId,
                    taskId: task.taskId,
                    projectId: task.projectId,
                    taskOwnerId: task.taskOwnerId,
                    signUpUserId: task.signUpUserId,
                    taskName: task.taskName,
                    description: task.description,
                    memberRequirement: task.memberRequirement,
                    ageRestriction: task.ageRestriction,
                    qualification: task.qualification,
                    startDate: task.startDate,
                    endDate: task.endDate,
                    estimatedHrs: task.estimatedHrs,
                    totalVolunteerHrs: task.totalVolunteerHrs,
                    status: TOGGLE_INPROGRESS,
                  );
                  final ResponseModel response =
                      await _taskBloc.updateEnrollTask(taskModel);
                  if (response.success!) {
                    if (isMyTask) {
                      _projectTaskBloc
                          .getProjectEnrolledTasks(project.projectId);
                    } else {
                      _projectTaskBloc.getProjectAllTasks(project.projectId);
                    }
                    ScaffoldSnakBar().show(
                      context,
                      msg: TASK_STARTED_POPUP_MSG,
                    );
                  } else {
                    ScaffoldSnakBar().show(
                      context,
                      msg: TASK_NOT_UPDATED_POPUP_MSG,
                    );
                  }
                },
              ),
              SizedBox(width: 7),
              SmallCommonButton(
                fontSize: 12,
                fontColor: BLACK,
                buttonColor: SILVER_GRAY,
                text: DECLINE_BUTTON,
                onPressed: () {},
              ),
            ],
          );
  }
}
