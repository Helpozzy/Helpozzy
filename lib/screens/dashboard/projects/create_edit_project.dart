import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'project_task/create_edit_task.dart';
import 'project_task/task_widget.dart';
import 'project_task/tasks_screen.dart';

class CreateOrEditProject extends StatefulWidget {
  CreateOrEditProject({required this.fromEdit, this.project});
  final bool fromEdit;
  final ProjectModel? project;
  @override
  _CreateOrEditProjectState createState() =>
      _CreateOrEditProjectState(fromEdit: fromEdit, project: project);
}

class _CreateOrEditProjectState extends State<CreateOrEditProject> {
  _CreateOrEditProjectState({required this.fromEdit, this.project});
  final bool fromEdit;
  final ProjectModel? project;
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
  late ThemeData _themeData;
  late double width;
  late double height;
  late String? location = '';
  late int selectedCategoryId = 7;
  late int _selectedIndexValue = 0;
  late GooglePlace googlePlace;
  late List<AutocompletePrediction> predictions = [];
  late DetailsResult? detailsResult;
  late double latitude = 0.0;
  late double longitude = 0.0;
  late List<TaskModel> selectedItems = [];

  @override
  void initState() {
    _projectsBloc.getOtherUsersInfo();
    if (fromEdit) {
      listenProjectDetails();
    }
    googlePlace = GooglePlace(ANDROID_MAP_API_KEY);
    super.initState();
  }

  Future<void> autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() => predictions = result.predictions!);
    }
  }

  Future listenProjectDetails() async {
    _projNameController.text = project!.projectName!;
    _projDesController.text = project!.description!;
    selectedCategoryId = project!.categoryId!;
    _projCategoryController.text = selectedCategoryId == 0
        ? VOLUNTEER_0
        : selectedCategoryId == 1
            ? FOOD_BANK_1
            : selectedCategoryId == 2
                ? TEACHING_2
                : selectedCategoryId == 3
                    ? HOMELESS_SHELTER_3
                    : selectedCategoryId == 4
                        ? ANIMAL_CARE_4
                        : selectedCategoryId == 5
                            ? SENIOR_CENTER_5
                            : selectedCategoryId == 6
                                ? CHILDREN_AND_YOUTH_6
                                : OTHER_7;
    _selectedStartDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(project!.startDate!));
    _selectedEndDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(project!.endDate!));
    _projStartDateController.text =
        DateFormatFromTimeStamp().dateFormatToYMD(dateTime: _selectedStartDate);
    _projEndDateController.text =
        DateFormatFromTimeStamp().dateFormatToYMD(dateTime: _selectedEndDate);
    _selectedIndexValue = project!.status == TOGGLE_NOT_STARTED
        ? 0
        : project!.status == TOGGLE_INPROGRESS
            ? 1
            : 2;
    setState(() {});
  }

  Future onAddProject() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final String userData = prefsObject.getString(CURRENT_USER_DATA)!;
      final Map<String, dynamic> json =
          jsonDecode(userData) as Map<String, dynamic>;
      final currentUser = SignUpAndUserModel.fromJson(json: json);

      CircularLoader().show(context);
      final ProjectModel project = ProjectModel(
        categoryId: selectedCategoryId,
        aboutOrganizer: SAMPLE_LONG_TEXT,
        contactName: currentUser.name,
        contactNumber: currentUser.personalPhnNo,
        imageUrl: img(),
        location: location,
        projectLocationLati: latitude,
        projectLocationLongi: longitude,
        organization: '',
        rating: 0.0,
        reviewCount: 0,
        enrollmentCount: 0,
        projectName: _projNameController.text,
        description: _projDesController.text,
        startDate: _selectedStartDate.millisecondsSinceEpoch.toString(),
        endDate: _selectedEndDate.millisecondsSinceEpoch.toString(),
        ownerId: prefsObject.getString(CURRENT_USER_ID)!,
        collaboratorsCoadmin: _projCollaboraorController.text,
        status: _selectedIndexValue == 0
            ? TOGGLE_NOT_STARTED
            : _selectedIndexValue == 1
                ? TOGGLE_INPROGRESS
                : TOGGLE_COMPLETE,
             totalTaskshrs:0,
      );

      final ResponseModel response = fromEdit
          ? await _projectsBloc.updateProject(project)
          : await _projectsBloc.postProject(project);
      if (response.success!) {
        if (selectedItems.isNotEmpty) {
          for (int i = 0; i < selectedItems.length; i++) {
            selectedItems[i].projectId = response.returnValue;
            await _projectTaskBloc.updateTask(selectedItems[i]);
          }
        }
        await clearFields();
        CircularLoader().hide(context);
        Navigator.of(context).pop();
        ScaffoldSnakBar().show(
          context,
          msg: fromEdit
              ? PROJECT_UPDATED_SUCCESSFULLY_POPUP_MSG
              : PROJECT_CREATED_SUCCESSFULLY_POPUP_MSG,
        );
      } else {
        await clearFields();
        CircularLoader().hide(context);
        ScaffoldSnakBar().show(
          context,
          msg: fromEdit
              ? PROJECT_NOT_UPDATED_ERROR_POPUP_MSG
              : PROJECT_NOT_CREATED_ERROR_POPUP_MSG,
        );
      }
    }
  }

  String img() {
    final List<String> images = selectedCategoryId == 0
        ? volunteerProjectImage
        : selectedCategoryId == 1
            ? fooBankProjectImage
            : selectedCategoryId == 2
                ? teachingProjectImage
                : selectedCategoryId == 3
                    ? homelessSeleterProjectImage
                    : selectedCategoryId == 4
                        ? animalCareProjectImage
                        : selectedCategoryId == 5
                            ? seniorCenterProjectImage
                            : selectedCategoryId == 6
                                ? childrenYouthProjectImage
                                : otherProjectImage;
    int min = 0;
    int max = images.length - 1;
    Random rnd = Random();
    int r = min + rnd.nextInt(max - min);
    final String imageAsset = images[r].toString();
    return imageAsset;
  }

  Future<void> getDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      detailsResult = result.result!;
      location = detailsResult!.formattedAddress!;
      latitude = detailsResult!.geometry!.location!.lat!;
      longitude = detailsResult!.geometry!.location!.lng!;
      _projLocationController.clear();
      predictions.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(
        title: fromEdit ? EDIT_PROJECT_APPBAR : CREATE_PROJECT_APPBAR,
        actions: [
          IconButton(
            onPressed: () {
              onAddProject();
            },
            icon: Icon(
              Icons.check_rounded,
              color: DARK_PINK_COLOR,
            ),
          )
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
                  maxLines: 3,
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
              projectLocationView(),
              Divider(),
              taskWidget(),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.03,
                  horizontal: width * 0.05,
                ),
                child: TextfieldLabelSmall(label: STATUS_LABEL),
              ),
              statusSegmentation(),
              fromEdit ? SizedBox() : Divider(),
              fromEdit
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.03, left: width * 0.05),
                      child: TextfieldLabelSmall(
                          label: PROJECT_INVITE_COLLABORATOR_LABEL),
                    ),
              fromEdit
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: inviteCollaborators(),
                    ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: width * 0.03, left: width * 0.05),
                child: TextfieldLabelSmall(label: TIMELINE_LABEL),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: startDateAndEndDateSection(),
              ),
              Divider(),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.2, vertical: width * 0.03),
                child: CommonButton(
                  text: fromEdit ? SAVE_BUTTON : PUBLISH_PROJECT_BUTTON,
                  onPressed: () async {
                    await onAddProject();
                  },
                ),
              ),
            ],
          ),
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

  Widget projectLocationView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SimpleFieldWithLabel(
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: PRIMARY_COLOR,
              size: 18,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                longitude = 0.0;
                latitude = 0.0;
                predictions.clear();
                location = '';
                _projLocationController.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.close,
                color: PRIMARY_COLOR,
                size: 18,
              ),
            ),
            label: PROJECT_LOCATION_LABEL,
            controller: _projLocationController,
            hintText: PROJECT_LOCATION_HINT,
            validator: (val) => null,
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
            return GestureDetector(
              onTap: () => getDetails(predictions[index].placeId!),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: width * 0.06),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        predictions[index].description!,
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        project != null && project!.location!.isNotEmpty
            ? locationCard(project!.location!)
            : location != null && location!.isNotEmpty
                ? locationCard(location!)
                : SizedBox(),
      ],
    );
  }

  Widget locationCard(String address) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: width * 0.05),
      child: Card(
        elevation: 0,
        color: GRAY,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: width * 0.05,
          ),
          title: Text(
            LOCATION,
            style: _themeData.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            address,
            style: _themeData.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: DARK_GRAY,
            ),
          ),
          trailing: Icon(
            CupertinoIcons.map_pin_ellipse,
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }

  Widget taskWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: width * 0.03, horizontal: width * 0.05),
          child: TextfieldLabelSmall(label: TASKS_LABEL),
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
                        builder: (context) => CreateEditTask(fromEdit: false)),
                  );
                  await _projectTaskBloc.getProjectAllTasks('');
                },
              ),
              TextButton(
                onPressed: () async {
                  selectedItems = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TasksScreen(),
                    ),
                  );
                  if (selectedItems.isNotEmpty) {
                    selectedTaskBloc.getSelectedTasks(tasks: selectedItems);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.list_bullet, color: PURPLE_BLUE_COLOR),
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
      ],
    );
  }

  Widget projectCategoryDropdown() {
    return Column(
      children: [
        SizedBox(height: width * 0.05),
        TextfieldLabelSmall(label: PROJECT_CATEGORY_LABEL),
        DropdownButtonFormField<CategoryModel>(
          decoration: inputSimpleDecoration(getHint: SELECT_CATEGORY_HINT),
          icon: Icon(Icons.expand_more_rounded),
          validator: (val) {
            if (val != null && _projCategoryController.text.isEmpty) {
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
