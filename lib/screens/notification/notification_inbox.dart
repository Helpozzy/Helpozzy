import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/models/notification_model.dart';
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

  @override
  void initState() {
    _notificationBloc.getNotifications();
    super.initState();
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
              padding: EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: width * 0.04),
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
                  return TaskNotification(
                    notification: notification,
                    onApprove: () async {
                      CircularLoader().show(context);
                      final TaskModel task =
                          TaskModel.fromjson(json: notification.payload!);
                      task.status = TOGGLE_NOT_STARTED;
                      task.isApprovedFromAdmin = true;
                      final ResponseModel updateTaskResponse =
                          await _taskBloc.updateEnrollTask(task);
                      if (updateTaskResponse.success!) {
                        CircularLoader().hide(context);
                        ScaffoldSnakBar()
                            .show(context, msg: updateTaskResponse.message!);
                        final ResponseModel notificationResponse =
                            await _notificationBloc
                                .removeNotification(notification.id!);
                        if (notificationResponse.success!) {
                          ScaffoldSnakBar().show(context,
                              msg: notificationResponse.message!);
                        } else {
                          ScaffoldSnakBar()
                              .show(context, msg: notificationResponse.error!);
                        }
                      } else {
                        CircularLoader().hide(context);
                        ScaffoldSnakBar()
                            .show(context, msg: updateTaskResponse.error!);
                      }
                    },
                    onDecline: () async {
                      await _notificationBloc
                          .removeNotification(notification.id!);
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  NO_RECORD_FOUND,
                  style:
                      _theme.textTheme.headline6!.copyWith(color: SHADOW_GRAY),
                ),
              );
      },
    );
  }
}
