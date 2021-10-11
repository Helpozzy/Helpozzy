import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/admin/members/members.dart';
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
  final TextEditingController _taskMinimumAgeController =
      TextEditingController();
  final TextEditingController _taskQualificationController =
      TextEditingController();
  final TextEditingController _taskStartDateController =
      TextEditingController();
  final TextEditingController _taskEndDateController = TextEditingController();
  final TextEditingController _taskMembersController = TextEditingController();
  final TextEditingController _taskHoursController = TextEditingController();
  final TextEditingController _searchEmailController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late List<PlatformFile> pickedFiles = [];
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  int _selectedIndexValue = 0;
  bool postOnLocalCheck = false;

  @override
  void initState() {
    if (fromEdit) retriveTaskDetails();
    super.initState();
  }

  Future retriveTaskDetails() async {
    _taskNameController.text = task!.taskName;
    _taskDesController.text = task!.description;
    _taskMemberReqController.text = task!.memberRequirement;
    _taskMinimumAgeController.text = task!.ageRestriction;
    _taskQualificationController.text = task!.qualification;
    _taskStartDateController.text = task!.startDate;
    _taskEndDateController.text = task!.endDate;
    _taskMembersController.text = task!.members;
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
      appBar: CommonAppBar(context).show(
        title: fromEdit ? EDIT_TASK_APPBAR : CREATE_TASK_APPBAR,
        color: WHITE,
        textColor: DARK_PINK_COLOR,
        elevation: 1,
      ),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: SimpleFieldWithLabel(
                        label: TASK_NAME_LABEL,
                        controller: _taskNameController,
                        hintText: TASK_NAME_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter task name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: SimpleFieldWithLabel(
                        label: TASK_DESCRIPTION_LABEL,
                        controller: _taskDesController,
                        hintText: TASK_DESCRIPTION_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter task description';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.03, left: width * 0.05),
                      child: SmallInfoLabel(label: TIMELINE_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: startDateAndEndDateSection(),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.03, left: width * 0.05),
                      child: SmallInfoLabel(label: MEMBERS_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: inviteMembersSection(),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.04, horizontal: width * 0.05),
                      child:
                          SmallInfoLabel(label: TASK_MEMBERS_REQUIREMENT_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: memberRequirementsSection(),
                    ),
                    Divider(),
                    SizedBox(height: 10)
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
    );
  }

  Widget inviteMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.search,
              color: BLACK,
            ),
            SizedBox(width: 10),
            Expanded(
              child: CommonSimpleTextfield(
                controller: _searchEmailController,
                hintText: PROJECT_SEARCH_WITH_EMAIL_HINT,
                validator: (val) {},
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: BLACK,
                  ),
                  SizedBox(width: 5),
                  Text(
                    COPY_LINK,
                    style: _themeData.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: postOnLocalCheck,
                  onChanged: (val) {
                    setState(() {
                      postOnLocalCheck = !postOnLocalCheck;
                    });
                  },
                ),
                Text(
                  POST_ON_LOCAL_FEED,
                  style: _themeData.textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold, color: PRIMARY_COLOR),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: CommonButtonWithIcon(
            icon: Icons.group_outlined,
            text: MEMBERS_LIST_BUTTON,
            fontSize: 12,
            iconSize: 15,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembersScreen(),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget startDateAndEndDateSection() {
    return Row(
      children: [
        Expanded(
          child: CommonSimpleTextfield(
            readOnly: true,
            controller: _taskStartDateController,
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
                if (pickedDate != null && pickedDate != _selectedStartDate)
                  setState(() {
                    _selectedStartDate = pickedDate;
                  });
                _taskStartDateController.value = TextEditingValue(
                    text: '${DateFormat.yMd().format(_selectedStartDate)}');
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Text(
            TO,
            style: _themeData.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: CommonSimpleTextfield(
            readOnly: true,
            controller: _taskEndDateController,
            hintText: PROJECT_END_HINT,
            validator: (val) {
              if (val!.isEmpty) {
                return 'Select end date';
              } else if (_selectedEndDate.isBefore(_selectedStartDate)) {
                return 'Select valid end date';
              }
              return null;
            },
            onTap: () {
              CommonDatepicker()
                  .showDatePickerDialog(context, initialDate: _selectedEndDate)
                  .then((pickedDate) {
                if (pickedDate != null && pickedDate != _selectedEndDate)
                  setState(() {
                    _selectedEndDate = pickedDate;
                  });
                _taskEndDateController.value = TextEditingValue(
                    text: '${DateFormat.yMd().format(_selectedEndDate)}');
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.calendar_today_rounded)
      ],
    );
  }

  Widget memberRequirementsSection() {
    return Column(
      children: [
        TextfieldLabelSmall(label: TASK_MEMBERS_LABEL),
        CommonSimpleTextfield(
          controller: _taskMemberReqController,
          hintText: TASK_MEMBERS_REQUIREMENT_HINT,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Enter no of members are required';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        TextfieldLabelSmall(label: TASK_MINIMUM_AGE_LABEL),
        CommonSimpleTextfield(
          controller: _taskMinimumAgeController,
          hintText: TASK_MINIMUM_AGE_HINT,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Enter age restriction';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        TextfieldLabelSmall(label: TASK_QUALIFICATION_LABEL),
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
      ],
    );
  }

  Future addOrUpdateData() async {
    CircularLoader().show(context);
    final TaskModel taskDetails = TaskModel(
      projectId: '',
      id: fromEdit ? task!.id : '',
      taskName: _taskNameController.text,
      description: _taskDesController.text,
      memberRequirement: _taskMemberReqController.text,
      ageRestriction: _taskMinimumAgeController.text,
      qualification: _taskQualificationController.text,
      startDate: _taskStartDateController.text,
      endDate: _taskEndDateController.text,
      members: _taskMembersController.text,
      status: _selectedIndexValue == 0
          ? TOGGLE_NOT_STARTED
          : _selectedIndexValue == 1
              ? TOGGLE_INPROGRESS
              : TOGGLE_COMPLE,
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
    _taskMinimumAgeController.clear();
    _taskQualificationController.clear();
    _taskStartDateController.clear();
    _taskEndDateController.clear();
    _taskMembersController.clear();
    _taskHoursController.clear();
  }
}
