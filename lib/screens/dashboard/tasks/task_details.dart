import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(title: TASK_DETAILS_APPBAR),
      body: SafeArea(child: body(task)),
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
                  SizedBox(height: width * 0.02),
                  taskSchedule(task),
                  SizedBox(height: width * 0.06),
                  taskDiscription(task),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget taskSchedule(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SCHEDULE,
          style:
              _theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: width * 0.02),
        Row(
          children: [
            Text(
              DateFormatFromTimeStamp()
                  .dateFormatToEEEDDMMMYYYY(timeStamp: task.startDate!),
              style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
            ),
            SizedBox(width: 5),
            Icon(
              CupertinoIcons.calendar,
              size: 16,
              color: PRIMARY_COLOR,
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Text(
              ESTIMATED_HRS,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 12,
                color: PRIMARY_COLOR,
              ),
            ),
            Text(
              task.estimatedHrs.toString(),
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 12,
                color: UNSELECTED_TAB_COLOR,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              CupertinoIcons.timer,
              size: 16,
              color: PRIMARY_COLOR,
            ),
          ],
        ),
      ],
    );
  }

  Widget taskDiscription(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TASK_DETAILS,
          style:
              _theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: width * 0.02),
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
}
