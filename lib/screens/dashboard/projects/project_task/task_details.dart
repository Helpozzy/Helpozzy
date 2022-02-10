import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TaskDetails extends StatefulWidget {
  TaskDetails({required this.taskId});
  final String taskId;
  @override
  _TaskDetailsState createState() => _TaskDetailsState(taskId: taskId);
}

class _TaskDetailsState extends State<TaskDetails> {
  _TaskDetailsState({required this.taskId});
  final String taskId;
  late ThemeData _theme;
  late double width;

  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  final TaskBloc _taskBloc = TaskBloc();

  @override
  void initState() {
    _taskBloc.getTask(taskId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: TASK_DETAILS_APPBAR),
      body: SafeArea(
        child: StreamBuilder<TaskModel>(
          stream: _taskBloc.getTaskInfoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: LinearLoader());
            }
            final TaskModel task = snapshot.data!;
            return body(task);
          },
        ),
      ),
    );
  }

  Widget body(TaskModel task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      task.taskName!,
                      style: _theme.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  taskSchedule(task),
                  SizedBox(height: 10),
                  taskDiscription(task),
                ],
              ),
            ),
          ),
          task.status == TOGGLE_NOT_STARTED
              ? startDeclineButton(task)
              : task.status == TOGGLE_INPROGRESS
                  ? completedButton(task)
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: CommonButton(
                        text: LOG_HOURS_BUTTON,
                        color: BUTTON_GRAY_COLOR,
                        onPressed: () {},
                      ),
                    )
        ],
      ),
    );
  }

  Widget taskDiscription(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TASK_DETAILS,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: CommonDivider(),
        ),
        Text(
          task.description!,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            color: DARK_GRAY,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget taskSchedule(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SCHEDULES,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: CommonDivider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormatFromTimeStamp()
                  .dateFormatToEEEDDMMMYYYY(timeStamp: task.startDate!),
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Row(
              children: [
                Text(
                  ESTIMATED_HRS,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  task.estimatedHrs.toString(),
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    color: UNSELECTED_TAB_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget startDeclineButton(TaskModel task) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: width * 0.04),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              text: START_BUTTON,
              color: GRAY,
              fontColor: DARK_GRAY,
              onPressed: () async {
                final TaskModel taskModel = TaskModel(
                  enrollTaskId: task.enrollTaskId,
                  projectId: task.projectId,
                  taskOwnerId: task.taskOwnerId,
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
                final ResponseModel response =
                    await _projectTaskBloc.updateTask(taskModel);
                if (response.success!) {
                  _taskBloc.getTask(task.taskId!);
                  ScaffoldSnakBar().show(context, msg: TASK_STARTED_POPUP_MSG);
                } else {
                  ScaffoldSnakBar()
                      .show(context, msg: TASK_NOT_UPDATED_POPUP_MSG);
                }
              },
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: CommonButton(
              fontColor: BLACK,
              color: SILVER_GRAY,
              text: DECLINE_BUTTON,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget completedButton(TaskModel task) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: width * 0.04),
      child: CommonButton(
        text: COMPLETED_BUTTON,
        color: DARK_PINK_COLOR,
        onPressed: () async {
          final TaskModel taskModel = TaskModel(
            enrollTaskId: task.enrollTaskId,
            projectId: task.projectId,
            taskOwnerId: task.taskOwnerId,
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
          final ResponseModel response =
              await _projectTaskBloc.updateTask(taskModel);
          if (response.success!) {
            _taskBloc.getTask(task.taskId!);
            ScaffoldSnakBar().show(context, msg: TASK_COMPLETED_POPUP_MSG);
          } else {
            ScaffoldSnakBar().show(context, msg: TASK_NOT_UPDATED_POPUP_MSG);
          }
        },
      ),
    );
  }
}
