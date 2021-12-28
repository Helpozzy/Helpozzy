import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatefulWidget {
  TaskDetails({required this.task});
  final TaskModel task;
  @override
  _TaskDetailsState createState() => _TaskDetailsState(task: task);
}

class _TaskDetailsState extends State<TaskDetails> {
  _TaskDetailsState({required this.task});
  final TaskModel task;
  late ThemeData _theme;
  late double width;

  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  String timeStampConvertToDate(String date) {
    return DateFormat('EEE, dd MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: 'Task Detail', elevation: 1),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    task.taskName,
                    style: _theme.textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
                taskSchedule(),
                SizedBox(height: 10),
                taskDiscription(),
              ],
            ),
          ),
          Spacer(),
          task.status == TOGGLE_NOT_STARTED
              ? processButton(false)
              : task.status == TOGGLE_INPROGRESS
                  ? processButton(true)
                  : singleSubmitHoursButton()
        ],
      ),
    );
  }

  Widget taskDiscription() {
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
          task.description,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            color: DARK_GRAY,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget taskSchedule() {
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
              timeStampConvertToDate(task.startDate),
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

  Widget processButton(bool taskIsInProgress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          taskIsInProgress
              ? CommonButton(
                  fontSize: 12,
                  text: COMPLETED_BUTTON,
                  borderColor: DARK_PINK_COLOR,
                  color: DARK_PINK_COLOR,
                  onPressed: () async {
                    final bool response =
                        await _projectTaskBloc.updateTaskKeyValue(
                            taskId: task.id,
                            key: 'status',
                            val: TOGGLE_COMPLETE);
                    if (response)
                      showSnakeBar(context, msg: TASK_COMPLETED_POPUP_MSG);
                    else
                      showSnakeBar(context, msg: TASK_NOT_UPDATED_POPUP_MSG);
                  },
                )
              : Row(
                  children: [
                    CommonButton(
                      fontSize: 12,
                      text: START_BUTTON,
                      borderColor: GRAY,
                      color: GRAY,
                      onPressed: () async {
                        final bool response =
                            await _projectTaskBloc.updateTaskKeyValue(
                          taskId: task.id,
                          key: 'status',
                          val: TOGGLE_INPROGRESS,
                        );
                        if (response)
                          showSnakeBar(context, msg: TASK_STARTED_POPUP_MSG);
                        else
                          showSnakeBar(
                            context,
                            msg: TASK_NOT_UPDATED_POPUP_MSG,
                          );
                      },
                    ),
                    SizedBox(width: 7),
                    CommonButton(
                      fontSize: 12,
                      fontColor: BLACK,
                      borderColor: SILVER_GRAY,
                      color: SILVER_GRAY,
                      text: DECLINE_BUTTON,
                      onPressed: () {},
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget singleSubmitHoursButton() {
    return Container(
      width: width / 1.35,
      alignment: Alignment.center,
      child: SmallCommonButton(
        text: LOG_HOURS_BUTTON,
        buttonColor: BUTTON_GRAY_COLOR,
        fontSize: 12,
        onPressed: () {},
      ),
    );
  }
}
