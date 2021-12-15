import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/screens/user/explore/user_project/categorised_projects_list.dart';
import 'package:helpozzy/screens/projects/user_project_tabs/other_details_tab.dart';
import 'package:helpozzy/screens/user/profile/edit_profile.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final CategoryBloc _categoryBloc = CategoryBloc();
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString('uID')!);
    _categoryBloc.getCategories();
    _userProjectsBloc.getOwnCompletedProjects();
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
            return Center(
              child: LinearLoader(minheight: 15),
            );
          }
          final SignUpAndUserModel? user = snapshot.data;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenView(
                                        imgUrl: user!.profileUrl!),
                                  ),
                                ),
                                child: Container(
                                  margin:
                                      EdgeInsets.only(bottom: 10, top: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: PRIMARY_COLOR.withOpacity(0.8),
                                  ),
                                  child: CommonUserProfileOrPlaceholder(
                                    size: width / 5,
                                    imgUrl: user!.profileUrl!,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                user.name!,
                                style: _theme.textTheme.headline6!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.people_alt_outlined, size: 16),
                                    SizedBox(width: 2),
                                    Text(
                                      '${user.reviewsByPersons} review',
                                      style:
                                          _theme.textTheme.bodyText2!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: DARK_GRAY_FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('MMM yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(user.joiningDate!),
                                    ),
                                  ),
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: DARK_GRAY_FONT_COLOR,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '10 Hours',
                                      style:
                                          _theme.textTheme.bodyText2!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: DARK_GRAY_FONT_COLOR,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 14)
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 6.0, bottom: 6.0, right: 3.0),
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen(user: user),
                                    ),
                                  );
                                },
                                child: Text(
                                  EDIT_PROFILE_TEXT,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: BLUE_GRAY,
                                  ),
                                ),
                              ),
                            ),
                            CommonDividerWithVal(
                              height: 1,
                              color: DARK_GRAY,
                            ),
                            address(user),
                            CommonDividerWithVal(
                              height: 1,
                              color: DARK_GRAY,
                            ),
                            aboutMe(user),
                            CommonDividerWithVal(
                              height: 1,
                              color: DARK_GRAY,
                            ),
                            projectPref(),
                          ],
                        ),
                      ),
                      ownProjectsList(),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.1),
                width: double.infinity,
                child: CommonButton(
                  text: LOGOUT_BUTTON,
                  onPressed: () async {
                    Provider.of<AuthBloc>(context, listen: false)
                        .add(AppLogout());
                    Navigator.pushNamedAndRemoveUntil(
                        context, INTRO, (route) => false);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget address(SignUpAndUserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              user.address!,
              maxLines: 2,
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              CommonUrlLauncher().launchCall(user.personalPhnNo!);
            },
            child: Row(
              children: [
                Text(
                  CONTACT_TEXT,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 3),
                Icon(CupertinoIcons.phone)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutMe(SignUpAndUserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
              user.about!.isNotEmpty ? user.about! : 'Not Available add now!',
              style: _theme.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: user.about!.isNotEmpty ? PRIMARY_COLOR : BLUE_GRAY),
            ),
          ),
        ],
      ),
    );
  }

  Widget projectPref() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PROJECT_PREFRENCES_TEXT,
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          StreamBuilder<Projects>(
            stream: _userProjectsBloc.getCompletedProjectsStream,
            builder: (context, projectSnapshot) {
              if (!projectSnapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: LinearLoader(minheight: 12)),
                );
              }
              return Container(
                height: width * 0.25,
                child: StreamBuilder<Categories>(
                  stream: _categoryBloc.getCategoriesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      _categoryBloc.getCategories();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: LinearLoader(minheight: 12)),
                      );
                    }
                    late List<CategoryModel> availCategory = [];
                    snapshot.data!.categories.forEach((category) {
                      projectSnapshot.data!.projectList.forEach((project) {
                        if (project.categoryId == category.id) {
                          availCategory.add(category);
                        }
                      });
                    });
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: availCategory.map((category) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategorisedProjectsScreen(
                                    categoryId: category.id),
                              ),
                            );
                          },
                          child: Container(
                            width: width / 5.7,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: LinearLoader(minheight: 10),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline_rounded),
                                  imageUrl: category.imgUrl,
                                  fit: BoxFit.fill,
                                  color: PRIMARY_COLOR,
                                  height: width * 0.1,
                                  width: width * 0.1,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  category.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
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
                    );
                  },
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
      stream: _userProjectsBloc.getCompletedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _userProjectsBloc.getOwnCompletedProjects();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader(minheight: 12)),
          );
        }
        final List<ProjectModel> projects = snapshot.data!.projectList;
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: GRAY,
              padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    COMPLETED_PROJECT_TEXT,
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    projects.length.toString(),
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final ProjectModel project = projects[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectOtherDetailsScreen(project: project),
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
                                  project.projectName,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    color: BLUE_GRAY,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  project.organization,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    color: DARK_GRAY,
                                  ),
                                ),
                                Text(
                                  DateFormat('EEE, dd MMM - yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(project.startDate),
                                    ),
                                  ),
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
