import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TaskNotification extends StatelessWidget {
  final NotificationModel notification;
  final GestureTapCallback? onDecline;
  final GestureTapCallback? onApprove;
  TaskNotification({
    required this.notification,
    this.onApprove,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            notification.title!,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              color: DARK_PINK_COLOR,
              fontSize: 16,
            ),
          ),
          Text(
            DateFormatFromTimeStamp()
                .dateFormatToEEEDDMMMYYYY(timeStamp: notification.timeStamp!),
            style: _theme.textTheme.bodyText2!
                .copyWith(fontSize: 10, color: UNSELECTED_TAB_COLOR),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.subTitle!,
            style: _theme.textTheme.bodyText2!
                .copyWith(color: BLACK, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SmallCommonButton(
                  fontSize: 12,
                  buttonColor: GREEN,
                  text: APPROVE_BUTTON,
                  onPressed: onApprove,
                ),
                SizedBox(width: 6),
                SmallCommonButton(
                  fontSize: 12,
                  buttonColor: DARK_GRAY,
                  text: DECLINE_BUTTON,
                  onPressed: onDecline,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
