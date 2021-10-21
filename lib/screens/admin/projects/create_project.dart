import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/screens/admin/projects/tasks/task_widget.dart';
import 'package:helpozzy/screens/admin/projects/tasks/tasks_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:intl/intl.dart';
import 'tasks/create_edit_task.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  AdminProjectsBloc _adminProjectsBloc = AdminProjectsBloc();
  ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  ProjectTaskBloc selectedTaskBloc = ProjectTaskBloc();
  final CategoryBloc _categoryBloc = CategoryBloc();
  final TextEditingController _projNameController = TextEditingController();
  final TextEditingController _projDesController = TextEditingController();
  final TextEditingController _projLocationController = TextEditingController();
  final TextEditingController _projStartDateController =
      TextEditingController();
  final TextEditingController _projEndDateController = TextEditingController();
  final TextEditingController _projCategoryController = TextEditingController();
  final TextEditingController _projCollaboraorController =
      TextEditingController();
  final TextEditingController _searchEmailController = TextEditingController();
  final TextEditingController _projTaskStartHrsController =
      TextEditingController();
  final TextEditingController _projTaskEndHrsController =
      TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  late double height;
  late int selectedCategoryId;

  @override
  void initState() {
    _categoryBloc.getCategories();
    _adminProjectsBloc.getOtherUsersInfo();
    _adminProjectsBloc.searchUsers('');
    super.initState();
  }

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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SimpleFieldWithLabel(
                      label: PROJECT_NAME_LABEL,
                      controller: _projNameController,
                      hintText: PROJECT_NAME_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SimpleFieldWithLabel(
                      label: PROJECT_DESCRIPTION_LABEL,
                      controller: _projDesController,
                      hintText: PROJECT_DESCRIPTION_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project description';
                        }
                        return null;
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: projectCategoryDropdown(),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SimpleFieldWithLabel(
                      label: PROJECT_LOCATION_LABEL,
                      controller: _projLocationController,
                      hintText: PROJECT_LOCATION_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter project location';
                        }
                        return null;
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.03, horizontal: width * 0.05),
                    child: SmallInfoLabel(label: TASKS_LABEL),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButtonWithIcon(
                          icon: Icons.add,
                          text: ADD_NEW_TASK_BUTTON,
                          fontSize: 12,
                          iconSize: 15,
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      CreateEditTask(fromEdit: false)),
                            );
                            await _projectTaskBloc.getTasks();
                          },
                        ),
                        TextButton(
                          onPressed: () async {
                            selectedTaskBloc = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TasksScreen(),
                              ),
                            );
                            setState(() {});
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.list_bullet,
                                  color: PURPLE_BLUE_COLOR),
                              SizedBox(width: 5),
                              Text(
                                TASK_LIST_BUTTON,
                                style: _themeData.textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: PURPLE_BLUE_COLOR),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: taskList(),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        EdgeInsets.only(top: width * 0.03, left: width * 0.05),
                    child: SmallInfoLabel(
                        label: PROJECT_INVITE_COLLABORATOR_LABEL),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: inviteCollaborators(),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        EdgeInsets.only(top: width * 0.03, left: width * 0.05),
                    child: SmallInfoLabel(label: TIMELINE_LABEL),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: startDateAndEndDateSection(),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.03, horizontal: width * 0.05),
                    child: SmallInfoLabel(label: HOURS_LABEL),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: projectHours(),
                  ),
                  Divider(),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.2, vertical: width * 0.03),
            child: CommonButton(
              text: PUBLISH_PROJECT_BUTTON,
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
    );
  }

  Widget projectHours() {
    return Row(
      children: [
        Expanded(
          child: CommonSimpleTextfield(
            readOnly: true,
            controller: _projTaskStartHrsController,
            hintText: PROJECT_START_TIME_HINT,
            validator: (val) {
              if (val!.isEmpty && _projTaskStartHrsController.text.isEmpty) {
                return 'Select start time';
              }
              return null;
            },
            onTap: () {
              CommonDatepicker()
                  .showTimePickerDialog(context,
                      selectedTime: selectedStartTime)
                  .then((selectedTimeVal) {
                if (selectedTimeVal != null)
                  setState(() {
                    selectedStartTime = selectedTimeVal;
                  });
                _projTaskStartHrsController.value = TextEditingValue(
                    text:
                        '${selectedStartTime.hour}.${selectedStartTime.minute}');
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
            controller: _projTaskEndHrsController,
            hintText: PROJECT_END_TIME_HINT,
            validator: (val) {
              if (val!.isEmpty && _projTaskEndHrsController.text.isEmpty) {
                return 'Select end time';
              }
              return null;
            },
            onTap: () {
              CommonDatepicker()
                  .showTimePickerDialog(context, selectedTime: selectedEndTime)
                  .then((selectedTimeVal) {
                if (selectedTimeVal != null)
                  setState(() {
                    selectedEndTime = selectedTimeVal;
                  });
                _projTaskEndHrsController.value = TextEditingValue(
                    text: '${selectedEndTime.hour}.${selectedEndTime.minute}');
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.watch_later_outlined)
      ],
    );
  }

  Widget projectCategoryDropdown() {
    return Column(
      children: [
        SizedBox(height: width * 0.05),
        SmallInfoLabel(label: PROJECT_CATEGORY_LABEL),
        StreamBuilder<Categories>(
          stream: _categoryBloc.getCategoriesStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: LinearLoader(minheight: 12)),
              );
            }
            return DropdownButtonFormField<CategoryModel>(
              decoration: inputSimpleDecoration(getHint: SELECT_CATEGORY_HINT),
              icon: Icon(Icons.expand_more_outlined),
              validator: (val) {
                if (_projCategoryController.text.isEmpty) {
                  return 'Select any category';
                }
                return null;
              },
              isExpanded: false,
              onChanged: (CategoryModel? newValue) {
                setState(() {
                  _projCategoryController.text = newValue!.label;
                  selectedCategoryId = newValue.id;
                });
              },
              items: snapshot.data!.item
                  .map<DropdownMenuItem<CategoryModel>>((CategoryModel value) {
                return DropdownMenuItem<CategoryModel>(
                  value: value,
                  child: Text(
                    value.label.replaceAll('\n', ' ').replaceAll(' ', ' '),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget inviteCollaborators() {
    return Column(
      children: [
        TextButton(
          onPressed: () =>
              CommonUrlLauncher().shareToOtherApp(subject: 'Test share text!'),
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
            appImageButton(
              onPressed: () => CommonUrlLauncher().launchApp(
                androidPackageName: 'com.instagram.android',
                iosUrlScheme: 'instagram://',
                subject: 'Test share text!',
              ),
              asset: 'instagram.png',
            ),
            appImageButton(
              onPressed: () => CommonUrlLauncher().launchApp(
                androidPackageName: 'com.whatsapp',
                iosUrlScheme: 'whatsapp://',
                subject: 'Test share text!',
              ),
              asset: 'whatsapp.png',
            ),
            appImageButton(
              onPressed: () => CommonUrlLauncher().launchApp(
                androidPackageName: 'com.twitter.android',
                iosUrlScheme: 'twitter://',
                subject: 'Test share text!',
              ),
              asset: 'twitter.png',
            ),
            appImageButton(
              onPressed: () => CommonUrlLauncher().launchApp(
                androidPackageName: 'com.snapchat.android',
                iosUrlScheme: 'snapchat://',
                subject: 'Test share text!',
              ),
              asset: 'snapchat.png',
            ),
          ],
        ),
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
                onChanged: (val) {
                  _adminProjectsBloc.searchUsers(val);
                },
              ),
            ),
          ],
        ),
        expandSearchUserList()
      ],
    );
  }

  Widget expandSearchUserList() {
    return StreamBuilder<dynamic>(
      stream: _adminProjectsBloc.getSearchedUsersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: LinearLoader(minheight: 13),
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
                    top: 10.0,
                    bottom: 6,
                    left: width * 0.09,
                    right: width * 0.01,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _searchEmailController.text = users[index].email;
                        _adminProjectsBloc.searchUsers('');
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

  IconButton appImageButton(
      {required void Function()? onPressed, required String asset}) {
    return IconButton(
        onPressed: onPressed, icon: Image.asset('assets/images/$asset'));
  }

  Widget taskList() {
    return StreamBuilder<List<TaskModel>>(
      stream: selectedTaskBloc.getSelectedTaskStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: SizedBox());
        }
        return snapshot.data!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final TaskModel task = snapshot.data![index];
                  return TaskCard(
                    title: task.taskName,
                    description: task.description,
                    optionEnable: false,
                  );
                },
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
                if (pickedDate != null && pickedDate != _selectedStartDate)
                  setState(() {
                    _selectedStartDate = pickedDate;
                  });
                _projStartDateController.value = TextEditingValue(
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
            controller: _projEndDateController,
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
                _projEndDateController.value = TextEditingValue(
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

  Future onAddProject() async {
    CircularLoader().show(context);
    double startTime = timeConvertToDouble(selectedStartTime);
    double endTime = timeConvertToDouble(selectedEndTime);
    double hrsDiff = endTime - startTime;
    final ProjectModel project = ProjectModel(
      projectId: '',
      categoryId: selectedCategoryId,
      aboutOrganizer: '',
      contactName: '',
      contactNumber: '',
      imageUrl: '',
      location: '',
      organization: '',
      rating: 0.0,
      reviewCount: 0,
      hours: hrsDiff,
      projectName: _projNameController.text,
      description: _projDesController.text,
      startDate: DateTime.parse(_projStartDateController.text)
          .millisecondsSinceEpoch
          .toString(),
      endDate: DateTime.parse(_projEndDateController.text)
          .millisecondsSinceEpoch
          .toString(),
      projectOwner: prefsObject.getString('uID')!,
      collaboratorsCoadmin: _projCollaboraorController.text,
      status: PROJECT_NOT_STARTED,
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
    _projCategoryController.clear();
    _projCollaboraorController.clear();
    _searchEmailController.clear();
    _projLocationController.clear();
    _projTaskStartHrsController.clear();
    _projEndDateController.clear();
  }
}
