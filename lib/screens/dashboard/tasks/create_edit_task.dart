import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/members/members.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';

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

  final TextEditingController _taskQualificationController =
      TextEditingController();
  final TextEditingController _taskStartDateController =
      TextEditingController();
  final TextEditingController _taskEndDateController = TextEditingController();
  final TextEditingController _taskMembersController = TextEditingController();
  final TextEditingController _estimatedHoursController =
      TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late List<PlatformFile> pickedFiles = [];
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  late double height;
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  late double hrsTrackerVal = 0.0;
  late double noOfMemberTrackerVal = 0.0;
  late double minimumAgeTrackerVal = 7.0;
  late int _selectedIndexValue = 0;
  late List<SignUpAndUserModel> selectedItems = [];

  @override
  void initState() {
    if (fromEdit) retriveTaskDetails();
    _projectsBloc.getOtherUsersInfo();
    super.initState();
  }

  Future retriveTaskDetails() async {
    _taskNameController.text = task!.taskName!;
    _taskDesController.text = task!.description!;
    if (task!.estimatedHrs! < 10) {
      hrsTrackerVal = double.parse(task!.estimatedHrs.toString());
    } else {
      _estimatedHoursController.text = task!.estimatedHrs.toString();
    }
    noOfMemberTrackerVal = double.parse(task!.memberRequirement.toString());
    minimumAgeTrackerVal = double.parse(task!.ageRestriction.toString());
    _taskQualificationController.text = task!.qualification!;
    _selectedStartDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(task!.startDate!));
    _selectedEndDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(task!.endDate!));
    _taskStartDateController.text =
        DateFormatFromTimeStamp().dateFormatToYMD(dateTime: _selectedStartDate);
    _taskEndDateController.text =
        DateFormatFromTimeStamp().dateFormatToYMD(dateTime: _selectedEndDate);
    _selectedIndexValue = task!.status == TOGGLE_NOT_STARTED
        ? 0
        : task!.status == TOGGLE_INPROGRESS
            ? 1
            : 2;
  }

  Future addUpdateData() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      CircularLoader().show(context);
      final List<String> members = [];
      if (selectedItems.isNotEmpty) {
        selectedItems.forEach((member) {
          members.add(member.userId!);
        });
      }

      if (fromEdit) {
        final TaskModel taskDetails = TaskModel(
          taskOwnerId: prefsObject.getString(CURRENT_USER_ID)!,
          projectId: task!.projectId,
          enrollTaskId: task!.enrollTaskId,
          taskId: task!.taskId,
          isApprovedFromAdmin: task!.isApprovedFromAdmin,
          isSelected: task!.isSelected,
          signUpUserId: task!.signUpUserId,
          taskName: _taskNameController.text,
          description: _taskDesController.text,
          memberRequirement: noOfMemberTrackerVal.round(),
          ageRestriction: minimumAgeTrackerVal.round(),
          qualification: _taskQualificationController.text,
          startDate: _selectedStartDate.millisecondsSinceEpoch.toString(),
          endDate: _selectedEndDate.millisecondsSinceEpoch.toString(),
          estimatedHrs: hrsTrackerVal.round() <= 10
              ? hrsTrackerVal.round()
              : int.parse(_estimatedHoursController.text),
          totalVolunteerHrs: 0,
          members: members,
          status: _selectedIndexValue == 0
              ? TOGGLE_NOT_STARTED
              : _selectedIndexValue == 1
                  ? TOGGLE_INPROGRESS
                  : TOGGLE_COMPLETE,
        );
        final ResponseModel response =
            await _projectTaskBloc.updateTask(taskDetails);
        if (response.success!) {
          await clearFields();
          CircularLoader().hide(context);
          Navigator.of(context).pop();
          ScaffoldSnakBar().show(
            context,
            msg: TASK_UPDATED_SUCCESSFULLY_POPUP_MSG,
          );
        } else {
          await clearFields();
          CircularLoader().hide(context);
          ScaffoldSnakBar().show(
            context,
            msg: TASK_NOT_UPDATED_ERROR_POPUP_MSG,
          );
        }
      } else {
        final TaskModel taskDetails = TaskModel(
          taskOwnerId: prefsObject.getString(CURRENT_USER_ID)!,
          taskName: _taskNameController.text,
          description: _taskDesController.text,
          memberRequirement: noOfMemberTrackerVal.round(),
          ageRestriction: minimumAgeTrackerVal.round(),
          qualification: _taskQualificationController.text,
          startDate: _selectedStartDate.millisecondsSinceEpoch.toString(),
          endDate: _selectedEndDate.millisecondsSinceEpoch.toString(),
          estimatedHrs: hrsTrackerVal.round() <= 10
              ? hrsTrackerVal.round()
              : int.parse(_estimatedHoursController.text),
          totalVolunteerHrs: 0,
          members: members,
          status: _selectedIndexValue == 0
              ? TOGGLE_NOT_STARTED
              : _selectedIndexValue == 1
                  ? TOGGLE_INPROGRESS
                  : TOGGLE_COMPLETE,
        );
        final ResponseModel response =
            await _projectTaskBloc.postTask(taskDetails);
        if (response.success!) {
          CircularLoader().hide(context);
          Navigator.of(context).pop();
          ScaffoldSnakBar().show(
            context,
            msg: TASK_CREATED_SUCCESSFULLY_POPUP_MSG,
          );
        } else {
          CircularLoader().hide(context);
          ScaffoldSnakBar().show(
            context,
            msg: TASK_NOT_CREATED_ERROR_POPUP_MSG,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(
        title: fromEdit ? EDIT_TASK_APPBAR : CREATE_TASK_APPBAR,
        actions: [
          IconButton(
            onPressed: () async => await addUpdateData(),
            icon: Icon(
              Icons.check_rounded,
              color: DARK_PINK_COLOR,
            ),
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
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
                        maxLines: 3,
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
                      child: TextfieldLabelSmall(label: TIMELINE_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: startDateAndEndDateSection(),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.03, left: width * 0.05),
                      child: TextfieldLabelSmall(label: HOURS_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: hoursSlider(),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.03, left: width * 0.05),
                      child: TextfieldLabelSmall(label: MEMBERS_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: inviteMembersSection(),
                    ),
                    selectedMembersList(),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: width * 0.03,
                        left: width * 0.05,
                        bottom: width * 0.03,
                      ),
                      child: TextfieldLabelSmall(label: STATUS_LABEL),
                    ),
                    statusSegmentation(),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.04, horizontal: width * 0.05),
                      child: TextfieldLabelSmall(
                          label: TASK_MEMBERS_REQUIREMENT_LABEL),
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
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 6),
              child: CommonButton(
                text: fromEdit ? UPDATE_BUTTON : ADD_TASK_BUTTON,
                onPressed: () async => await addUpdateData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hoursSlider() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            children: [
              Text(
                '0',
                style: _themeData.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: 11,
                  divisions: 11,
                  label: hrsTrackerVal.round().toString(),
                  value: hrsTrackerVal,
                  activeColor: PRIMARY_COLOR,
                  onChanged: (value) => setState(() => hrsTrackerVal = value),
                ),
              ),
              Text(
                '10 +',
                style: _themeData.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hrsTrackerVal >= 11.0
                ? Container(
                    width: width / 2,
                    padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                    child: CommonSimpleTextfield(
                      controller: _estimatedHoursController,
                      hintText: ENTER_ESTIMATED_HOURS_HINT,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() => _estimatedHoursController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: val.length)));
                      },
                      validator: (phone) {
                        if (phone!.isEmpty) {
                          return 'Please enter target hours';
                        } else {
                          return null;
                        }
                      },
                    ),
                  )
                : SizedBox(),
            hrsTrackerVal >= 11.0 ? SizedBox(width: width / 10) : SizedBox(),
            Column(
              children: [
                TextfieldLabelSmall(label: SELECTED_HOURS_LABEL),
                Text(
                  hrsTrackerVal.round() >= 11
                      ? _estimatedHoursController.text.isEmpty
                          ? '10+'
                          : _estimatedHoursController.text
                      : hrsTrackerVal.round().toString(),
                  style: _themeData.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 10)
      ],
    );
  }

  Widget inviteMembersSection() {
    return ListTile(
      title: Text(SELECT_MEMBER_LABEL),
      trailing: Icon(
        Icons.group_outlined,
        color: DARK_PINK_COLOR,
      ),
      onTap: () async {
        selectedItems = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MembersScreen(),
          ),
        );
        if (selectedItems.isNotEmpty) {
          await _projectsBloc.getSelectedMembers(members: selectedItems);
        }
      },
    );
  }

  Widget selectedMembersList() {
    return StreamBuilder<List<SignUpAndUserModel>>(
      stream: _projectsBloc.getSelectedMembersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: SizedBox());
        }
        return snapshot.data!.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    runSpacing: 5,
                    children: snapshot.data!
                        .map(
                          (volunteer) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            padding: EdgeInsets.only(
                              top: 3.0,
                              bottom: 3.0,
                              left: 10.0,
                              right: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  volunteer.firstName! +
                                      ' ' +
                                      volunteer.lastName!,
                                  style: _themeData.textTheme.bodyText2!
                                      .copyWith(color: WHITE),
                                ),
                                SizedBox(width: 3),
                                InkWell(
                                  onTap: () {
                                    snapshot.data!.remove(volunteer);
                                    setState(() {});
                                  },
                                  child: Icon(
                                    CupertinoIcons.multiply_circle_fill,
                                    color: WHITE,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList()),
              )
            : SizedBox();
      },
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
                  .showDatePickerDialog(context)
                  .then((pickedDate) {
                if (pickedDate != null && pickedDate != _selectedStartDate)
                  setState(() => _selectedStartDate = pickedDate);
                _taskStartDateController.value = TextEditingValue(
                    text: DateFormatFromTimeStamp()
                        .dateFormatToYMD(dateTime: _selectedStartDate));
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
            hintText: PROJECT_END_DATE_HINT,
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
                  .showDatePickerDialog(context)
                  .then((pickedDate) {
                if (pickedDate != null && pickedDate != _selectedEndDate)
                  setState(() => _selectedEndDate = pickedDate);
                _taskEndDateController.value = TextEditingValue(
                    text: DateFormatFromTimeStamp()
                        .dateFormatToYMD(dateTime: _selectedEndDate));
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Icon(
          Icons.calendar_today_rounded,
          color: DARK_PINK_COLOR,
        )
      ],
    );
  }

  Widget memberRequirementsSection() {
    return Column(
      children: [
        noOfMemeberSlider(),
        SizedBox(height: 8),
        minimumAgeRequirementSlider(),
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

  Widget noOfMemeberSlider() {
    return Column(
      children: [
        Row(
          children: [
            TextfieldLabelSmall(label: TASK_MEMBERS_LABEL),
            noOfMemberTrackerVal != 0.0
                ? Text(
                    ' - ' + noOfMemberTrackerVal.round().toString(),
                    style: _themeData.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : SizedBox()
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            children: [
              Text(
                '0',
                style: _themeData.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: 25,
                  label: noOfMemberTrackerVal.round().toString(),
                  value: noOfMemberTrackerVal,
                  activeColor: PRIMARY_COLOR,
                  onChanged: (value) =>
                      setState(() => noOfMemberTrackerVal = value),
                ),
              ),
              Text(
                '25',
                style: _themeData.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget minimumAgeRequirementSlider() {
    return Column(
      children: [
        Row(
          children: [
            TextfieldLabelSmall(label: TASK_MINIMUM_AGE_LABEL),
            minimumAgeTrackerVal != 0.0
                ? Text(
                    ' - ' + minimumAgeTrackerVal.round().toString(),
                    style: _themeData.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : SizedBox()
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            children: [
              Text(
                '7',
                style: _themeData.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: 80,
                  label: minimumAgeTrackerVal.round().toString(),
                  value: minimumAgeTrackerVal,
                  activeColor: PRIMARY_COLOR,
                  onChanged: (value) =>
                      setState(() => minimumAgeTrackerVal = value),
                ),
              ),
              Text(
                '80',
                style: _themeData.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
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
            2: segmentItem(TOGGLE_COMPLETE),
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
    _taskQualificationController.clear();
    _taskStartDateController.clear();
    _taskEndDateController.clear();
    _taskMembersController.clear();
  }
}
