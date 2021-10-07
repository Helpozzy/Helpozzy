import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/admin/projects/tasks/tasks_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  AdminProjectsBloc _adminProjectsBloc = AdminProjectsBloc();
  final TextEditingController _projNameController = TextEditingController();
  final TextEditingController _projDesController = TextEditingController();
  final TextEditingController _projStartDateController =
      TextEditingController();
  final TextEditingController _projEndDateController = TextEditingController();
  final TextEditingController _projOwnerController = TextEditingController();
  final TextEditingController _projCollaboraorController =
      TextEditingController();
  final TextEditingController _projMembersController = TextEditingController();
  final TextEditingController _projHoursController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  late double height;
  int _selectedIndexValue = 0;

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: CREATE_PROJECT_APPBAR),
      body: body(),
    );
  }

  Widget body() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommonSimpleTextfield(
                      controller: _projNameController,
                      hintText: PROJECT_NAME_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project name';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      controller: _projDesController,
                      hintText: PROJECT_DESCRIPTION_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project description';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonSimpleTextfield(
                            readOnly: true,
                            controller: _projStartDateController,
                            hintText: PROJECT_START_DATE_HINT,
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
                                _projStartDateController.value = TextEditingValue(
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
                            controller: _projEndDateController,
                            hintText: PROJECT_END_HINT,
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
                                _projEndDateController.value = TextEditingValue(
                                    text:
                                        '${DateFormat.yMd().format(_selectedEndDate)}');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CommonSimpleTextfield(
                      controller: _projOwnerController,
                      hintText: PROJECT_OWNERS_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter owner name';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      controller: _projCollaboraorController,
                      hintText: PROJECT_COLLABORATOR_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter Collaborator/Co-admin';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      controller: _projMembersController,
                      hintText: PROJECT_MEMBERS_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter members names';
                        }
                        return null;
                      },
                    ),
                    CommonSimpleTextfield(
                      readOnly: true,
                      controller: _projHoursController,
                      hintText: PROJECT_HOURS_HINT,
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
                          _projHoursController.value = TextEditingValue(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SmallInfoLabel(label: 'Tasks'),
                        IconButton(
                          icon: Icon(CupertinoIcons.add_circled,
                              color: DARK_GRAY),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => TasksScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: width * 0.2),
              child: CommonButton(
                text: ADD_PROJECT_BUTTON,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    await onAddProject();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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

  Future onAddProject() async {
    CircularLoader().show(context);
    final ProjectModel project = ProjectModel(
      projectId: '',
      projectName: _projNameController.text,
      description: _projDesController.text,
      startDate: _projStartDateController.text,
      endDate: _projEndDateController.text,
      projectOwner: _projOwnerController.text,
      collaboratorsCoadmin: _projCollaboraorController.text,
      members: _projMembersController.text,
      status: _selectedIndexValue == 0
          ? TOGGLE_NOT_STARTED
          : _selectedIndexValue == 1
              ? TOGGLE_INPROGRESS
              : TOGGLE_COMPLE,
      hours: double.parse(_projHoursController.text),
    );
    final bool isUploaded = await _adminProjectsBloc.postProject(project);
    if (isUploaded) {
      await clearFields();
      CircularLoader().hide(context);
      showSnakeBar(context, msg: 'Project created successfully!');
    } else {
      await clearFields();
      CircularLoader().hide(context);
      showSnakeBar(context,
          msg: 'Project not created due some error, Try again!');
    }
  }

  Future clearFields() async {
    _projNameController.clear();
    _projDesController.clear();
    _projStartDateController.clear();
    _projEndDateController.clear();
    _projOwnerController.clear();
    _projCollaboraorController.clear();
    _projMembersController.clear();
    _projHoursController.clear();
  }
}
