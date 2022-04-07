import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/create_edit_task.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';

class TaskCard extends StatefulWidget {
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
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late ThemeData _theme;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return widget.optionEnable ? slidableInfoTile() : simpleInfoTile();
  }

  Future<void> showDeletePrompt() async {
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
            onPressed: widget.onTapDelete,
            text: DELETE_BUTTON,
          ),
        ),
      ],
    );
  }

  Widget slidableInfoTile() {
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
                    task: widget.task,
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
            onPressed: (BuildContext context) => showDeletePrompt(),
            foregroundColor: RED_COLOR,
            icon: CupertinoIcons.trash,
            autoClose: true,
          ),
        ],
      ),
      child: simpleInfoTile(),
    );
  }

  Widget simpleInfoTile() {
    return GestureDetector(
      onTap: widget.onTapItem,
      child: Card(
        elevation: 2,
        color: !widget.optionEnable
            ? WHITE
            : widget.selected
                ? GRAY
                : WHITE,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                        timeStamp: widget.task.startDate),
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: 10,
                      color: UNSELECTED_TAB_COLOR,
                    ),
                  ),
                  Text(
                    ESTIMATED_HRS + widget.task.estimatedHrs.toString(),
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: 8,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                widget.task.taskName,
                style: _theme.textTheme.headline6!.copyWith(
                  fontSize: 14,
                  color: UNSELECTED_TAB_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              widget.task.status == LOG_HRS
                  ? Text(
                      WAITING_FOR_APPROVAL.toUpperCase(),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 10,
                        color: BLUE_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : widget.task.status == LOG_HRS_APPROVED
                      ? Text(
                          COMPLETED_BUTTON.toUpperCase(),
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 10,
                            color: BLUE_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox(),
              widget.task.status == TOGGLE_COMPLETE ||
                      widget.task.status == LOG_HRS ||
                      widget.task.status == LOG_HRS_APPROVED
                  ? SizedBox()
                  : Text(
                      TASK_ARE_YOU_RUNNING_LATE,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 10,
                        color: BLUE_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              widget.task.status == LOG_HRS_APPROVED
                  ? SizedBox()
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: widget.eventButton),
            ],
          ),
        ),
      ),
    );
  }
}
