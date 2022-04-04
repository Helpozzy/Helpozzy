import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/task_log_hrs_model.dart';
import 'package:helpozzy/utils/constants.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final List<Widget>? childrens;
  final Widget? commentBox;
  NotificationTile(
      {required this.notification, this.commentBox, this.childrens});

  String getComment() {
    final TaskLogHrsModel taskLogHrsModel =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    return taskLogHrsModel.comment!;
  }

  List<String> getRequestHrs() {
    final TaskLogHrsModel taskLogHrsModel =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    final String hrs = DateFormatFromTimeStamp()
        .durationToHHMM(duration: Duration(milliseconds: taskLogHrsModel.hrs!));
    return hrs.split(':');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: width * 0.01,
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
          notification.type == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FEEDBACK_LABEL + getComment(),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      REQUESTED_HRS +
                          getRequestHrs()[0] +
                          HRS_LABEL +
                          DASH_LABEL +
                          getRequestHrs()[1] +
                          MINS_LABEL,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          commentBox != null ? commentBox! : SizedBox(),
          childrens != null
              ? Padding(
                  padding: notification.type == 2
                      ? const EdgeInsets.only(top: 0.0)
                      : const EdgeInsets.only(top: 10.0),
                  child: Row(children: childrens!),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
