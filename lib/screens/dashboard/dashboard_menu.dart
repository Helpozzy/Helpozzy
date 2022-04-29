import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/dashboard_menu_model.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/process_timeline.dart';
import 'package:helpozzy/screens/dashboard/projects/project_list.dart';
import 'package:helpozzy/screens/dashboard/reports/report_screen.dart';
import 'package:helpozzy/screens/dashboard/tasks/my_enrolled_tasks.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'projects/projects_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double height;
  late double width;
  late ThemeData _theme;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  late int _processIndex = 2;
  late double currentPosition = 0.0;

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    super.initState();
  }

  Future<DashboardMenus> getMenuList() async {
    return DashboardMenus.fromList(items: dashBoardMenuList);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topContainerWithProgress(),
            CommonDivider(),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.08,
                right: width * 0.06,
                top: 10.0,
              ),
              child: StreamBuilder<SignUpAndUserModel>(
                stream: _userInfoBloc.userStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      LOADING,
                      style: _theme.textTheme.headline6!.copyWith(
                        color: DARK_GRAY,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return Text(
                    'Hi, ${snapshot.data!.firstName}',
                    style: _theme.textTheme.headline6!.copyWith(
                      color: PRIMARY_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            menuGrid(),
          ],
        ),
      ),
    );
  }

  Widget topContainerWithProgress() {
    return Container(
      color: ACCENT_GRAY_COLOR,
      child: Column(
        children: [
          TopAppLogo(size: width * 0.20),
          Text(
            MSG_DASHBOARD,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2!.copyWith(
              color: DARK_PINK_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          timelineProgress(),
          organizationDetails(),
        ],
      ),
    );
  }

  Widget timelineProgress() {
    return StreamBuilder<SignUpAndUserModel>(
      stream: _userInfoBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                LOADING,
                style: _theme.textTheme.headline6!.copyWith(
                  color: DARK_GRAY,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        final SignUpAndUserModel user = snapshot.data!;
        if (user.currentYearTargetHours != null) {
          _processIndex = user.totalSpentHrs != null ? user.totalSpentHrs! : 0;
          List<int> items =
              List<int>.generate(user.currentYearTargetHours!, (i) => i * 25)
                  .take((user.currentYearTargetHours! / 10).round())
                  .toList();
          items
              .removeWhere((element) => element > user.currentYearTargetHours!);
          return user.currentYearTargetHours != null &&
                  user.currentYearTargetHours != 0
              ? Stack(
                  children: [
                    Container(
                      height: height / 6.5,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: Alignment.center,
                      child: ProcessTimelinePage(
                        items: items,
                        processIndex: _processIndex,
                      ),
                    ),
                    achievedScoreDetails(user),
                  ],
                )
              : SizedBox();
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget achievedScoreDetails(SignUpAndUserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            YOUR_HOURS_1,
            style: _theme.textTheme.bodyText2!.copyWith(
              color: BLUE_GRAY,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.totalSpentHrs.toString(),
            style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: width * 0.08,
                color: BLACK,
                fontWeight: FontWeight.bold),
          ),
          Text(
            YOUR_HOURS_2,
            style: _theme.textTheme.bodyText2!
                .copyWith(color: BLUE_GRAY, fontWeight: FontWeight.bold),
          ),
          Text(
            '${DateTime.now().year}',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 20,
              color: BLUE_GRAY,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget organizationDetails() {
    return StreamBuilder<SignUpAndUserModel>(
      stream: _userInfoBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            LOADING,
            style: _theme.textTheme.headline6!.copyWith(
              color: DARK_GRAY,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        final OrganizationSignUpModel? organizationDetails =
            snapshot.data!.organizationDetails;
        return organizationDetails != null &&
                organizationDetails.legalOrganizationName != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  children: [
                    Text(
                      organizationDetails.legalOrganizationName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: width * 0.05,
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        organizationDetails.discription!,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: _theme.textTheme.bodyText2!.copyWith(
                            color: BLUE_GRAY, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }

  Widget menuGrid() {
    return FutureBuilder<DashboardMenus>(
      future: getMenuList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return GridView.count(
          physics: ScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1.05,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          children: snapshot.data!.menus.map((MenuModel menu) {
            return GestureDetector(
              onTap: () async => await onMenuTap(menu),
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: GRAY,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Image.asset(
                        menu.asset,
                        height: width / 5.7,
                        width: width / 5.7,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                    CommonDivider(),
                    Text(
                      menu.label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        color: DARK_PINK_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future onMenuTap(MenuModel menu) async {
    switch (menu.id) {
      case 0:
        pagesNavigation(child: ProjectsScreen());
        break;
      case 1:
        pagesNavigation(child: MyEnrolledTask());
        break;
      case 2:
        pagesNavigation(child: ReportsScreen());
        break;
      case 3:
        pagesNavigation(
          child: Scaffold(
            appBar: CommonAppBar(context).show(title: TIME_TRACKER_TILE),
            body: ProjectListScreen(
              projectTabType: ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB,
              projectsBloc: _projectsBloc,
            ),
          ),
        );
        break;
    }
  }

  Future pagesNavigation({required Widget child}) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => child),
    );
  }
}
