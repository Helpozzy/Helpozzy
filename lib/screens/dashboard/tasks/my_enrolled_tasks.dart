import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/task_log_hrs_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/screens/dashboard/tasks/task_details.dart';
import 'package:helpozzy/screens/dashboard/tasks/task_card.dart';
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
  final TaskBloc _taskBloc = TaskBloc();
  final NotificationBloc _notificationBloc = NotificationBloc();
  late Duration initialTime = Duration.zero;
  final TextEditingController _commentController = TextEditingController();
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  late SignUpAndUserModel userModel;
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    getUserData();
    _taskBloc.getEnrolledTasks();
    super.initState();
  }

  Future getUserData() async {
    final String userData = prefsObject.getString(CURRENT_USER_DATA)!;
    final Map<String, dynamic> json =
        jsonDecode(userData) as Map<String, dynamic>;
    userModel = SignUpAndUserModel.fromJson(json: json);
  }

  Future updateTask(TaskModel task, TaskProgressType taskProgressType) async {
    CircularLoader().show(context);

    if (taskProgressType == TaskProgressType.DECLINE) {
      final ResponseModel response =
          await _taskBloc.removeEnrollTask(task.enrollTaskId!);
      if (response.success!) {
        CircularLoader().hide(context);
        await _taskBloc.getEnrolledTasks();
        ScaffoldSnakBar().show(context, msg: response.message!);
      } else {
        CircularLoader().hide(context);
        ScaffoldSnakBar().show(context, msg: response.error!);
      }
    } else {
      TaskModel enrolledTaskModel = TaskModel(
        enrollTaskId: task.enrollTaskId,
        taskOwnerId: task.taskOwnerId,
        taskId: task.taskId,
        signUpUserId: task.signUpUserId,
        projectId: task.projectId,
        taskName: task.taskName,
        description: task.description,
        memberRequirement: task.memberRequirement,
        ageRestriction: task.ageRestriction,
        qualification: task.qualification,
        startDate: task.startDate,
        endDate: task.endDate,
        estimatedHrs: task.estimatedHrs,
        status: taskProgressType == TaskProgressType.START
            ? TOGGLE_INPROGRESS
            : taskProgressType == TaskProgressType.COMPLETED
                ? TOGGLE_COMPLETE
                : taskProgressType == TaskProgressType.LOG_HRS
                    ? LOG_HRS
                    : taskProgressType == TaskProgressType.DECLINE
                        ? TOGGLE_NOT_STARTED
                        : task.status,
        totalVolunteerHrs: task.totalVolunteerHrs,
        isApprovedFromAdmin: taskProgressType == TaskProgressType.DECLINE
            ? false
            : task.isApprovedFromAdmin,
      );
      final ResponseModel response =
          await _taskBloc.updateEnrollTask(enrolledTaskModel);
      if (response.success!) {
        CircularLoader().hide(context);
        await _taskBloc.getEnrolledTasks();
        ScaffoldSnakBar().show(
          context,
          msg: taskProgressType == TaskProgressType.COMPLETED
              ? TASK_COMPLETED_POPUP_MSG
              : taskProgressType == TaskProgressType.START
                  ? TASK_STARTED_POPUP_MSG
                  : taskProgressType == TaskProgressType.DECLINE
                      ? TASK_DECLINE_POPUP_MSG
                      : taskProgressType == TaskProgressType.LOG_HRS
                          ? TASK_LOG_HRS_POPUP_MSG
                          : task.status!,
        );

        if (taskProgressType == TaskProgressType.LOG_HRS) {
          final TaskLogHrsModel logHrsModel = TaskLogHrsModel(
            timeStamp: DateTime.now().millisecondsSinceEpoch,
            hrs: int.parse(DateFormatFromTimeStamp()
                .durationToHHMM(duration: initialTime)
                .split(':')[0]),
            mins: int.parse(DateFormatFromTimeStamp()
                .durationToHHMM(duration: initialTime)
                .split(':')[1]),
            comment: _commentController.text,
            isApprovedFromAdmin: false,
            data: enrolledTaskModel.toJson(),
          );
          await ScaffoldSnakBar().show(context, msg: response.message!);
          final NotificationModel notification = NotificationModel(
            type: 2,
            userFrom: prefsObject.getString(CURRENT_USER_ID),
            userTo: task.taskOwnerId,
            timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Log Task Hours Request',
            payload: logHrsModel.toJson(),
            subTitle:
                "${userModel.firstName} want's to log hours of the ${task.taskName}.",
          );

          final ResponseModel notificationResponse =
              await _notificationBloc.postNotification(notification);
          if (notificationResponse.success!) {
            await ScaffoldSnakBar().show(context, msg: response.message!);
            await _taskBloc.getEnrolledTasks();
          } else {
            await ScaffoldSnakBar().show(context, msg: response.error!);
            await _taskBloc.getEnrolledTasks();
          }
        }
      } else {
        CircularLoader().hide(context);
        ScaffoldSnakBar().show(context, msg: TASK_NOT_UPDATED_POPUP_MSG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
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
                        SizedBox(width: 10),
                        Expanded(
                          child: TaskCard(
                            task: task,
                            eventButton: DateFormatFromTimeStamp()
                                        .dateTime(
                                            timeStamp:
                                                currentTimeStamp.toString())
                                        .difference(DateFormatFromTimeStamp()
                                            .dateTime(timeStamp: task.endDate!))
                                        .inDays >=
                                    1
                                ? SizedBox()
                                : task.status == LOG_HRS
                                    ? SizedBox()
                                    : task.status == TOGGLE_NOT_STARTED
                                        ? processButton(false, task)
                                        : task.status == TOGGLE_INPROGRESS
                                            ? processButton(true, task)
                                            : Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      bottom: 5.0,
                                                    ),
                                                    child:
                                                        CommonSimpleTextfield(
                                                      controller:
                                                          _commentController,
                                                      hintText:
                                                          ENTER_COMMENT_HINT,
                                                      prefixIcon: TextButton(
                                                        onPressed: () =>
                                                            showPickerModalBottomSheet(),
                                                        child: Text(
                                                          _dateFormatFromTimeStamp
                                                              .durationToHHMM(
                                                                  duration:
                                                                      initialTime),
                                                          style: _theme
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      validator: (val) => null,
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  SmallCommonButton(
                                                    text: LOG_HOURS_BUTTON,
                                                    buttonColor:
                                                        BUTTON_GRAY_COLOR,
                                                    fontSize: 12,
                                                    onPressed: () async =>
                                                        updateTask(
                                                      task,
                                                      TaskProgressType.LOG_HRS,
                                                    ),
                                                  ),
                                                ],
                                              ),
                            onTapItem: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetails(task: task),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          NO_TASKS_FOUND,
                          style: _theme.textTheme.headline5!.copyWith(
                              color: DARK_GRAY, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          GO_FOR_NEW_SIGNUP,
                          textAlign: TextAlign.center,
                          style: _theme.textTheme.bodyText2!
                              .copyWith(color: DARK_GRAY),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future showPickerModalBottomSheet() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return cupertinoTimePicker();
      },
    );
  }

  Widget cupertinoTimePicker() {
    return Container(
      height: height / 3,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        minuteInterval: 1,
        initialTimerDuration: initialTime,
        onTimerDurationChanged: (Duration changedtimer) {
          setState(() => initialTime = changedtimer);
        },
      ),
    );
  }

  Widget processButton(bool taskIsInProgress, TaskModel task) {
    return taskIsInProgress
        ? SmallCommonButton(
            fontSize: 12,
            text: COMPLETED_BUTTON,
            buttonColor: DARK_PINK_COLOR,
            onPressed: () async => updateTask(task, TaskProgressType.COMPLETED),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmallCommonButton(
                  fontSize: 12,
                  text: START_BUTTON,
                  buttonColor: GRAY,
                  fontColor: DARK_GRAY,
                  onPressed: () async =>
                      await updateTask(task, TaskProgressType.START),
                ),
                SizedBox(width: 7),
                SmallCommonButton(
                  fontSize: 12,
                  fontColor: BLACK,
                  buttonColor: SILVER_GRAY,
                  text: DECLINE_BUTTON,
                  onPressed: () async =>
                      await updateTask(task, TaskProgressType.DECLINE),
                ),
              ],
            ),
          );
  }
}
