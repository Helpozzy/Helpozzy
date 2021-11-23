import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/tasks/task_widget.dart';
import 'package:helpozzy/screens/user/explore/user_project/project_task/task_details.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_sign_up.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class ProjectDetailsScreen extends StatefulWidget {
  ProjectDetailsScreen({required this.project});
  final ProjectModel project;
  @override
  _ProjectDetailsScreenState createState() =>
      _ProjectDetailsScreenState(project: project);
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  _ProjectDetailsScreenState({required this.project});
  final ProjectModel project;
  late double height;
  late double width;
  late ThemeData _theme;
  TextEditingController _reviewController = TextEditingController();
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  UserInfoBloc _userInfoBloc = UserInfoBloc();

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString('uID')!);
    _projectTaskBloc.getProjectTasks(project.projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    projectOrganizer(),
                    aboutOraganizer(),
                    overviewDetails(),
                    projectDetails(),
                    scheduleTimeAndLocation(),
                    infoSection(),
                    tasksOfProject(),
                    reviewSection(),
                    reviewCard(),
                    reviewList(),
                  ],
                ),
              ),
            ),
            Container(
              height: 43,
              width: width,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: width / 4),
              child: CommonButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectUserSignUpScreen(),
                    ),
                  );
                },
                text: SIGN_UP,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget projectOrganizer() {
    return Stack(
      children: [
        Container(
          height: height / 3,
          width: double.infinity,
          child: Image.asset(
            project.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: height / 3,
          width: double.infinity,
          color: BLUR_GRAY,
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
          bottom: 33,
          child: Text(
            project.organization,
            maxLines: 2,
            style: _theme.textTheme.headline6!
                .copyWith(color: WHITE, fontSize: 22),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 18,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: project.rating,
                ignoreGestures: true,
                minRating: 1,
                itemSize: 18,
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
                '(${project.reviewCount} Reviews)',
                style: _theme.textTheme.bodyText2!.copyWith(
                  color: WHITE,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 17,
          bottom: 11,
          child: InkWell(
            onTap: () {
              setState(() {
                project.isLiked = !project.isLiked;
              });
            },
            child: Icon(
              project.isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: project.isLiked ? Colors.red : DARK_GRAY,
              size: 19,
            ),
          ),
        )
      ],
    );
  }

  Widget aboutOraganizer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEE, dd MMM - yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(project.startDate),
              ),
            ),
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 16,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            project.projectName,
            style: _theme.textTheme.headline6!.copyWith(
              color: BLUE_GRAY,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              ABOUT_ORGANIZER,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              project.aboutOrganizer,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 12,
                fontFamily: QUICKSAND,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget overviewDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OVERVIEW,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          overViewTile(
            icon: Icons.verified_outlined,
            text: 'Verified Non-Profit Organization',
          ),
          overViewTile(
            icon: Icons.schedule_rounded,
            text: '23 yrs in Service',
          ),
          overViewTile(
            icon: Icons.people_outlined,
            text: '15 Employees',
          ),
          overViewTile(
            icon: Icons.emoji_people_outlined,
            text: '75 Routine Volunteers',
          ),
        ],
      ),
    );
  }

  Widget overViewTile({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, size: 15),
          SizedBox(width: 7),
          Text(
            text,
            style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget projectDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              PROJECT_DETAILS,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              project.description,
              style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleTimeAndLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SCHEDULES,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Thu , Dec 31 2020 10:30 AM - 4:30 PM',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '(Schedules are allocated on slots basics)',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            DIRECTION,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.directions_car_filled_outlined,
                size: 15,
                color: DARK_GRAY,
              ),
              SizedBox(width: 5),
              Text(
                '12 mins drive',
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  color: DARK_GRAY,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '3.2 mil',
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  color: DARK_GRAY,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '7600 Amador Valley Blvd, Dublin, CA 94568',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Contact Dublin Senior Center',
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.call_outlined,
                  size: 15,
                  color: DARK_GRAY,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.messenger_outline_rounded,
                    size: 15,
                    color: DARK_GRAY,
                  ),
                ),
              ],
            ),
          ),
          CommonDivider(),
        ],
      ),
    );
  }

  Widget infoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            INFO,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          infoMenu(
            icon: Icons.language_rounded,
            text: 'Visit Website',
          ),
          infoMenu(
            icon: Icons.image_outlined,
            text: 'Project Photos',
          ),
        ],
      ),
    );
  }

  Widget infoMenu({required String text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            text,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Icon(
            icon,
            size: 16,
            color: DARK_GRAY,
          ),
        ],
      ),
    );
  }

  Widget tasksOfProject() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TASKS,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<Tasks>(
            stream: _projectTaskBloc.getProjectTasksStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: width * 0.04),
                  child: LinearLoader(minheight: 12),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data!.tasks.length,
                itemBuilder: (context, index) {
                  final TaskModel task = snapshot.data!.tasks[index];
                  return TaskCard(
                    task: task,
                    optionEnable: false,
                    onTapItem: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetails(task: task)),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget reviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            REVIEWS,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Volunteers rated this non-profit highly for the work\nResponsiveness and professionalism',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewCard() {
    return StreamBuilder<SignUpAndUserModel>(
      stream: _userInfoBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LinearLoader(minheight: 12),
          );
        }
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: width * 0.04),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CommonUserPlaceholder(size: 30),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.name!,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!.address!,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 12,
                            color: DARK_GRAY,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    itemSize: 18,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    unratedColor: LIGHT_GRAY,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: AMBER_COLOR),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                Container(
                  height: 35,
                  width: width / 2,
                  child: TextField(
                    style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                    controller: _reviewController,
                    decoration: reviewFieldDecoration(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration reviewFieldDecoration() {
    return InputDecoration(
      hintText: REVIEW_HINT,
      contentPadding: EdgeInsets.only(bottom: 10.0),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      hintStyle:
          _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY, fontSize: 12),
    );
  }

  Widget reviewList() {
    final snapShot = Reviews(list: reviewData);
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: snapShot.reviews.length,
      itemBuilder: (context, index) {
        final ReviewModel review = snapShot.reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommonUserPlaceholder(size: 30),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        review.address,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: DARK_GRAY,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: RatingBar.builder(
                  initialRating: review.rating,
                  ignoreGestures: true,
                  minRating: 1,
                  itemSize: 18,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: LIGHT_GRAY,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AMBER_COLOR,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              review.reviewText != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        review.reviewText,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: DARK_GRAY_FONT_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SizedBox(),
              CommonDivider(),
            ],
          ),
        );
      },
    );
  }
}
