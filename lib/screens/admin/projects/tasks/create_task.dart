import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
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
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late double width;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: 'Create Task'),
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
                                    .showPicker(context,
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
                                    .showPicker(context,
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
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                child: CommonButton(
                  text: ADD_TASK_BUTTON,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      CircularLoader().show(context);
                      final TaskModel task = TaskModel(
                        projectId: '',
                        id: '',
                        taskName: _taskNameController.text,
                        description: _taskDesController.text,
                        timeLine: _taskTimelineController.text,
                        memberRequirement: _taskMemberReqController.text,
                        ageRestriction: _taskAgeRestrictionController.text,
                        qualification: _taskQualificationController.text,
                        startDate: _taskStartDateController.text,
                        endDate: _taskEndDateController.text,
                        members: _taskMembersController.text,
                      );
                      final bool isUploaded =
                          await _projectTaskBloc.postTasks(task);
                      if (isUploaded) {
                        await clearFields();
                        CircularLoader().hide(context);
                        showSnakeBar(context,
                            msg: 'Task created successfully!');
                      } else {
                        await clearFields();
                        CircularLoader().hide(context);
                        showSnakeBar(context,
                            msg: 'Task not created due some error, Try again!');
                      }
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
  }
}

// Tasks - Create/Update/Modify/Delete
// - Task Name
// - Task Description
// - Task Timeline
// - Task Member Requirement - How many members are needed
// - Task Age Restriction
// - Task Qualification
// - Task Start Date/Time
// - Task End Date/Time
// - Task Members
// - Task Status (Non Started, In Progress, Complete)
// - Task Hours
// - Task Notifications (Start, In-Progress, Complete)