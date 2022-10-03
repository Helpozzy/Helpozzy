import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/task_log_hrs_model.dart';
import 'package:helpozzy/utils/constants.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final List<Widget>? childrens;
  final bool? hasCommentBox;
  final Widget? commentBox;

  NotificationTile(
      {required this.notification,
      this.hasCommentBox,
      this.commentBox,
      this.childrens});

  String getComment() {
    final TaskLogHrsModel taskLogHrsModel =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    return taskLogHrsModel.comment!;
  }

  int getRequestHrs() {
    final TaskLogHrsModel taskLogHrsModel =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    return taskLogHrsModel.hrs!;
  }

  int getRequestMins() {
    final TaskLogHrsModel taskLogHrsModel =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    return taskLogHrsModel.mins!;
  }

  bool getLogHrsIsApproved() {
    final TaskLogHrsModel taskLogHrsModel =
        TaskLogHrsModel.fromjson(json: notification.payload!);
    return taskLogHrsModel.isApprovedFromAdmin!;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              notification.title!,
              maxLines: 2,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w600,
                color: DARK_PINK_COLOR,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              DateFormatFromTimeStamp().dateFormatToDDMMMYYYYatTime(
                  timeStamp: notification.timeStamp!),
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontSize: 10, color: SILVER_GRAY),
            ),
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
                    getLogHrsIsApproved()
                        ? Text(
                            APPROVED_HRS +
                                getRequestHrs().toString() +
                                HRS_LABEL +
                                DASH_LABEL +
                                getRequestMins().toString() +
                                MINS_LABEL,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        : Text(
                            REQUESTED_HRS +
                                getRequestHrs().toString() +
                                HRS_LABEL +
                                DASH_LABEL +
                                getRequestMins().toString() +
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
          hasCommentBox! || childrens!.isNotEmpty
              ? Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      hasCommentBox!
                          ? Expanded(child: commentBox!)
                          : SizedBox(),
                      SizedBox(width: 3),
                      childrens != null
                          ? Row(children: childrens!)
                          : SizedBox(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
