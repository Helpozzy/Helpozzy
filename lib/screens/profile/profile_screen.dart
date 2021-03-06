import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/screens/dashboard/projects/categorised_projects_list.dart';
import 'package:helpozzy/screens/profile/edit_profile.dart';
import 'package:helpozzy/screens/profile/points_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/full_screen_image_view.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
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
                      user.organizationDetails != null &&
                              user.organizationDetails!.legalOrganizationName !=
                                  null
                          ? organizationDetails(user.organizationDetails!)
                          : SizedBox(),
                      user.isOrganization! ? SizedBox() : projectPref(user),
                    ],
                  ),
                ),
                ListDividerLabel(label: SERVICE_RECORDS),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: width * 0.04),
                  title: Text(POINT_TAB),
                  trailing: Icon(
                    CupertinoIcons.list_bullet_below_rectangle,
                    color: DARK_PINK_COLOR,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => PointsScreen(),
                    ),
                  ),
                ),
                CommonDivider(),
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
          borderRadius: BorderRadius.circular(18)),
      child: Row(
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
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: CommonUserProfileOrPlaceholder(
                size: width / 7,
                imgUrl: user.profileUrl!,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.firstName! + ' ' + user.lastName!,
                        style: _theme.textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DARK_MARUN,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    popupButton(user),
                    SizedBox(width: 6),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      size: 12,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 3),
                    Text(
                      MEMBER_SYNC_LABEL +
                          DateFormatFromTimeStamp().dateFormatToMMMYYYY(
                              timeStamp: user.joiningDate!),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DARK_GRAY_FONT_COLOR,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.timer,
                      size: 12,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Total volunteering hrs : ${user.totalSpentHrs} Hours',
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DARK_GRAY_FONT_COLOR,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget popupButton(SignUpAndUserModel user) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Icon(
        Icons.more_vert_rounded,
        color: PRIMARY_COLOR,
      ),
      onSelected: (item) async => await handleClick(item, user),
      itemBuilder: (context) => [
        popupMenuItem(
            text: EDIT_PROFILE_MENU,
            icon: CupertinoIcons.pencil_circle,
            value: 0),
        PopupMenuDivider(height: 0.1),
        popupMenuItem(
            text: SIGN_OUT_POPUP_MENU,
            icon: Icons.exit_to_app_rounded,
            value: 1),
      ],
    );
  }

  PopupMenuItem<int> popupMenuItem(
          {required String text, required IconData icon, required int value}) =>
      PopupMenuItem<int>(
        value: value,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
              ),
            ),
            Icon(
              icon,
              color: DARK_GRAY,
              size: 20,
            )
          ],
        ),
      );

  Future handleClick(int item, SignUpAndUserModel user) async {
    switch (item) {
      case 0:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(user: user),
          ),
        );
        await _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
        break;
      case 1:
        signOutPrompt();
        break;
    }
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
              user.about != null && user.about!.isNotEmpty
                  ? user.about!
                  : ADD_NOW,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w600,
                color: user.about != null && user.about!.isNotEmpty
                    ? PRIMARY_COLOR
                    : BLUE_GRAY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget organizationDetails(OrganizationSignUpModel organizationDetails) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ORGANIZATION_DETAILS_TEXT,
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            organizationDetails.legalOrganizationName!,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: DARK_PINK_COLOR,
            ),
          ),
          SizedBox(height: 4),
          Text(
            DOT + organizationDetails.discription!,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: PRIMARY_COLOR,
            ),
          ),
          Text(
            organizationDetails.isNonProfitOrganization!
                ? NON_PROFIT_ORGANIZATION
                : PROFIT_ORGANIZATION,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: DARK_GRAY,
            ),
          ),
          Text(
            ORGANIZATION_TAX_ID_NUMBER + organizationDetails.taxIdNumber!,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: DARK_GRAY,
            ),
          ),
        ],
      ),
    );
  }

  Widget projectPref(SignUpAndUserModel user) {
    final List<CategoryModel> userPrefs = categoriesList
        .where((category) => user.areaOfInterests!.contains(category.id))
        .toList();
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
          user.areaOfInterests!.isNotEmpty
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (3),
                    childAspectRatio: 2.5,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  itemCount: userPrefs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final CategoryModel category = userPrefs[index];
                    return Card(
                      elevation: 0,
                      color: LIGHT_BLUE,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorisedProjectsScreen(
                              category: category,
                              fromPrefs: true,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                category.asset!,
                                fit: BoxFit.fill,
                                color: DARK_GRAY,
                                height: width * 0.06,
                                width: width * 0.06,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  category.label!,
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    fontSize: 10,
                                    color: DARK_GRAY,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    NO_PREFRENCES_FOUNDS,
                    style: _theme.textTheme.bodyText2!.copyWith(
                      color: DARK_GRAY,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future signOutPrompt() async {
    PlatformAlertDialog().showWithAction(
      context,
      title: SIGN_OUT_TITLE,
      content: SIGN_OUT_FROM_APP,
      actions: [
        TextButton(
          onPressed: () async => Navigator.of(context).pop(),
          child: Text(
            CANCEL_BUTTON,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SmallCommonButton(
            fontSize: 12,
            onPressed: () {
              Provider.of<AuthBloc>(context, listen: false).add(AppLogout());
              prefsObject.clear();
              prefsObject.reload();
              Navigator.pushNamedAndRemoveUntil(
                  context, INTRO, (route) => false);
            },
            text: SIGN_OUT_BUTTON,
          ),
        ),
      ],
    );
  }
}
