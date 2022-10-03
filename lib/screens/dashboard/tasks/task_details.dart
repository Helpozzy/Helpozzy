import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
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
  late List<SignUpAndUserModel> membersDetails = [];

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  Future getMembers() async {
    if (task.members != null && task.members!.isNotEmpty) {
      for (int i = 0; i < task.members!.length; i++) {
        final SignUpAndUserModel user =
            await Repository().userInfoRepo(task.members![i]);
        membersDetails.add(user);
      }
    }
    setState(() {});
  }

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
                  SizedBox(height: width * 0.06),
                  members(),
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

  Widget members() {
    return membersDetails.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    TASK_MEMBERS,
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    CupertinoIcons.person_2,
                    size: 14,
                  )
                ],
              ),
              SizedBox(height: width * 0.02),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    runSpacing: 5,
                    children: membersDetails
                        .map((volunteer) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                              padding: EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                volunteer.firstName! +
                                    ' ' +
                                    volunteer.lastName!,
                                style: _theme.textTheme.bodyText2!
                                    .copyWith(color: WHITE),
                              ),
                            ))
                        .toList()),
              ),
            ],
          )
        : SizedBox();
  }
}
