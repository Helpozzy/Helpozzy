import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/screens/dashboard/projects/volunteer_sign_up.dart';
import 'package:helpozzy/screens/dashboard/tasks/task_details.dart';
import 'package:helpozzy/screens/dashboard/tasks/task_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TaskTab extends StatefulWidget {
  TaskTab({required this.project, this.projectTabType});
  final ProjectModel project;
  final ProjectTabType? projectTabType;
  @override
  _TaskTabState createState() =>
      _TaskTabState(project: project, projectTabType: projectTabType);
}

class _TaskTabState extends State<TaskTab> {
  _TaskTabState({required this.project, this.projectTabType});
  final ProjectModel project;
  final ProjectTabType? projectTabType;
  late ThemeData _theme;
  late double height;
  late double width;
  late bool myTaskExpanded = false;
  late bool allTasksExpanded = false;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  final TextEditingController _commentController = TextEditingController();
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  final TaskBloc _taskBloc = TaskBloc();
  late Duration initialTime = Duration.zero;
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(body: taskDivisions());
  }

  Widget taskDivisions() {
    return SingleChildScrollView(
      child: Column(
        children: [
          project.ownerId != prefsObject.getString(CURRENT_USER_ID)
              ? StreamBuilder<bool>(
                  initialData: myTaskExpanded,
                  stream: _projectTaskBloc.getMyTaskExpandedStream,
                  builder: (context, snapshot) {
                    return tasksCategoriesCard(
                      prefixWidget: CommonUserProfileOrPlaceholder(
                        imgUrl:
                            prefsObject.getString(CURRENT_USER_PROFILE_URL)!,
                        size: width / 12,
                      ),
                      label: MY_TASKS_LABEL,
                      isMyTask: true,
                      isExpanded: snapshot.data!,
                    );
                  },
                )
              : SizedBox(),
          StreamBuilder<bool>(
            initialData: allTasksExpanded,
            stream: _projectTaskBloc.geAllTaskExpandedStream,
            builder: (context, snapshot) {
              return tasksCategoriesCard(
                prefixWidget: Icon(
                  CupertinoIcons.square_list,
                  size: width / 12,
                  color: BLUE_GRAY,
                ),
                label: VIEW_ALL_TASKS_LABEL,
                isMyTask: false,
                isExpanded: snapshot.data!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget tasksCategoriesCard({
    required Widget prefixWidget,
    required String label,
    required bool isMyTask,
    required bool isExpanded,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          if (isMyTask) {
            setState(() => myTaskExpanded = !myTaskExpanded);
            _projectTaskBloc.myTaskIsExpanded(myTaskExpanded);
            _projectTaskBloc.getProjectEnrolledTasks(project.projectId!);
          } else {
            setState(() => allTasksExpanded = !allTasksExpanded);
            _projectTaskBloc.allTaskIsExpanded(allTasksExpanded);
            _projectTaskBloc.getProjectAllTasks(project.projectId!);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          prefixWidget,
                          SizedBox(width: 8),
                          Text(
                            label,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              color: DARK_PINK_COLOR,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
                  ],
                ),
                isExpanded ? tasksOfProject(isMyTask) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tasksOfProject(bool isMyTask) {
    return StreamBuilder<Tasks>(
      stream: isMyTask
          ? _projectTaskBloc.getProjectEnrolledTasksStream
          : _projectTaskBloc.getProjectTasksStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: width * 0.04),
            child: LinearLoader(),
          );
        }
        return snapshot.data!.tasks.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data!.tasks.length,
                itemBuilder: (context, index) {
                  TaskModel task = snapshot.data!.tasks[index];
                  return Row(
                    children: [
                      isMyTask
                          ? CommonBadge(
                              color: task.status == TOGGLE_NOT_STARTED
                                  ? LIGHT_GRAY
                                  : task.status == TOGGLE_INPROGRESS
                                      ? AMBER_COLOR
                                      : ACCENT_GREEN,
                              size: 15,
                            )
                          : SizedBox(),
                      isMyTask ? SizedBox(width: 6) : SizedBox(),
                      Expanded(
                        child: TaskCard(
                          task: task,
                          eventButton: DateFormatFromTimeStamp()
                                      .dateTime(
                                          timeStamp:
                                              currentTimeStamp.toString())
                                      .difference(DateFormatFromTimeStamp()
                                          .dateTime(timeStamp: task.endDate!))
                                      .inDays >
                                  1
                              ? SizedBox()
                              : isMyTask
                                  ? task.status == TOGGLE_NOT_STARTED
                                      ? processButton(
                                          taskIsInProgress: false,
                                          isMyTask: isMyTask,
                                          task: task)
                                      : task.status == TOGGLE_INPROGRESS
                                          ? processButton(
                                              taskIsInProgress: true,
                                              isMyTask: isMyTask,
                                              task: task)
                                          : task.status == TOGGLE_COMPLETE
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0,
                                                        bottom: 5.0,
                                                      ),
                                                      child:
                                                          CommonSimpleTextfield(
                                                        controller:
                                                            _commentController,
                                                        hintText:
                                                            ENTER_COMMENT_HINT,
                                                        prefixIcon: TextButton(
                                                          onPressed: () =>
                                                              showPickerModalBottomSheet(),
                                                          child: Text(
                                                            _dateFormatFromTimeStamp
                                                                .durationToHHMM(
                                                                    duration:
                                                                        initialTime),
                                                            style: _theme
                                                                .textTheme
                                                                .bodyText2!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        validator: (val) =>
                                                            null,
                                                      ),
                                                    ),
                                                    SizedBox(height: 6),
                                                    SmallCommonButton(
                                                      text: LOG_HOURS_BUTTON,
                                                      buttonColor:
                                                          BUTTON_GRAY_COLOR,
                                                      fontSize: 12,
                                                      onPressed: () async =>
                                                          await onTapFunction(
                                                        task,
                                                        isMyTask,
                                                        TaskProgressType
                                                            .LOG_HRS,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox()
                                  : projectTabType ==
                                          ProjectTabType.PROJECT_COMPLETED_TAB
                                      ? SizedBox()
                                      : task.taskOwnerId !=
                                              prefsObject
                                                  .getString(CURRENT_USER_ID)
                                          ? SmallCommonButton(
                                              text: SIGN_UP,
                                              fontSize: 12,
                                              buttonColor: DARK_GRAY,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        VolunteerProjectTaskSignUp(
                                                      fromTask: true,
                                                      project: project,
                                                      task: task,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : SizedBox(),
                          onTapItem: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetails(task: task),
                              ),
                            );
                            if (isMyTask) {
                              _projectTaskBloc
                                  .getProjectEnrolledTasks(project.projectId!);
                            } else {
                              _projectTaskBloc
                                  .getProjectAllTasks(project.projectId!);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  NO_TASKS_FOUND,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(color: DARK_GRAY, fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  Future showPickerModalBottomSheet() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return cupertinoTimePicker();
      },
    );
  }

  Widget cupertinoTimePicker() {
    return Container(
      height: height / 3,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        minuteInterval: 1,
        initialTimerDuration: initialTime,
        onTimerDurationChanged: (Duration changedtimer) {
          setState(() => initialTime = changedtimer);
        },
      ),
    );
  }

  Widget processButton({
    required bool taskIsInProgress,
    required bool isMyTask,
    required TaskModel task,
  }) {
    return taskIsInProgress
        ? SmallCommonButton(
            fontSize: 12,
            text: COMPLETED_BUTTON,
            buttonColor: DARK_PINK_COLOR,
            onPressed: () async =>
                await onTapFunction(task, isMyTask, TaskProgressType.COMPLETED),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmallCommonButton(
                  fontSize: 12,
                  text: START_BUTTON,
                  buttonColor: GRAY,
                  fontColor: DARK_GRAY,
                  onPressed: () async => await onTapFunction(
                      task, isMyTask, TaskProgressType.START),
                ),
                SizedBox(width: 7),
                SmallCommonButton(
                  fontSize: 12,
                  fontColor: BLACK,
                  buttonColor: SILVER_GRAY,
                  text: DECLINE_BUTTON,
                  onPressed: () async => await onTapFunction(
                      task, isMyTask, TaskProgressType.DECLINE),
                ),
              ],
            ),
          );
  }

  Future onTapFunction(
      TaskModel task, bool isMyTask, TaskProgressType taskProgressType) async {
    CircularLoader().show(context);
    final TaskModel taskModel = TaskModel(
      enrollTaskId: task.enrollTaskId,
      taskId: task.taskId,
      projectId: task.projectId,
      taskOwnerId: task.taskOwnerId,
      signUpUserId: task.signUpUserId,
      taskName: task.taskName,
      description: task.description,
      memberRequirement: task.memberRequirement,
      ageRestriction: task.ageRestriction,
      qualification: task.qualification,
      startDate: task.startDate,
      endDate: task.endDate,
      estimatedHrs: task.estimatedHrs,
      totalVolunteerHrs: task.totalVolunteerHrs,
      isApprovedFromAdmin: taskProgressType == TaskProgressType.DECLINE
          ? false
          : task.isApprovedFromAdmin,
      status: taskProgressType == TaskProgressType.COMPLETED
          ? TOGGLE_COMPLETE
          : taskProgressType == TaskProgressType.START
              ? TOGGLE_INPROGRESS
              : taskProgressType == TaskProgressType.DECLINE
                  ? TOGGLE_NOT_STARTED
                  : task.status,
    );
    final ResponseModel response = await _taskBloc.updateEnrollTask(taskModel);
    if (response.success!) {
      CircularLoader().hide(context);
      if (isMyTask) {
        _projectTaskBloc.getProjectEnrolledTasks(project.projectId!);
      } else {
        _projectTaskBloc.getProjectAllTasks(project.projectId!);
      }
      ScaffoldSnakBar().show(
        context,
        msg: taskProgressType == TaskProgressType.COMPLETED
            ? TASK_COMPLETED_POPUP_MSG
            : taskProgressType == TaskProgressType.START
                ? TASK_STARTED_POPUP_MSG
                : taskProgressType == TaskProgressType.DECLINE
                    ? TASK_DECLINE_POPUP_MSG
                    : taskProgressType == TaskProgressType.LOG_HRS
                        ? TASK_LOG_HRS_POPUP_MSG
                        : task.status!,
      );
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(
        context,
        msg: TASK_NOT_UPDATED_POPUP_MSG,
      );
    }
  }
}
