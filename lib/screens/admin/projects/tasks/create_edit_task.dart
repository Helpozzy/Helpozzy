import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class CreateEditTask extends StatefulWidget {
  CreateEditTask({required this.fromEdit, this.task});
  final bool fromEdit;
  final TaskModel? task;
  @override
  _CreateEditTaskState createState() =>
      _CreateEditTaskState(fromEdit: fromEdit, task: task);
}

class _CreateEditTaskState extends State<CreateEditTask> {
  _CreateEditTaskState({required this.fromEdit, this.task});
  final bool fromEdit;
  final TaskModel? task;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDesController = TextEditingController();
  final TextEditingController _taskTimelineController = TextEditingController();
  final TextEditingController _taskMemberReqController =
      TextEditingController();
  final TextEditingController _taskAgeRestrictionController =
      TextEditingController();
  final TextEditingController _taskQualificationController =
      TextEditingController();
  final TextEditingController _taskStartDateController =
      TextEditingController();
  final TextEditingController _taskEndDateController = TextEditingController();
  final TextEditingController _taskMembersController = TextEditingController();
  final TextEditingController _taskHoursController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  int _selectedIndexValue = 0;

  @override
  void initState() {
    if (fromEdit) retriveTaskDetails();
    super.initState();
  }

  Future retriveTaskDetails() async {
    _taskNameController.text = task!.taskName;
    _taskDesController.text = task!.description;
    _taskTimelineController.text = task!.timeLine;
    _taskMemberReqController.text = task!.memberRequirement;
    _taskAgeRestrictionController.text = task!.ageRestriction;
    _taskQualificationController.text = task!.qualification;
    _taskStartDateController.text = task!.startDate;
    _taskEndDateController.text = task!.endDate;
    _taskMembersController.text = task!.members;
    _taskHoursController.text = task!.hours.toString();
    _selectedIndexValue = task!.status == TOGGLE_NOT_STARTED
        ? 0
        : task!.status == TOGGLE_INPROGRESS
            ? 1
            : 2;
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context)
          .show(title: fromEdit ? EDIT_TASK_APPBAR : CREATE_TASK_APPBAR),
      body: body(),
    );
  }

  Widget body() {
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CommonSimpleTextfield(
                        controller: _taskNameController,
                        hintText: TASK_NAME_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter project name';
                          }
                          return null;
                        },
                      ),
                      CommonSimpleTextfield(
                        controller: _taskDesController,
                        hintText: TASK_DESCRIPTION_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter project description';
                          }
                          return null;
                        },
                      ),
                      CommonSimpleTextfield(
                        controller: _taskTimelineController,
                        hintText: TASK_TIMELINE_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter timeline';
                          }
                          return null;
                        },
                      ),
                      CommonSimpleTextfield(
                        controller: _taskMemberReqController,
                        hintText: TASK_MEMBERS_REQUIREMENT_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter members requirement';
                          }
                          return null;
                        },
                      ),
                      CommonSimpleTextfield(
                        controller: _taskAgeRestrictionController,
                        hintText: TASK_AGE_RESTRICTION_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter age restriction';
                          }
                          return null;
                        },
                      ),
                      CommonSimpleTextfield(
                        controller: _taskQualificationController,
                        hintText: TASK_QUALIFICATION_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter qualification';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CommonSimpleTextfield(
                              readOnly: true,
                              controller: _taskStartDateController,
                              hintText: TASK_START_DATE_HINT,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Select start date';
                                }
                                return null;
                              },
                              onTap: () {
                                CommonDatepicker()
                                    .showDatePickerDialog(context,
                                        initialDate: _selectedStartDate)
                                    .then((pickedDate) {
                                  if (pickedDate != null &&
                                      pickedDate != _selectedStartDate)
                                    setState(() {
                                      _selectedStartDate = pickedDate;
                                    });
                                  _taskStartDateController.value = TextEditingValue(
                                      text:
                                          '${DateFormat.yMd().format(_selectedStartDate)}');
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CommonSimpleTextfield(
                              readOnly: true,
                              controller: _taskEndDateController,
                              hintText: TASK_END_HINT,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Select end date';
                                } else if (_selectedEndDate
                                    .isBefore(_selectedStartDate)) {
                                  return 'Select valid end date';
                                }
                                return null;
                              },
                              onTap: () {
                                CommonDatepicker()
                                    .showDatePickerDialog(context,
                                        initialDate: _selectedEndDate)
                                    .then((pickedDate) {
                                  if (pickedDate != null &&
                                      pickedDate != _selectedEndDate)
                                    setState(() {
                                      _selectedEndDate = pickedDate;
                                    });
                                  _taskEndDateController.value = TextEditingValue(
                                      text:
                                          '${DateFormat.yMd().format(_selectedEndDate)}');
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      CommonSimpleTextfield(
                        controller: _taskMembersController,
                        hintText: TASK_MEMBERS_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter members';
                          }
                          return null;
                        },
                      ),
                      CommonSimpleTextfield(
                        readOnly: true,
                        controller: _taskHoursController,
                        hintText: TASK_HOURS_HINT,
                        validator: (val) {
                          if (val!.isEmpty && selectedTime.toString().isEmpty) {
                            return 'Select hours';
                          }
                          return null;
                        },
                        onTap: () {
                          CommonDatepicker()
                              .showTimePickerDialog(context,
                                  selectedTime: selectedTime)
                              .then((selectedTimeVal) {
                            if (selectedTimeVal != null)
                              setState(() {
                                selectedTime = selectedTimeVal;
                              });
                            _taskHoursController.value = TextEditingValue(
                                text:
                                    '${selectedTime.hour}.${selectedTime.minute}');
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: width * 0.04),
                        child: SmallInfoLabel(label: 'Project Status Tracking'),
                      ),
                      statusSegmentation(),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                child: CommonButton(
                  text: fromEdit ? UPDATE_TASK_BUTTON : ADD_TASK_BUTTON,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      await addOrUpdateData();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addOrUpdateData() async {
    CircularLoader().show(context);
    final TaskModel taskDetails = TaskModel(
      projectId: '',
      id: fromEdit ? task!.id : '',
      taskName: _taskNameController.text,
      description: _taskDesController.text,
      timeLine: _taskTimelineController.text,
      memberRequirement: _taskMemberReqController.text,
      ageRestriction: _taskAgeRestrictionController.text,
      qualification: _taskQualificationController.text,
      startDate: _taskStartDateController.text,
      endDate: _taskEndDateController.text,
      members: _taskMembersController.text,
      status: _selectedIndexValue == 0
          ? TOGGLE_NOT_STARTED
          : _selectedIndexValue == 1
              ? TOGGLE_INPROGRESS
              : TOGGLE_COMPLE,
      hours: double.parse(_taskHoursController.text),
    );
    final bool isUploaded = fromEdit
        ? await _projectTaskBloc.updateTasks(taskDetails)
        : await _projectTaskBloc.postTasks(taskDetails);
    if (isUploaded) {
      if (!fromEdit) await clearFields();
      CircularLoader().hide(context);
      showSnakeBar(context,
          msg: fromEdit
              ? 'Task updated successfully!'
              : 'Task created successfully!');
    } else {
      if (!fromEdit) await clearFields();
      CircularLoader().hide(context);
      showSnakeBar(context,
          msg: fromEdit
              ? 'Task not updated due some error, Try again!'
              : 'Task not created due some error, Try again!');
    }
  }

  Widget statusSegmentation() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: CupertinoSlidingSegmentedControl(
          groupValue: _selectedIndexValue,
          backgroundColor: GRAY,
          thumbColor: DARK_GRAY.withAlpha(100),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
          children: {
            0: segmentItem(TOGGLE_NOT_STARTED),
            1: segmentItem(TOGGLE_INPROGRESS),
            2: segmentItem(TOGGLE_COMPLE),
          },
          onValueChanged: (value) {
            setState(() {
              _selectedIndexValue = value.hashCode;
            });
          }),
    );
  }

  Widget segmentItem(String title) {
    return Text(
      title,
      style: _themeData.textTheme.bodyText2!
          .copyWith(fontWeight: FontWeight.w500, color: DARK_GRAY_FONT_COLOR),
    );
  }

  Future clearFields() async {
    _taskNameController.clear();
    _taskDesController.clear();
    _taskTimelineController.clear();
    _taskMemberReqController.clear();
    _taskAgeRestrictionController.clear();
    _taskQualificationController.clear();
    _taskStartDateController.clear();
    _taskEndDateController.clear();
    _taskMembersController.clear();
    _taskHoursController.clear();
  }
}
