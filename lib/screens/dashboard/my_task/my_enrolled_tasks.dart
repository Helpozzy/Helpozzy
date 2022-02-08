import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/task_details.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/task_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MyEnrolledTask extends StatefulWidget {
  @override
  _MyEnrolledTaskState createState() => _MyEnrolledTaskState();
}

class _MyEnrolledTaskState extends State<MyEnrolledTask> {
  late ThemeData _theme;
  late double height;
  late double width;
  late bool myTaskExpanded = false;
  late bool allTasksExpanded = false;
  final TaskBloc _taskBloc = TaskBloc();

  @override
  void initState() {
    _taskBloc.getEnrolledTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: MY_TAKS_APPBAR),
      body: tasks(),
    );
  }

  Widget tasks() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: StreamBuilder<Tasks>(
        stream: _taskBloc.getEnrolledTasksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: LinearLoader());
          }
          return snapshot.data!.tasks.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
                  itemCount: snapshot.data!.tasks.length,
                  itemBuilder: (context, index) {
                    final TaskModel task = snapshot.data!.tasks[index];
                    return Row(
                      children: [
                        CommonBadge(
                          color: task.status == TOGGLE_NOT_STARTED
                              ? LIGHT_GRAY
                              : task.status == TOGGLE_INPROGRESS
                                  ? AMBER_COLOR
                                  : ACCENT_GREEN,
                          size: 15,
                        ),
                        Expanded(
                          child: TaskCard(
                            task: task,
                            optionEnable: false,
                            eventButton: task.status == TOGGLE_NOT_STARTED
                                ? processButton(false, task)
                                : task.status == TOGGLE_INPROGRESS
                                    ? processButton(true, task)
                                    : Center(
                                        child: SmallCommonButton(
                                          text: LOG_HOURS_BUTTON,
                                          buttonColor: BUTTON_GRAY_COLOR,
                                          fontSize: 12,
                                          onPressed: () {},
                                        ),
                                      ),
                            onTapItem: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetails(taskId: task.id),
                                ),
                              );
                              await _taskBloc.getEnrolledTasks();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    TASK_NOT_AVAILABLE,
                    style: _theme.textTheme.headline6!.copyWith(color: GRAY),
                  ),
                );
        },
      ),
    );
  }

  Widget processButton(bool taskIsInProgress, TaskModel task) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TASK_ARE_YOU_RUNNING_LATE,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 8,
            color: BLUE_COLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
        taskIsInProgress
            ? SmallCommonButton(
                fontSize: 12,
                text: COMPLETED_BUTTON,
                buttonColor: DARK_PINK_COLOR,
                onPressed: () async {
                  final TaskModel taskModel = TaskModel(
                    projectId: task.projectId,
                    ownerId: task.ownerId,
                    id: task.id,
                    taskName: task.taskName,
                    description: task.description,
                    memberRequirement: task.memberRequirement,
                    ageRestriction: task.ageRestriction,
                    qualification: task.qualification,
                    startDate: task.startDate,
                    endDate: task.endDate,
                    estimatedHrs: task.estimatedHrs,
                    totalVolunteerHrs: task.totalVolunteerHrs,
                    members: task.members,
                    status: TOGGLE_COMPLETE,
                  );
                  final bool response = await _taskBloc.updateTasks(taskModel);
                  if (response) {
                    _taskBloc.getEnrolledTasks();
                    ScaffoldSnakBar()
                        .show(context, msg: TASK_COMPLETED_POPUP_MSG);
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
                        projectId: task.projectId,
                        ownerId: task.ownerId,
                        id: task.id,
                        taskName: task.taskName,
                        description: task.description,
                        memberRequirement: task.memberRequirement,
                        ageRestriction: task.ageRestriction,
                        qualification: task.qualification,
                        startDate: task.startDate,
                        endDate: task.endDate,
                        estimatedHrs: task.estimatedHrs,
                        totalVolunteerHrs: task.totalVolunteerHrs,
                        members: task.members,
                        status: TOGGLE_INPROGRESS,
                      );
                      final bool response =
                          await _taskBloc.updateTasks(taskModel);
                      if (response) {
                        _taskBloc.getEnrolledTasks();
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
              ),
      ],
    );
  }
}
