import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/admin/members/members.dart';
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
  final TextEditingController _searchEmailController = TextEditingController();
  final TextEditingController _estimatedHoursController =
      TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late List<PlatformFile> pickedFiles = [];
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  late double height;
  ProjectsBloc _projectsBloc = ProjectsBloc();
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  late double hrsTrackerVal = 0.0;
  late double noOfMemberTrackerVal = 0.0;
  late double minimumAgeTrackerVal = 7.0;
  int _selectedIndexValue = 0;
  bool postOnLocalCheck = false;

  @override
  void initState() {
    if (fromEdit) retriveTaskDetails();
    _projectsBloc.getOtherUsersInfo();
    _projectsBloc.searchUsers('');
    super.initState();
  }

  Future retriveTaskDetails() async {
    _taskNameController.text = task!.taskName;
    _taskDesController.text = task!.description;
    if (task!.estimatedHrs < 10) {
      hrsTrackerVal = double.parse(task!.estimatedHrs.toString());
    } else {
      _estimatedHoursController.text = task!.estimatedHrs.toString();
    }
    noOfMemberTrackerVal = double.parse(task!.memberRequirement.toString());
    minimumAgeTrackerVal = double.parse(task!.ageRestriction.toString());
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
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(
        elevation: 0,
        title: fromEdit ? EDIT_TASK_APPBAR : CREATE_TASK_APPBAR,
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
                      child: SmallInfoLabel(label: HOURS_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: hoursSlider(),
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
                      padding: EdgeInsets.only(
                        top: width * 0.03,
                        left: width * 0.05,
                        bottom: width * 0.03,
                      ),
                      child: SmallInfoLabel(label: STATUS_LABEL),
                    ),
                    statusSegmentation(),
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
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 6),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Icon(
                CupertinoIcons.search,
                color: BLACK,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: CommonSimpleTextfield(
                controller: _searchEmailController,
                hintText: PROJECT_SEARCH_WITH_EMAIL_HINT,
                validator: (val) {},
                onChanged: (val) {
                  _projectsBloc.searchUsers(val);
                },
              ),
            ),
          ],
        ),
        expandSearchUserList(),
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

  Widget expandSearchUserList() {
    return StreamBuilder<dynamic>(
      stream: _projectsBloc.getSearchedUsersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: LinearLoader(),
          );
        }
        final List<dynamic> users = snapshot.data;
        return users.isNotEmpty
            ? PreferredSize(
                preferredSize: Size(width, height),
                child: ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    top: 6.0,
                    bottom: 6,
                    left: width * 0.09,
                    right: width * 0.01,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _searchEmailController.text = users[index].email;
                        _projectsBloc.searchUsers('');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  users[index].name,
                                  style: _themeData.textTheme.bodyText2!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  users[index].email,
                                  style: _themeData.textTheme.bodyText2!
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
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
                  .showDatePickerDialog(context,
                      initialDate: _selectedStartDate)
                  .then((pickedDate) {
                if (pickedDate != null && pickedDate != _selectedStartDate)
                  setState(() {
                    _selectedStartDate = pickedDate;
                  });
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
                  .showDatePickerDialog(context, initialDate: _selectedEndDate)
                  .then((pickedDate) {
                if (pickedDate != null && pickedDate != _selectedEndDate)
                  setState(() {
                    _selectedEndDate = pickedDate;
                  });
                _taskEndDateController.value = TextEditingValue(
                    text: DateFormatFromTimeStamp()
                        .dateFormatToYMD(dateTime: _selectedEndDate));
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

  Future addOrUpdateData() async {
    CircularLoader().show(context);
    final TaskModel taskDetails = TaskModel(
      projectId: '',
      ownerId: prefsObject.getString(CURRENT_USER_ID)!,
      id: fromEdit ? task!.id : '',
      taskName: _taskNameController.text,
      description: _taskDesController.text,
      memberRequirement: noOfMemberTrackerVal.round(),
      ageRestriction: minimumAgeTrackerVal.round(),
      qualification: _taskQualificationController.text,
      startDate: DateTime.parse(_taskStartDateController.text)
          .millisecondsSinceEpoch
          .toString(),
      endDate: DateTime.parse(_taskEndDateController.text)
          .millisecondsSinceEpoch
          .toString(),
      estimatedHrs: hrsTrackerVal.round(),
      totalVolunteerHrs: 0,
      members: _taskMembersController.text,
      status: _selectedIndexValue == 0
          ? TOGGLE_NOT_STARTED
          : _selectedIndexValue == 1
              ? TOGGLE_INPROGRESS
              : TOGGLE_COMPLETE,
    );
    final bool isUploaded = fromEdit
        ? await _projectTaskBloc.updateTasks(taskDetails)
        : await _projectTaskBloc.postTasks(taskDetails);
    if (isUploaded) {
      if (!fromEdit) await clearFields();
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(
        context,
        msg: fromEdit
            ? TASK_UPDATED_SUCCESSFULLY_POPUP_MSG
            : TASK_CREATED_SUCCESSFULLY_POPUP_MSG,
      );
    } else {
      if (!fromEdit) await clearFields();
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(
        context,
        msg: fromEdit
            ? TASK_NOT_UPDATED_ERROR_POPUP_MSG
            : TASK_NOT_CREATED_ERROR_POPUP_MSG,
      );
    }
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
