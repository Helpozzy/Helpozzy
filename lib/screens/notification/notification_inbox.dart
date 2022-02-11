import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/models/notification_model.dart';
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
                  vertical: 15.0, horizontal: width * 0.05),
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
                  return ListTile(
                    title: Text(
                      notification.title!,
                      style: _theme.textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        Text(
                          notification.subTitle!,
                          style: _theme.textTheme.bodyText2!
                              .copyWith(color: DARK_GRAY),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            SmallCommonButton(
                              fontSize: 12,
                              buttonColor: GREEN,
                              text: APPROVE_BUTTON,
                              onPressed: () {},
                            ),
                            SizedBox(width: 6),
                            SmallCommonButton(
                              fontSize: 12,
                              buttonColor: DARK_GRAY,
                              text: DECLINE_BUTTON,
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
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
