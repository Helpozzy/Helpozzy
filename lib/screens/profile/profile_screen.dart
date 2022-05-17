import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/projects/categorised_projects_list.dart';
import 'package:helpozzy/screens/profile/edit_profile.dart';
import 'package:helpozzy/screens/profile/points_screen.dart';
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
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: CommonUserProfileOrPlaceholder(
                size: width / 5.5,
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
                      user.firstName! + ' ' + user.lastName!,
                      style: _theme.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: DARK_MARUN,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(user: user),
                          ),
                        );
                        await _userInfoBloc
                            .getUser(prefsObject.getString(CURRENT_USER_ID)!);
                      },
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
                      user.reviewsByPersons != null
                          ? '${user.reviewsByPersons} reviews'
                          : '0 reviews',
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DARK_GRAY_FONT_COLOR,
                      ),
                    ),
                  ],
                ),
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
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorisedProjectsScreen(
                            category: category,
                            fromPrefs: true,
                          ),
                        ),
                      ),
                      child: Card(
                        elevation: 0,
                        color: LIGHT_BLUE,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
}
