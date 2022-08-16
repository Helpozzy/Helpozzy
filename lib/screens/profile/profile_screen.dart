import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
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
  final AuthRepository _authRepository = AuthRepository();

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
          final SignUpAndUserModel user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileSection(user),
                      aboutMe(user),
                      user.organizationDetails != null &&
                              user.organizationDetails!.legalOrganizationName !=
                                  null
                          ? SizedBox()
                          : SizedBox(height: 5),
                      user.organizationDetails != null &&
                              user.organizationDetails!.legalOrganizationName !=
                                  null
                          ? organizationDetails(user.organizationDetails!)
                          : SizedBox(),
                      user.isOrganization! ? SizedBox() : projectPref(user),
                    ],
                  ),
                ),
                menus(user),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget profileSection(SignUpAndUserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.firstName! + ' ' + user.lastName!,
                  style: _theme.textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: PRIMARY_COLOR,
                    fontSize: 18,
                  ),
                ),
                UserBasicInfoDetails(
                  icon: CupertinoIcons.person,
                  text: MEMBER_SYNC_LABEL +
                      DateFormatFromTimeStamp()
                          .dateFormatToMMMYYYY(timeStamp: user.joiningDate!),
                ),
                UserBasicInfoDetails(
                  icon: CupertinoIcons.timer,
                  text:
                      TOTAL_VOLUNTEERING_LABEL + user.totalSpentHrs.toString(),
                ),
                UserBasicInfoDetails(
                  icon: CupertinoIcons.location,
                  text: user.address!,
                ),
                SizedBox(height: 5),
                SmallCommonButtonWithIcon(
                  icon: CupertinoIcons.pencil,
                  text: EDIT_PROFILE_MENU,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(user: user),
                      ),
                    );
                    await _userInfoBloc
                        .getUser(prefsObject.getString(CURRENT_USER_ID)!);
                  },
                  fontSize: 12,
                  iconSize: 12,
                  buttonColor: DARK_GRAY,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenView(imgUrl: user.profileUrl!),
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
              child: CommonUserProfileOrPlaceholder(
                size: width * 0.2,
                imgUrl: user.profileUrl!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutMe(SignUpAndUserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
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
                  : TELL_US_ABOUT_HINT,
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            PROJECT_PREFERENCES_TEXT,
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
                    NO_PREFERENCES_FOUNDS,
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

  Widget menus(SignUpAndUserModel user) {
    return Column(
      children: [
        user.currentYearTargetHours != 0
            ? ListDividerLabel(label: SERVICE_RECORDS)
            : SizedBox(),
        user.currentYearTargetHours != 0
            ? menuTile(
                title: POINT_TAB,
                icon: CupertinoIcons.list_bullet_below_rectangle,
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PointsScreen(),
                  ),
                ),
              )
            : SizedBox(),
        CommonDivider(),
        ListDividerLabel(label: ACCOUNT_SETTING),
        menuTile(
          title: DELETE_ACCOUNT,
          icon: CupertinoIcons.trash,
          onTap: () => deleteAccountPrompt(),
        ),
        CommonDivider(),
        menuTile(
          title: SIGN_OUT_POPUP_MENU,
          icon: CupertinoIcons.square_arrow_left,
          onTap: () => signOutPrompt(),
        ),
        CommonDivider(),
      ],
    );
  }

  Widget menuTile({
    required IconData icon,
    required String title,
    GestureTapCallback? onTap,
  }) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04),
        title: Text(
          title,
          style: _theme.textTheme.bodyText2,
        ),
        trailing: Icon(icon, size: 18),
        onTap: onTap,
      );

  Future deleteAccountPrompt() async {
    PlatformAlertDialog().showWithAction(
      context,
      title: DELETE_ACCOUNT,
      content: DELETE_ACCOUNT_SUBTITLE,
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
            onPressed: () => onDeleteAccount(),
            text: CONFIRM,
          ),
        ),
      ],
    );
  }

  Future onDeleteAccount() async {
    Navigator.of(context).pop();
    CircularLoader().show(context);

    await _authRepository.getCurrentUser().then(
          (response) async => await _authRepository
              .deleteAccount(response!.user!)
              .then((deleteUser) async {
            if (deleteUser.success!) {
              await _userInfoBloc
                  .deleteUserRefrences()
                  .then((userRefClearResponse) async {
                CircularLoader().hide(context);
                await prefsObject.clear();
                await prefsObject.reload();
                await ScaffoldSnakBar()
                    .show(context, msg: userRefClearResponse.message!);
                await Navigator.pushNamedAndRemoveUntil(
                    context, INTRO, (route) => false);
              });
            } else {
              CircularLoader().hide(context);
              await ScaffoldSnakBar().show(context, msg: deleteUser.error!);
            }
          }),
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

class UserBasicInfoDetails extends StatelessWidget {
  const UserBasicInfoDetails({Key? key, required this.icon, required this.text})
      : super(key: key);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: DARK_GRAY,
          ),
          SizedBox(width: 3),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: DARK_GRAY,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
