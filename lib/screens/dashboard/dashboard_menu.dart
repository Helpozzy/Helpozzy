import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/dashboard_menu_model.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/my_task/my_enrolled_tasks.dart';
import 'package:helpozzy/screens/dashboard/projects/project_list.dart';
import 'package:helpozzy/screens/dashboard/reports/report_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:timelines/timelines.dart';
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

  Color getColor(int index) {
    if (index == _processIndex) {
      return BLACK;
    } else if (index < _processIndex) {
      return BLACK;
    } else {
      return LIGHT_GRAY;
    }
  }

  Future<DashboardMenus> getMenuList() async {
    return DashboardMenus.fromList(items: dashBoardMenuList);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topContainerWithProgress(),
            CommonDivider(),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.08, right: width * 0.06, top: 10.0),
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
                    'Hi, ${snapshot.data!.name}',
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
          TopAppLogo(size: width * 0.23),
          Text(
            MSG_DASHBOARD,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2!.copyWith(
              color: DARK_PINK_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7),
          timelineProgress(),
          organizationDetails(),
        ],
      ),
    );
  }

  Widget achievedScoreDetails(SignUpAndUserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        children: [
          Text(
            YOUR_HOURS_1,
            style: _theme.textTheme.bodyText2!.copyWith(
              color: BLUE_GRAY,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '50',
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
          _processIndex = 50;
          List<int> items =
              List<int>.generate(user.currentYearTargetHours!, (i) => i * 25)
                  .take((user.currentYearTargetHours! / 23).round())
                  .toList();

          return Stack(
            children: [
              Container(
                height: height / 6.5,
                width: double.infinity,
                alignment: Alignment.center,
                child: Timeline.tileBuilder(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  shrinkWrap: true,
                  theme: TimelineThemeData(
                    direction: Axis.horizontal,
                    connectorTheme: ConnectorThemeData(thickness: 3.0),
                  ),
                  builder: TimelineTileBuilder.connected(
                    connectionDirection: ConnectionDirection.before,
                    itemExtentBuilder: (ctx, index) => width / 9.5,
                    contentsBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          index == items.length - 1
                              ? '${items[index]}\nMy Goal'
                              : '${items[index]}',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontWeight: index == items.length - 1
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 12,
                            color: DARK_GRAY,
                          ),
                        ),
                      );
                    },
                    indicatorBuilder: (ctx, index) {
                      Color color;
                      if (items[index] == _processIndex) {
                        color = BLACK;
                      } else if (items[index] < _processIndex) {
                        color = BLACK;
                      } else {
                        color = LIGHT_GRAY;
                      }

                      if (items[index] <= _processIndex) {
                        return Container(
                          height: width * 0.025,
                          width: width * 0.025,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: color,
                          ),
                        );
                      } else {
                        return Container(
                          height: width * 0.025,
                          width: width * 0.025,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: color,
                          ),
                        );
                      }
                    },
                    connectorBuilder: (ctx, index, type) {
                      if (items[index] > 0) {
                        if (items[index] == _processIndex) {
                          final color = getColor(items[index]);
                          return DecoratedLineConnector(
                            decoration: BoxDecoration(color: color),
                          );
                        } else {
                          return SolidLineConnector(
                            color: getColor(items[index]),
                          );
                        }
                      } else {
                        return null;
                      }
                    },
                    itemCount: items.length,
                  ),
                ),
              ),
              achievedScoreDetails(user),
            ],
          );
        } else {
          return SizedBox();
        }
      },
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
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  children: [
                    Text(
                      organizationDetails.legalOrganizationName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: width * 0.06,
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      organizationDetails.discription!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodyText2!.copyWith(
                          color: BLUE_GRAY, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10)
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: snapshot.data!.menus.map((MenuModel menu) {
            return GestureDetector(
              onTap: () async => await onMenuTap(menu),
              child: Card(
                margin: EdgeInsets.all(12.0),
                elevation: 0,
                color: GRAY,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
