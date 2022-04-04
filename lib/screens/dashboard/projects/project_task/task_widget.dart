import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/utils/constants.dart';

class TaskCard extends StatelessWidget {
  final dynamic task;
  final bool optionEnable;
  final bool selected;
  final Widget eventButton;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapDelete;
  TaskCard({
    required this.task,
    required this.eventButton,
    this.optionEnable = false,
    this.selected = false,
    this.onTapDelete,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        elevation: 2,
        color: !optionEnable
            ? WHITE
            : selected
                ? GRAY
                : WHITE,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                              timeStamp: task.startDate),
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 10,
                            color: UNSELECTED_TAB_COLOR,
                          ),
                        ),
                        Text(
                          ESTIMATED_HRS + task.estimatedHrs.toString(),
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 8,
                            color: PRIMARY_COLOR,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      task.taskName,
                      style: _theme.textTheme.headline6!.copyWith(
                        fontSize: 14,
                        color: UNSELECTED_TAB_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    task.status == LOG_HRS
                        ? Text(
                            COMPLETED_BUTTON.toUpperCase(),
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 10,
                              color: BLUE_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox(),
                    task.status == TOGGLE_COMPLETE || task.status == LOG_HRS
                        ? SizedBox()
                        : Text(
                            TASK_ARE_YOU_RUNNING_LATE,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 10,
                              color: BLUE_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    Center(child: eventButton),
                    task.status == TOGGLE_COMPLETE
                        ? SizedBox()
                        : SizedBox(height: 8),
                  ],
                ),
              ),
              optionEnable
                  ? task.taskOwnerId == prefsObject.getString(CURRENT_USER_ID)
                      ? IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: DARK_GRAY,
                          ),
                          onPressed: onTapDelete,
                        )
                      : SizedBox()
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
