import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/create_edit_task.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
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
    return optionEnable ? slidableInfoTile(_theme) : simpleInfoTile(_theme);
  }

  Future<void> showDeletePrompt(BuildContext context, ThemeData _theme) async {
    await PlatformAlertDialog().showWithAction(
      context,
      title: CONFIRM,
      content: DELETE_TASK_TEXT,
      actions: [
        TextButton(
          onPressed: () async => Navigator.of(context).pop(),
          child: Text(
            CANCEL_BUTTON,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SmallCommonButton(
            fontSize: 12,
            onPressed: onTapDelete,
            text: DELETE_BUTTON,
          ),
        ),
      ],
    );
  }

  Widget slidableInfoTile(ThemeData _theme) {
    return Slidable(
      key: const ValueKey(0),
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 0.35,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEditTask(
                    fromEdit: true,
                    task: task,
                  ),
                ),
              );
            },
            foregroundColor: PRIMARY_COLOR,
            icon: CupertinoIcons.pencil_ellipsis_rectangle,
            autoClose: true,
          ),
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) =>
                showDeletePrompt(context, _theme),
            foregroundColor: RED_COLOR,
            icon: CupertinoIcons.trash,
            autoClose: true,
          ),
        ],
      ),
      child: simpleInfoTile(_theme),
    );
  }

  Widget simpleInfoTile(ThemeData _theme) {
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
                  Text(
                    task.taskName!,
                    style: _theme.textTheme.bodyText2!.copyWith(
                      color: UNSELECTED_TAB_COLOR,
                      fontWeight: FontWeight.w600,
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
                  ),
                ),
              ),
              CommonDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(width: 1.0, color: GRAY)),
                    child: Text(
                      task.status!.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.headline6!.copyWith(
                        fontSize: 8,
                        color: BLUE_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
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
