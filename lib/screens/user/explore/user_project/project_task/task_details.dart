import 'package:flutter/material.dart';
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
        Text(
          timeStampConvertToDate(task.startDate),
          style: _theme.textTheme.bodyText2!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        SizedBox(height: 5),
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
    );
  }
}
