import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

import 'project_task/create_edit_task.dart';
import 'project_task/task_widget.dart';
import 'project_task/tasks_screen.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  ProjectsBloc _projectsBloc = ProjectsBloc();
  ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  ProjectTaskBloc selectedTaskBloc = ProjectTaskBloc();
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
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);
  late ThemeData _themeData;
  late double width;
  late double height;
  late int selectedCategoryId;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late DetailsResult? detailsResult;

  @override
  void initState() {
    _projectsBloc.getOtherUsersInfo();
    String? apiKey = 'AIzaSyCLWAG1kDcGh8S8ac0RdyIhKUgS8jdQ64g';
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  Future<void> autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
        _projLocationController.text = detailsResult!.formattedAddress!;
      });
      predictions.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(title: CREATE_PROJECT_APPBAR),
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
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: PRIMARY_COLOR,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => _projLocationController.clear(),
                          icon: Icon(
                            Icons.close,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                        label: PROJECT_LOCATION_LABEL,
                        controller: _projLocationController,
                        hintText: PROJECT_LOCATION_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter Search';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            autoCompleteSearch(val);
                          } else {
                            if (predictions.length > 0 && mounted) {
                              setState(() => predictions = []);
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            CupertinoIcons.location,
                            color: PRIMARY_COLOR,
                          ),
                          title: Text(predictions[index].description!),
                          onTap: () => getDetails(predictions[index].placeId!),
                        );
                      },
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
                              await _projectTaskBloc.getProjectAllTasks('');
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
                                  style: _themeData.textTheme.bodyText2!
                                      .copyWith(
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
                      padding: EdgeInsets.only(
                          top: width * 0.03, left: width * 0.05),
                      child: SmallInfoLabel(
                          label: PROJECT_INVITE_COLLABORATOR_LABEL),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: inviteCollaborators(),
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
      ),
    );
  }

  Widget projectCategoryDropdown() {
    return Column(
      children: [
        SizedBox(height: width * 0.05),
        SmallInfoLabel(label: PROJECT_CATEGORY_LABEL),
        DropdownButtonFormField<CategoryModel>(
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
              _projCategoryController.text = newValue!.label!;
              selectedCategoryId = newValue.id!;
            });
          },
          items: categoriesList
              .map<DropdownMenuItem<CategoryModel>>((CategoryModel value) {
            return DropdownMenuItem<CategoryModel>(
              value: value,
              child: Text(
                value.label!.replaceAll('\n', ' ').replaceAll(' ', ' '),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget inviteCollaborators() {
    return Column(
      children: [
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CommonSimpleTextfield(
                controller: _searchEmailController,
                hintText: PROJECT_SEARCH_WITH_EMAIL_HINT,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: BLACK,
                ),
                validator: (val) => null,
                onChanged: (val) => _projectsBloc.searchUsers(val),
              ),
            ),
            TextButton(
              onPressed: () => CommonUrlLauncher()
                  .shareToOtherApp(subject: 'Test share text!'),
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
          ],
        ),
        expandSearchUserList()
      ],
    );
  }

  Widget expandSearchUserList() {
    return StreamBuilder<List<SignUpAndUserModel>>(
      stream: _projectsBloc.getOtherUsersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: LinearLoader(),
          );
        }
        final List<SignUpAndUserModel> users = snapshot.data!;
        return _searchEmailController.text.isNotEmpty && users.isNotEmpty
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
                        _searchEmailController.text = users[index].email!;
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
                                  users[index].name!,
                                  style: _themeData.textTheme.bodyText2!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  users[index].email!,
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
                    task: task,
                    onTapItem: () =>
                        setState(() => task.isSelected = !task.isSelected!),
                    selected: task.isSelected!,
                    optionEnable: false,
                    eventButton: SizedBox(),
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

  Future onAddProject() async {
    CircularLoader().show(context);

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
      enrollmentCount: 0,
      projectName: _projNameController.text,
      description: _projDesController.text,
      startDate: DateTime.parse(_projStartDateController.text)
          .millisecondsSinceEpoch
          .toString(),
      endDate: DateTime.parse(_projEndDateController.text)
          .millisecondsSinceEpoch
          .toString(),
      projectOwner: prefsObject.getString(CURRENT_USER_ID)!,
      collaboratorsCoadmin: _projCollaboraorController.text,
      status: TOGGLE_NOT_STARTED,
    );

    final bool isUploaded = await _projectsBloc.postProject(project);
    if (isUploaded) {
      await clearFields();
      CircularLoader().hide(context);
      ScaffoldSnakBar()
          .show(context, msg: PROJECT_CREATED_SUCCESSFULLY_POPUP_MSG);
    } else {
      await clearFields();
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: PROJECT_NOT_CREATED_ERROR_POPUP_MSG);
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
    _projEndDateController.clear();
  }
}
