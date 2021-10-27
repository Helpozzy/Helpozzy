import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_types_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/admin/projects/projects_screen.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/screens/user/common_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:provider/provider.dart';

import 'members/members.dart';

class AdminSelectionScreen extends StatefulWidget {
  @override
  _AdminSelectionScreenState createState() => _AdminSelectionScreenState();
}

class _AdminSelectionScreenState extends State<AdminSelectionScreen> {
  final AdminCategoriesBloc _adminTypesBloc = AdminCategoriesBloc();
  late double height;
  late double width;
  late ThemeData _theme;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString('uID')!);
    _adminTypesBloc.getCategories();
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
            TopAppLogo(height: height / 6.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: StreamBuilder<UserModel>(
                        stream: _userInfoBloc.userStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: LinearLoader(minheight: 12),
                            );
                          }
                          return Text(
                            'Hello, ${snapshot.data!.name}',
                            style: _theme.textTheme.headline6!.copyWith(
                              color: DARK_PINK_COLOR,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_rounded),
                    onPressed: () {
                      Provider.of<AuthBloc>(context, listen: false)
                          .add(AppLogout());
                      Navigator.pushNamedAndRemoveUntil(
                          context, INTRO, (route) => false);
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: typeSelectionGrid()),
          ],
        ),
      ),
    );
  }

  Widget typeSelectionGrid() {
    return StreamBuilder<AdminTypes>(
      stream: _adminTypesBloc.getAdminCategoriesStream,
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
          children: snapshot.data!.item.map((AdminTypeModel type) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => type.id == 0
                        ? ProjectsScreen()
                        : type.id == 1
                            ? MembersScreen()
                            : CommonSampleScreen('No Available'),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: CachedNetworkImage(
                          imageUrl: type.imgUrl,
                          height: width / 5,
                          width: width / 5,
                          placeholder: (context, url) => Center(
                            child: LinearLoader(minheight: 10),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline_rounded,
                            color: GRAY,
                            size: width / 7,
                          ),
                        ),
                      ),
                      CommonDivider(),
                      Text(
                        type.label.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: _theme.textTheme.headline6!.copyWith(
                          color: DARK_PINK_COLOR,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
