import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/bloc/project_sign_up_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
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
  final TaskBloc _taskBloc = TaskBloc();
  final ProjectSignUpBloc _projectSignUpBloc = ProjectSignUpBloc();

  @override
  void initState() {
    _notificationBloc.getNotifications();
    super.initState();
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
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: updateProjectResponse.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(body: body);
  }

  Widget get body => SafeArea(
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
                physics: ScrollPhysics(),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => CommonDivider(),
                itemBuilder: (context, index) {
                  final NotificationModel notification = notifications[index];
                  return NotificationTile(
                    notification: notification,
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
                                    : await onApproveTaskNotification(
                                        notification);
                                await _notificationBloc.getNotifications();
                              },
                            ),
                            SizedBox(width: 6),
                            SmallCommonButton(
                              fontSize: 12,
                              buttonColor: SILVER_GRAY,
                              text: DECLINE_BUTTON,
                              onPressed: () async => await _notificationBloc
                                  .removeNotification(notification.id!),
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
