import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';

class TaskCard extends StatelessWidget {
  final Widget? eventButton;
  final TaskModel task;
  final bool optionEnable;
  final bool selected;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapDelete;
  TaskCard({
    this.eventButton,
    required this.task,
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
                    Text(
                      DateFormatFromTimeStamp()
                          .dateFormatToEEEDDMMMYYYY(timeStamp: task.startDate),
                      style: _theme.textTheme.bodyText2!
                          .copyWith(fontSize: 10, color: UNSELECTED_TAB_COLOR),
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
                    !optionEnable
                        ? eventButton != null
                            ? eventButton!
                            : SizedBox()
                        : SizedBox(),
                    SizedBox(height: 8),
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
              ),
              optionEnable
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: DARK_GRAY,
                      ),
                      onPressed: onTapDelete,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
