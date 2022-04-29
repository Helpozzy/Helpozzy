import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/edit_profile_bloc.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/bloc/project_sign_up_bloc.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_log_hrs_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/screens/notification/task_notification_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class NotificationInbox extends StatefulWidget {
  const NotificationInbox({Key? key}) : super(key: key);

  @override
  _NotificationInboxState createState() => _NotificationInboxState();
}

class _NotificationInboxState extends State<NotificationInbox> {
  late double height;
  late double width;
  late ThemeData _theme;
  final NotificationBloc _notificationBloc = NotificationBloc();
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  final TextEditingController _commentController = TextEditingController();
  final TaskBloc _taskBloc = TaskBloc();
  final ProjectSignUpBloc _projectSignUpBloc = ProjectSignUpBloc();
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  final EditProfileBloc _editProfileBloc = EditProfileBloc();

  @override
  void initState() {
    _notificationBloc.getNotifications();
    super.initState();
  }

  Future onApproveTaskLogHrs(
      NotificationModel notification, bool fromDeclineLogHrs) async {
    if (!fromDeclineLogHrs) CircularLoader().show(context);
    final TaskLogHrsModel taskLogHrs =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    TaskModel task = TaskModel.fromjson(json: taskLogHrs.data!);
    task.status = fromDeclineLogHrs ? TOGGLE_NOT_STARTED : LOG_HRS_APPROVED;
    task.isApprovedFromAdmin = true;
    taskLogHrs.data = task.toJson();
    final ResponseModel updateTaskResponse =
        await _taskBloc.updateEnrollTask(task);
    if (updateTaskResponse.success!) {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(
        context,
        msg: fromDeclineLogHrs
            ? 'Log Hours Request Declined'
            : 'Log Hours Request Approved',
      );
      taskLogHrs.comment = _commentController.text;
      taskLogHrs.hrs = taskLogHrs.hrs;
      taskLogHrs.mins = taskLogHrs.mins;
      taskLogHrs.isApprovedFromAdmin = fromDeclineLogHrs ? false : true;
      notification.type = fromDeclineLogHrs ? 1 : notification.type;
      notification.userTo = notification.userFrom;
      notification.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      notification.title = fromDeclineLogHrs
          ? 'Log Hours Request Declined'
          : 'Log Hours Request Approved';
      notification.subTitle = fromDeclineLogHrs
          ? 'Your log hours for ${task.taskName} is declined by owner, Please resubmit your volunteering hrs'
          : 'Your log hours for ${task.taskName} is approved';
      notification.isUpdated =
          fromDeclineLogHrs ? true : notification.isUpdated;
      notification.payload = taskLogHrs.toJson();
      if (fromDeclineLogHrs) {
        await _notificationBloc.updateNotifications(notification);
        await _notificationBloc.getNotifications();
      } else {
        final ProjectModel taskProject = await _projectsBloc
            .getProjectByProjectId(task.projectId!, task.signUpUserId!);

        taskProject.totalTaskshrs =
            taskProject.totalTaskshrs ?? 0 + taskLogHrs.hrs!;
        await _editProfileBloc.updateTotalSpentHrs(
            task.signUpUserId!, taskLogHrs.hrs!);
        final ResponseModel response =
            await _projectsBloc.updateEnrolledProjectHrs(
                task.signUpUserId!, task.projectId!, taskLogHrs.hrs!);
        if (response.success!) {
          ScaffoldSnakBar().show(context, msg: response.message!);
        } else {
          ScaffoldSnakBar().show(context, msg: response.error!);
        }
        await _notificationBloc.updateNotifications(notification);
        await _notificationBloc.getNotifications();
      }
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: updateTaskResponse.error!);
    }
  }

  Future onApproveTaskNotification(NotificationModel notification) async {
    CircularLoader().show(context);
    final TaskModel task = TaskModel.fromjson(json: notification.payload!);
    task.status = TOGGLE_NOT_STARTED;
    task.isApprovedFromAdmin = true;
    final ResponseModel updateTaskResponse =
        await _taskBloc.updateEnrollTask(task);
    if (updateTaskResponse.success!) {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: 'Request Approved');
      notification.userTo = notification.userFrom;
      notification.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      notification.title = 'Task Request Approved';
      notification.subTitle =
          'Your ${task.taskName} sign-up request is approved';
      notification.isUpdated = true;
      await _notificationBloc.updateNotifications(notification);
      await _notificationBloc.getNotifications();
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: updateTaskResponse.error!);
    }
  }

  Future onApproveProjectNotification(NotificationModel notification) async {
    CircularLoader().show(context);
    final ProjectModel signUpProject =
        ProjectModel.fromjson(json: notification.payload!);

    signUpProject.isApprovedFromAdmin = true;
    final ResponseModel updateProjectResponse =
        await _projectSignUpBloc.updateSignedUpProject(signUpProject);
    if (updateProjectResponse.success!) {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: 'Request Approved');
      notification.userTo = notification.userFrom;
      notification.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      notification.title = 'Project Request Approved';
      notification.subTitle =
          'Your ${signUpProject.projectName} sign-up request is approved';
      notification.isUpdated = true;
      await _notificationBloc.updateNotifications(notification);
      await _notificationBloc.getNotifications();
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: updateProjectResponse.error!);
    }
  }

  Future onDecline(NotificationModel notification) async {
    CircularLoader().show(context);
    if (notification.type == 2) {
      await onApproveTaskLogHrs(notification, true);
    } else {
      final ResponseModel notificationResponse =
          await _notificationBloc.removeNotification(notification.id!);

      if (notificationResponse.success!) {
        CircularLoader().hide(context);
        late ResponseModel response;
        if (notification.type == 0) {
          final ProjectModel project =
              ProjectModel.fromjson(json: notification.payload!);
          response =
              await _projectsBloc.removeSignedUpProject(project.enrolledId!);
        } else if (notification.type == 1) {
          final TaskModel task =
              TaskModel.fromjson(json: notification.payload!);
          response =
              await _projectTaskBloc.removeEnrolledTask(task.enrollTaskId!);
        }
        if (response.success!) {
          ScaffoldSnakBar().show(context, msg: response.message!);
        } else {
          ScaffoldSnakBar().show(context, msg: response.error!);
        }
        await _notificationBloc.getNotifications();
      } else {
        CircularLoader().hide(context);
        ScaffoldSnakBar().show(context, msg: notificationResponse.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(body: body);
  }

  Widget get body => RefreshIndicator(
        color: PRIMARY_COLOR,
        onRefresh: () => Future.delayed(
          Duration(seconds: 1),
          () => _notificationBloc.getNotifications(),
        ),
        child: SafeArea(
          child: GestureDetector(
            onPanDown: (_) => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 15.0,
                    left: width * 0.04,
                    right: width * 0.04,
                  ),
                  child: SmallInfoLabel(label: NOTIFICATION_LABEL),
                ),
                Expanded(child: notificationsList()),
              ],
            ),
          ),
        ),
      );

  Widget notificationsList() {
    return StreamBuilder<Notifications>(
      stream: _notificationBloc.getNotificationsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        final List<NotificationModel> notifications =
            snapshot.data!.notifications;
        return notifications.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                itemCount: notifications.length,
                separatorBuilder: (context, index) => CommonDivider(),
                itemBuilder: (context, index) {
                  final NotificationModel notification = notifications[index];
                  return NotificationTile(
                    notification: notification,
                    commentBox: notification.isUpdated!
                        ? SizedBox()
                        : notification.type == 2
                            ? Container(
                                height: 35,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10.0),
                                child: CommonRoundedTextfield(
                                  fillColor: GRAY,
                                  controller: _commentController,
                                  hintText: ENTER_COMMENT_HINT,
                                  validator: (val) => null,
                                ),
                              )
                            : SizedBox(),
                    childrens: notification.isUpdated!
                        ? []
                        : [
                            SmallCommonButton(
                              fontSize: 12,
                              buttonColor: GREEN,
                              text: APPROVE_BUTTON,
                              onPressed: () async {
                                notification.type == 0
                                    ? await onApproveProjectNotification(
                                        notification)
                                    : notification.type == 1
                                        ? await onApproveTaskNotification(
                                            notification)
                                        : await onApproveTaskLogHrs(
                                            notification, false);
                              },
                            ),
                            SizedBox(width: 6),
                            SmallCommonButton(
                              fontSize: 12,
                              buttonColor: SILVER_GRAY,
                              text: DECLINE_BUTTON,
                              onPressed: () async =>
                                  await onDecline(notification),
                            ),
                          ],
                  );
                },
              )
            : Center(
                child: Text(
                  NO_NOTIFICATIONS_FOUND,
                  style: _theme.textTheme.headline5!
                      .copyWith(color: DARK_GRAY, fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }
}
