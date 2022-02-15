import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/notification_bloc.dart';
import 'package:helpozzy/bloc/project_sign_up_bloc.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/project_sign_up_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

class VolunteerProjectTaskSignUp extends StatefulWidget {
  VolunteerProjectTaskSignUp({this.project, this.task, this.fromTask = false});
  final ProjectModel? project;
  final TaskModel? task;
  final bool fromTask;

  @override
  _VolunteerProjectTaskSignUpState createState() =>
      _VolunteerProjectTaskSignUpState(
        project: project,
        task: task,
        fromTask: fromTask,
      );
}

class _VolunteerProjectTaskSignUpState
    extends State<VolunteerProjectTaskSignUp> {
  _VolunteerProjectTaskSignUpState(
      {this.project, this.task, this.fromTask = false});
  final ProjectModel? project;
  final TaskModel? task;
  final bool fromTask;

  late SignUpAndUserModel userModel;
  late ThemeData _theme;
  late double height;
  late double width;
  final _formKey = GlobalKey<FormState>();
  final ProjectSignUpBloc _projectSignUpBloc = ProjectSignUpBloc();
  final NotificationBloc _notificationBloc = NotificationBloc();
  final TaskBloc _taskBloc = TaskBloc();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phnController = TextEditingController();

  Future getUserData() async {
    final String userData = prefsObject.getString(CURRENT_USER_DATA)!;
    final Map<String, dynamic> json =
        jsonDecode(userData) as Map<String, dynamic>;
    userModel = SignUpAndUserModel.fromJson(json: json);
    _nameController.text = userModel.name!;
    _emailController.text = userModel.email!;
    _addressController.text = userModel.address!;
    _cityController.text = userModel.city!;
    _stateController.text = userModel.state!;
    _zipCodeController.text = userModel.zipCode!;
    _phnController.text = userModel.personalPhnNo!;
  }

  Future projectSignUp() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      CircularLoader().show(context);
      final ProjectSignUpModel projectSignUpVal = ProjectSignUpModel(
        signUpUserId: prefsObject.getString(CURRENT_USER_ID),
        projectId: project!.projectId,
        name: _nameController.text,
        email: _emailController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        personalPhnNo: _phnController.text,
        zipCode: _zipCodeController.text,
      );
      final ResponseModel response =
          await _projectSignUpBloc.postVolunteerProjectSignUp(projectSignUpVal);

      if (response.success!) {
        CircularLoader().hide(context);
        await ScaffoldSnakBar().show(context, msg: response.message!);
        final NotificationModel notification = NotificationModel(
          type: 1,
          userTo: project!.projectOwner,
          userFrom: prefsObject.getString(CURRENT_USER_ID),
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Project Signed-Up',
          payload: projectSignUpVal.toJson(),
          subTitle:
              '${userModel.name} signed up in ${project!.projectName} for volunteering.',
        );

        final ResponseModel notificationResponse =
            await _notificationBloc.postNotification(notification);
        if (notificationResponse.success!) {
          Navigator.of(context).pop();
        } else {
          await ScaffoldSnakBar().show(context, msg: response.error!);
          Navigator.of(context).pop();
        }
      } else {
        CircularLoader().hide(context);
        await ScaffoldSnakBar().show(context, msg: response.error!);
      }
    }
  }

  Future taskSignUp() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      CircularLoader().show(context);
      final TaskModel taskSignUpVal = TaskModel(
        taskId: task!.taskId,
        signUpUserId: prefsObject.getString(CURRENT_USER_ID),
        projectId: project!.projectId,
        enrollTaskId: task!.enrollTaskId,
        taskOwnerId: task!.taskOwnerId,
        taskName: task!.taskName,
        description: task!.description,
        memberRequirement: task!.memberRequirement,
        ageRestriction: task!.ageRestriction,
        qualification: task!.qualification,
        startDate: task!.startDate,
        endDate: task!.endDate,
        estimatedHrs: task!.estimatedHrs,
        totalVolunteerHrs: task!.totalVolunteerHrs,
        members: task!.members,
        status: TOGGLE_NOT_STARTED,
        isApprovedFromAdmin: false,
      );
      final ResponseModel response =
          await _taskBloc.postEnrolledTask(taskSignUpVal);

      if (response.success!) {
        CircularLoader().hide(context);
        await ScaffoldSnakBar().show(context, msg: response.message!);
        final NotificationModel notification = NotificationModel(
          type: 0,
          userFrom: prefsObject.getString(CURRENT_USER_ID),
          userTo: task!.taskOwnerId,
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Task Request',
          payload: taskSignUpVal.toJson(),
          subTitle:
              "${userModel.name} want's to volunteer in the ${task!.taskName}"
              " of ${project!.projectName}",
        );

        final ResponseModel notificationResponse =
            await _notificationBloc.postNotification(notification);
        if (notificationResponse.success!) {
          Navigator.of(context).pop();
        } else {
          await ScaffoldSnakBar().show(context, msg: response.error!);
          Navigator.of(context).pop();
        }
      } else {
        CircularLoader().hide(context);
        await ScaffoldSnakBar().show(context, msg: response.error!);
      }
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(child: signUpForm()),
    );
  }

  Widget signUpForm() {
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            projectOrganizer(),
            titleWithIcon(
              hasIcon: true,
              title: CONTACT_PRO_LEAD,
              icons: Row(
                children: [
                  InkWell(
                    onTap: () async => await CommonUrlLauncher()
                        .launchCall(project!.contactNumber),
                    child: Icon(
                      CupertinoIcons.phone,
                      color: PRIMARY_COLOR,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      CupertinoIcons.chat_bubble,
                      color: PRIMARY_COLOR,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            scheduleTiming(),
            titleWithIcon(
                title: fromTask ? TASK_SIGNUP_APPBAR : PROJECT_SIGNUP_APPBAR),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      labelWithTopPadding(VOLUNTEER_NAME_LABEL),
                      CommonSimpleTextfield(
                        controller: _nameController,
                        hintText: ENTER_NAME_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your name';
                          } else if (val.length < 3) {
                            return 'Enter more than 3 char';
                          }
                          return null;
                        },
                      ),
                      labelWithTopPadding(VOLUNTEER_EMAIL_LABEL),
                      CommonSimpleTextfield(
                        controller: _emailController,
                        hintText: ENTER_EMAIL_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your email';
                          } else if (val.isNotEmpty &&
                              !EmailValidator.validate(val)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      labelWithTopPadding(VOLUNTEER_PHONE_LABEL),
                      CommonSimpleTextfield(
                        controller: _phnController,
                        maxLength: 10,
                        hintText: ENTER_PHONE_NUMBER_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your phone number';
                          } else if (val.isNotEmpty && val.length < 10) {
                            return 'Enter 10 digit number';
                          }
                          return null;
                        },
                      ),
                      labelWithTopPadding(ADDRESS_LABEL),
                      CommonSimpleTextfield(
                        controller: _addressController,
                        hintText: ADDRESS_HINT,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your address';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                labelWithTopPadding(CITY_LABEL),
                                CommonSimpleTextfield(
                                  controller: _cityController,
                                  hintText: ENTER_CITY_HINT,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter your city';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                labelWithTopPadding(STATE_LABEL),
                                CommonSimpleTextfield(
                                  controller: _stateController,
                                  hintText: ENTER_STATE_HINT,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter your state';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      labelWithTopPadding(ZIPCODE_LABEL),
                      CommonSimpleTextfield(
                        controller: _zipCodeController,
                        maxLength: 5,
                        hintText: ENTER_ZIP_CODE_HINT,
                        validator: (val) {
                          if (val!.isEmpty && val.length < 5) {
                            return 'Enter your zip code';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: 5, horizontal: width * 0.05),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonButton(
                      text: ENROLL_BUTTON,
                      onPressed: () async {
                        if (fromTask)
                          await taskSignUp();
                        else
                          await projectSignUp();
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CommonButton(
                      text: CANCEL_BUTTON,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleWithIcon({bool hasIcon = false, String? title, Widget? icons}) {
    return Container(
      color: SCREEN_BACKGROUND,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: _theme.textTheme.bodyText2!.copyWith(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          hasIcon ? icons! : SizedBox(),
        ],
      ),
    );
  }

  Widget projectOrganizer() {
    return Stack(
      children: [
        Container(
          height: height / 4,
          width: double.infinity,
          child: Image.asset(
            project!.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: height / 4,
          width: double.infinity,
          color: BLACK.withOpacity(0.3),
        ),
        Positioned(
          left: 10,
          top: 8,
          child: IconButton(
            iconSize: 18,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              CupertinoIcons.arrowshape_turn_up_left,
              color: WHITE,
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: fromTask ? 30 : 45,
          child: Container(
            width: width - 30,
            child: Text(
              fromTask ? task!.taskName! : project!.projectName,
              maxLines: 2,
              style: _theme.textTheme.headline6!.copyWith(
                color: WHITE,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: fromTask ? 15 : 28,
          child: Text(
            fromTask ? project!.projectName : project!.organization,
            maxLines: 2,
            style: _theme.textTheme.headline5!.copyWith(
              color: GRAY,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        !fromTask
            ? Positioned(
                bottom: 10,
                left: 18,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: project!.rating,
                      ignoreGestures: true,
                      minRating: 1,
                      itemSize: 14,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: WHITE,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: AMBER_COLOR,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Text(
                      ' (${project!.reviewCount} Reviews)',
                      style: _theme.textTheme.bodyText2!.copyWith(
                        color: WHITE,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        !fromTask
            ? Positioned(
                right: 17,
                bottom: 11,
                child: InkWell(
                  onTap: () {
                    setState(() => project!.isLiked = !project!.isLiked);
                  },
                  child: Icon(
                    project!.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: project!.isLiked ? Colors.red : WHITE,
                    size: 19,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget scheduleTiming() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.04),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fromTask ? TASK_CREATED_ON : PROJECT_CREATED_ON,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                    timeStamp:
                        fromTask ? task!.startDate! : project!.startDate),
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  color: BLUE_COLOR,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ESTIMATED_END_DATE,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                    timeStamp: fromTask ? task!.endDate! : project!.endDate),
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  color: BLUE_COLOR,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget labelWithTopPadding(String label) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.03),
      child: TextfieldLabelSmall(label: label),
    );
  }
}
