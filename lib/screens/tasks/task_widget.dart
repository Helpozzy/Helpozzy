import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  TaskCard({
    required this.task,
    this.optionEnable = false,
    this.selected = false,
    this.onTapDelete,
    this.onTapItem,
  });
  final TaskModel task;
  final bool optionEnable;
  final bool selected;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapDelete;

  @override
  State<TaskCard> createState() => _TaskCardState(
        task: task,
        optionEnable: optionEnable,
        selected: selected,
        onTapItem: onTapItem,
        onTapDelete: onTapDelete,
      );
}

class _TaskCardState extends State<TaskCard> {
  _TaskCardState({
    required this.task,
    this.optionEnable = false,
    this.selected = false,
    this.onTapDelete,
    this.onTapItem,
  });
  final TaskModel task;
  final bool optionEnable;
  final bool selected;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapDelete;

  late ThemeData _themeData;
  late double width;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  String timeStampConvertToDate(String date) {
    return DateFormat('EEE, dd MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 3,
      color: !optionEnable
          ? WHITE
          : selected
              ? GRAY
              : WHITE,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            InkWell(
              onTap: onTapItem,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width / 1.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeStampConvertToDate(task.startDate),
                          style: _themeData.textTheme.bodyText2!.copyWith(
                              fontSize: 10, color: UNSELECTED_TAB_COLOR),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              ESTIMATED_HRS,
                              style: _themeData.textTheme.bodyText2!.copyWith(
                                fontSize: 10,
                                color: PRIMARY_COLOR,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              task.estimatedHrs.toString(),
                              style: _themeData.textTheme.bodyText2!.copyWith(
                                fontSize: 10,
                                color: UNSELECTED_TAB_COLOR,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CommonDivider(),
                  Text(
                    task.taskName,
                    style: _themeData.textTheme.headline6!.copyWith(
                      fontSize: 14,
                      color: UNSELECTED_TAB_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  !optionEnable
                      ? task.status == TOGGLE_NOT_STARTED
                          ? processButton(false)
                          : task.status == TOGGLE_INPROGRESS
                              ? processButton(true)
                              : singleSubmitHoursButton()
                      : SizedBox(),
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
    );
  }

  Widget processButton(bool taskIsInProgress) {
    return Container(
      width: width / 1.35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Are you running late?',
            style: _themeData.textTheme.bodyText2!.copyWith(
              fontSize: 8,
              color: BLUE_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          taskIsInProgress
              ? SmallCommonButton(
                  fontSize: 12,
                  text: 'Completed',
                  buttonColor: DARK_PINK_COLOR,
                  onPressed: () async {
                    final bool response =
                        await _projectTaskBloc.updateTaskKeyValue(
                            taskId: task.id,
                            key: 'status',
                            val: TOGGLE_COMPLETE);
                    if (response)
                      showSnakeBar(context, msg: 'Task completed');
                    else
                      showSnakeBar(context,
                          msg: 'Technical issue! Task not updated');
                  },
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmallCommonButton(
                      fontSize: 12,
                      text: START_BUTTON,
                      buttonColor: GRAY,
                      onPressed: () async {
                        final bool response =
                            await _projectTaskBloc.updateTaskKeyValue(
                                taskId: task.id,
                                key: 'status',
                                val: TOGGLE_INPROGRESS);
                        if (response)
                          showSnakeBar(context, msg: 'Task started');
                        else
                          showSnakeBar(context,
                              msg: 'Technical issue! Task not updated');
                      },
                    ),
                    SizedBox(width: 7),
                    SmallCommonButton(
                      fontSize: 12,
                      fontColor: BLACK,
                      buttonColor: SILVER_GRAY,
                      text: DECLINE_BUTTON,
                      onPressed: () {},
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget singleSubmitHoursButton() {
    return Container(
      width: width / 1.35,
      alignment: Alignment.center,
      child: SmallCommonButton(
        text: LOG_HOURS_BUTTON,
        buttonColor: BUTTON_GRAY_COLOR,
        fontSize: 12,
        onPressed: () {},
      ),
    );
  }
}
