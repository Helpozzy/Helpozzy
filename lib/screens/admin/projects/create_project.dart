import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
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
  final TextEditingController _projNameController = TextEditingController();
  final TextEditingController _projDesController = TextEditingController();
  final TextEditingController _projStartDateController =
      TextEditingController();
  final TextEditingController _projEndDateController = TextEditingController();
  final TextEditingController _projCategoryController = TextEditingController();
  final TextEditingController _projCollaboraorController =
      TextEditingController();
  final TextEditingController _searchEmailController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  late double height;

  @override
  void initState() {
    _projectTaskBloc.getSelectedTasks(taskIds: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
          title: CREATE_PROJECT_APPBAR,
          color: WHITE,
          textColor: DARK_PINK_COLOR,
          elevation: 1),
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
                    child: SimpleFieldWithLabel(
                      label: PROJECT_CATEGORY_LABEL,
                      controller: _projCategoryController,
                      hintText: PROJECT_CATEGORY_HINT,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter category';
                        }
                        return null;
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.03, horizontal: width * 0.05),
                    child: SmallInfoLabel(label: 'Tasks'),
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
                            final List<String> tasks = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TasksScreen(),
                              ),
                            );
                            if (tasks.isNotEmpty) {
                              await _projectTaskBloc.getSelectedTasks(
                                  taskIds: tasks);
                            }
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

  Widget inviteCollaborators() {
    return Column(
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
            appImageButton(
              onPressed: () => CommonUrlLauncher().launchInstagram(),
              asset: 'instagram.png',
            ),
            appImageButton(
              onPressed: () => CommonUrlLauncher().launchWhatsapp(),
              asset: 'whatsapp.png',
            ),
            appImageButton(
              onPressed: () {},
              asset: 'twitter.png',
            ),
            appImageButton(
              onPressed: () {},
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
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconButton appImageButton(
      {required void Function()? onPressed, required String asset}) {
    return IconButton(
        onPressed: onPressed, icon: Image.asset('assets/images/$asset'));
  }

  Widget taskList() {
    return StreamBuilder<Tasks>(
      stream: _projectTaskBloc.getSelectedTaskStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LinearLoader(minheight: 13),
          );
        }
        return snapshot.data!.tasks.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.tasks.length,
                itemBuilder: (context, index) {
                  final TaskModel task = snapshot.data!.tasks[index];
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
    final ProjectModel project = ProjectModel(
      projectId: '',
      projectName: _projNameController.text,
      description: _projDesController.text,
      startDate: _projStartDateController.text,
      endDate: _projEndDateController.text,
      projectOwner: _projCategoryController.text,
      collaboratorsCoadmin: _projCollaboraorController.text,
      category: prefsObject.getString('uID')!,
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
  }
}
