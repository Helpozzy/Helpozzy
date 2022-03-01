import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/projects/categorised_projects_list.dart';
import 'package:helpozzy/screens/profile/edit_profile.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _projectsBloc.getOwnCompletedProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return SafeArea(
      child: StreamBuilder<SignUpAndUserModel>(
        stream: _userInfoBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: LinearLoader());
          }
          final SignUpAndUserModel? user = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileSection(user!),
                      aboutMe(user),
                      projectPref(),
                    ],
                  ),
                ),
                ownProjectsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget profileSection(SignUpAndUserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 0.7, color: GRAY),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width * 0.04),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenView(imgUrl: user.profileUrl!),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 10, top: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: PRIMARY_COLOR.withOpacity(0.8),
              ),
              child: CommonUserProfileOrPlaceholder(
                size: width / 5,
                imgUrl: user.profileUrl!,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name!,
                      style: _theme.textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: DARK_GRAY,
                        size: 16,
                      ),
                    )
                  ],
                ),
                Text(
                  MEMBER_SYNC_LABEL +
                      DateFormatFromTimeStamp()
                          .dateFormatToMMMYYYY(timeStamp: user.joiningDate!),
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: DARK_GRAY_FONT_COLOR,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_outlined, size: 16),
                    SizedBox(width: 2),
                    Text(
                      '${user.reviewsByPersons} reviews',
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DARK_GRAY_FONT_COLOR,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Total volunteering hrs : 10 Hours',
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: DARK_GRAY_FONT_COLOR,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutMe(SignUpAndUserModel user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ABOUT_TEXT,
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              user.about!.isNotEmpty ? user.about! : ADD_NOW,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w600,
                color: user.about!.isNotEmpty ? PRIMARY_COLOR : BLUE_GRAY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget projectPref() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PROJECT_PREFRENCES_TEXT,
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          StreamBuilder<Projects>(
            stream: _projectsBloc.getCompletedProjectsStream,
            builder: (context, projectSnapshot) {
              if (!projectSnapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: LinearLoader()),
                );
              }
              late List<CategoryModel> availCategory = [];
              categoriesList.forEach((category) {
                projectSnapshot.data!.projectList.forEach((project) {
                  if (project.categoryId == category.id) {
                    availCategory.add(category);
                  }
                });
              });
              return Container(
                height: width * 0.25,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: availCategory.map((category) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorisedProjectsScreen(
                                categoryId: category.id!),
                          ),
                        );
                      },
                      child: Container(
                        width: width / 5.7,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              category.asset!,
                              fit: BoxFit.fill,
                              color: PRIMARY_COLOR,
                              height: width * 0.1,
                              width: width * 0.1,
                            ),
                            SizedBox(height: 5),
                            Text(
                              category.label!,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: _theme.textTheme.bodyText2!.copyWith(
                                fontSize: 10,
                                color: PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget ownProjectsList() {
    return StreamBuilder<Projects>(
      stream: _projectsBloc.getCompletedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _projectsBloc.getOwnCompletedProjects();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader()),
          );
        }
        final List<ProjectModel> projects = snapshot.data!.projectList;
        return Column(
          children: [
            ListDividerLabel(
              label: COMPLETED_PROJECT_TEXT,
              hasIcon: true,
              suffixIcon: Text(
                projects.length.toString(),
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final ProjectModel project = projects[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailsInfo(project: project),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: width * 0.05),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.projectName!,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    color: BLUE_GRAY,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  project.organization!,
                                  style: _theme.textTheme.bodyText2!
                                      .copyWith(color: DARK_GRAY),
                                ),
                                Text(
                                  DateFormatFromTimeStamp()
                                      .dateFormatToEEEDDMMMYYYY(
                                          timeStamp: project.startDate!),
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    color: DARK_BLUE,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CommonDivider(),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                      CommonDivider(),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
