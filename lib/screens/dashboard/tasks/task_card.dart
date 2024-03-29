import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final Widget? eventButton;
  final bool optionEnable;
  final bool selected;
  final bool fromSelectTask;
  final GestureTapCallback? onTapItem;
  final SlidableActionCallback? onTapEdit;
  final SlidableActionCallback? onTapDelete;
  final void Function()? onTapEditFromAttachedTask;
  final void Function()? onTapRemoveFromAttachedTask;
  TaskCard({
    required this.task,
    this.eventButton,
    this.optionEnable = false,
    this.fromSelectTask = false,
    this.selected = false,
    this.onTapEdit,
    this.onTapDelete,
    this.onTapItem,
    this.onTapEditFromAttachedTask,
    this.onTapRemoveFromAttachedTask,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    return optionEnable
        ? slidableInfoTile(context, _theme, width)
        : simpleInfoTile(context, _theme, width);
  }

  Widget slidableInfoTile(
      BuildContext context, ThemeData _theme, double width) {
    return Slidable(
      key: const ValueKey(0),
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 0.35,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: onTapEdit,
            foregroundColor: PRIMARY_COLOR,
            icon: CupertinoIcons.pencil_ellipsis_rectangle,
            autoClose: true,
          ),
          SlidableAction(
            flex: 1,
            onPressed: onTapDelete,
            foregroundColor: RED_COLOR,
            icon: CupertinoIcons.trash,
            autoClose: true,
          ),
        ],
      ),
      child: simpleInfoTile(context, _theme, width),
    );
  }

  Widget simpleInfoTile(BuildContext context, ThemeData _theme, double width) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        elevation: 3,
        color: !optionEnable
            ? WHITE
            : selected
                ? GRAY
                : WHITE,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.taskName!,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        color: UNSELECTED_TAB_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateFormatFromTimeStamp()
                        .dateFormatToEEEDDMMMYYYY(timeStamp: task.startDate!),
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: 9,
                      color: UNSELECTED_TAB_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  task.taskOwnerId == prefsObject.getString(CURRENT_USER_ID) &&
                          fromSelectTask
                      ? SizedBox(width: 6)
                      : SizedBox(),
                  task.taskOwnerId == prefsObject.getString(CURRENT_USER_ID) &&
                          fromSelectTask
                      ? InkWell(
                          onTap: onTapEditFromAttachedTask,
                          child: Icon(
                            CupertinoIcons.pencil_circle,
                            size: width * 0.04,
                          ),
                        )
                      : SizedBox(),
                  task.taskOwnerId == prefsObject.getString(CURRENT_USER_ID) &&
                          fromSelectTask
                      ? SizedBox(width: 6)
                      : SizedBox(),
                  task.taskOwnerId == prefsObject.getString(CURRENT_USER_ID) &&
                          fromSelectTask
                      ? InkWell(
                          onTap: onTapRemoveFromAttachedTask,
                          child: Icon(
                            CupertinoIcons.clear,
                            size: width * 0.04,
                          ),
                        )
                      : SizedBox()
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    color: UNSELECTED_TAB_COLOR,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CommonDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: StatusWidget(label: task.status!),
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
              task.status == LOG_HRS
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        WAITING_FOR_APPROVAL.toUpperCase(),
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 10,
                          color: BLUE_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : task.status == LOG_HRS_APPROVED
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            COMPLETED_BUTTON,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 10,
                              color: DARK_PINK_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox(),
              task.enrollTaskId != null
                  ? task.status == TOGGLE_COMPLETE ||
                          task.status == TOGGLE_INPROGRESS ||
                          task.status == LOG_HRS ||
                          task.status == LOG_HRS_APPROVED
                      ? SizedBox()
                      : Text(
                          TASK_ARE_YOU_RUNNING_LATE,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 10,
                            color: BLUE_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                  : SizedBox(),
              task.status == LOG_HRS_APPROVED
                  ? SizedBox()
                  : Align(alignment: Alignment.center, child: eventButton),
            ],
          ),
        ),
      ),
    );
  }
}
