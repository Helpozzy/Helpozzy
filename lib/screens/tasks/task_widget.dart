import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

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

  late ThemeData _theme;
  late double width;
  final CustomTimerController _timerController = CustomTimerController();
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
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
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width / 1.37,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                              timeStamp: task.startDate),
                          style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 10, color: UNSELECTED_TAB_COLOR),
                        ),
                        !optionEnable && task.status == TOGGLE_INPROGRESS
                            ? CustomTimer(
                                controller: _timerController,
                                begin: Duration(days: 1),
                                end: Duration(hours: task.estimatedHrs),
                                builder: (time) {
                                  return Text(
                                    "${time.hours} : ${time.minutes} : ${time.seconds}",
                                    style: _theme.textTheme.bodyText2!.copyWith(
                                      color: PRIMARY_COLOR,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ],
                    ),
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
                      ? task.status == TOGGLE_NOT_STARTED
                          ? processButton(false)
                          : task.status == TOGGLE_INPROGRESS
                              ? processButton(true)
                              : singleSubmitHoursButton()
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

  Widget processButton(bool taskIsInProgress) {
    return Container(
      width: width / 1.37,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            TASK_ARE_YOU_RUNNING_LATE,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 8,
              color: BLUE_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          taskIsInProgress
              ? SmallCommonButton(
                  fontSize: 12,
                  text: COMPLETED_BUTTON,
                  buttonColor: DARK_PINK_COLOR,
                  onPressed: () async {
                    final TaskModel taskModel = TaskModel(
                      projectId: task.projectId,
                      ownerId: task.ownerId,
                      id: task.id,
                      taskName: task.taskName,
                      description: task.description,
                      memberRequirement: task.memberRequirement,
                      ageRestriction: task.ageRestriction,
                      qualification: task.qualification,
                      startDate: task.startDate,
                      endDate: task.endDate,
                      estimatedHrs: task.estimatedHrs,
                      totalVolunteerHrs: task.totalVolunteerHrs,
                      members: task.members,
                      status: TOGGLE_COMPLETE,
                    );
                    final bool response =
                        await _projectTaskBloc.updateTasks(taskModel);
                    if (response) {
                      _timerController.finish();
                      showSnakeBar(context, msg: TASK_COMPLETED_POPUP_MSG);
                    } else {
                      showSnakeBar(context, msg: TASK_NOT_UPDATED_POPUP_MSG);
                    }
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
                        final TaskModel taskModel = TaskModel(
                          projectId: task.projectId,
                          ownerId: task.ownerId,
                          id: task.id,
                          taskName: task.taskName,
                          description: task.description,
                          memberRequirement: task.memberRequirement,
                          ageRestriction: task.ageRestriction,
                          qualification: task.qualification,
                          startDate: task.startDate,
                          endDate: task.endDate,
                          estimatedHrs: task.estimatedHrs,
                          totalVolunteerHrs: task.totalVolunteerHrs,
                          members: task.members,
                          status: TOGGLE_INPROGRESS,
                        );
                        final bool response =
                            await _projectTaskBloc.updateTasks(taskModel);
                        if (response) {
                          _timerController.start();
                          showSnakeBar(context, msg: TASK_COMPLETED_POPUP_MSG);
                        } else {
                          showSnakeBar(
                            context,
                            msg: TASK_NOT_UPDATED_POPUP_MSG,
                          );
                        }
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
