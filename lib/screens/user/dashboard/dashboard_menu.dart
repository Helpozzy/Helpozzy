import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/categories_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/user/common_screen.dart';
import 'package:helpozzy/screens/user/dashboard/members/members.dart';
import 'package:helpozzy/screens/user/dashboard/reports/report_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'projects/projects_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardBloc _dashboardBloc = DashboardBloc();
  late double height;
  late double width;
  late ThemeData _theme;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _dashboardBloc.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TopAppLogo(height: height / 6.5),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 6.0),
              child: StreamBuilder<SignUpAndUserModel>(
                stream: _userInfoBloc.userStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: LinearLoader());
                  }
                  return Text(
                    'Hi, ${snapshot.data!.name}',
                    style: _theme.textTheme.headline6!.copyWith(
                      color: DARK_PINK_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            Expanded(child: typeSelectionGrid()),
          ],
        ),
      ),
    );
  }

  Widget typeSelectionGrid() {
    return StreamBuilder<DashboardMenus>(
      stream: _dashboardBloc.getDashBoardMenusStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: PRIMARY_COLOR));
        }
        return GridView.count(
          physics: ScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          children: snapshot.data!.menus.map((MenuModel menu) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => menu.id == 0
                        ? ProjectsScreen()
                        : menu.id == 1
                            ? MembersScreen()
                            : menu.id == 2
                                ? ReportsScreen()
                                : CommonSampleScreen(
                                    '${menu.label}\nCurrently Not Available'),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                elevation: 0,
                color: ACCENT_GRAY_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: CachedNetworkImage(
                        imageUrl: menu.imgUrl,
                        height: width / 5.5,
                        width: width / 5.5,
                        color: PRIMARY_COLOR,
                        placeholder: (context, url) =>
                            Center(child: LinearLoader()),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error_outline_rounded,
                          color: GRAY,
                          size: width / 7,
                        ),
                      ),
                    ),
                    CommonDivider(),
                    Text(
                      menu.label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.headline6!.copyWith(
                        color: DARK_PINK_COLOR,
                        fontSize: 14,
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
    );
  }
}
