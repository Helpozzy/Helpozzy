import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/utils/constants.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final List<Widget>? childrens;
  NotificationTile({required this.notification, this.childrens});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: width * 0.02,
        horizontal: width * 0.04,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            notification.title!,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: DARK_PINK_COLOR,
            ),
          ),
          Text(
            DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYYatTime(
                timeStamp: notification.timeStamp!),
            style: _theme.textTheme.bodyText2!
                .copyWith(fontSize: 10, color: SILVER_GRAY),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.subTitle!,
            style: _theme.textTheme.bodyText2!.copyWith(
              color: BLUE_GRAY,
              fontSize: 12,
            ),
          ),
          childrens != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(children: childrens!),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
