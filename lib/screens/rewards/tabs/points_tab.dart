import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PointsTabScreen extends StatefulWidget {
  PointsTabScreen({this.tabController});
  final TabController? tabController;
  @override
  _PointsTabScreenState createState() =>
      _PointsTabScreenState(tabController: tabController);
}

class _PointsTabScreenState extends State<PointsTabScreen>
    with SingleTickerProviderStateMixin {
  _PointsTabScreenState({this.tabController});
  final TabController? tabController;
  late ThemeData _theme;
  late double height;
  late double width;

  late bool boo = true;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  void initState() {
    super.initState();
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
  }

  int ageCalculation(String timestamp) {
    final birthday = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    final currentDate = DateTime.now();
    print(currentDate.difference(birthday).inDays);
    final int yrsOfAge =
        (currentDate.difference(birthday).inDays / 365).round();
    return yrsOfAge;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return StreamBuilder<SignUpAndUserModel>(
      stream: _userInfoBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: BLACK,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  SECOND_REWARD_DETAILS_TEXT,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    color: WHITE,
                    fontSize: 15,
                  ),
                ),
              ),
              topMemberShipSection(snapshot.data!),
              membershipInfo(snapshot.data!),
            ],
          ),
        );
      },
    );
  }

  Widget topMemberShipSection(SignUpAndUserModel user) {
    return Container(
      height: height / 4,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      width: double.infinity,
      color: GRAY,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            user.totalSpentHrs! <= 25
                ? 'assets/images/medal_beginer.png'
                : user.totalSpentHrs! <= 50
                    ? 'assets/images/medal_bronze.png'
                    : user.totalSpentHrs! <= 100
                        ? 'assets/images/medal_silver.png'
                        : user.totalSpentHrs! <= 150
                            ? 'assets/images/medal_gold.png'
                            : user.totalSpentHrs! <= 200
                                ? 'assets/images/trophy.png'
                                : 'assets/images/medal_beginer.png',
            height: height / 5.8,
            width: height / 5.8,
          ),
          SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.totalSpentHrs! <= 25
                    ? BEGINNER_MEMBER
                    : user.totalSpentHrs! <= 50
                        ? BRONZE_MEMBER
                        : user.totalSpentHrs! <= 100
                            ? SILVER_MEMBER
                            : user.totalSpentHrs! <= 150
                                ? GOLD_MEMBER
                                : user.totalSpentHrs! <= 200
                                    ? LIFETIME_ACHIEVMENT
                                    : BEGINNER_MEMBER,
                style: _theme.textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: height / 35,
                ),
              ),
              SizedBox(height: 7.0),
              Text(
                'Points last updated on 12/6/2020',
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.totalSpentHrs!.toString(),
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: height / 10,
                      fontWeight: FontWeight.bold,
                      color: DARK_PINK_COLOR,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    HRS_LABEL,
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Text(
              //   POINT_TO_REDEEM,
              //   style: _theme.textTheme.bodyText2!.copyWith(
              //     fontSize: 10,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // Container(
              //   height: 36,
              //   width: height / 4.5,
              //   margin: EdgeInsets.only(top: 7),
              //   child: CommonButton(
              //     text: REDEEM_MY_POINT,
              //     color: LIGHT_BLACK,
              //     fontSize: 12,
              //     onPressed: () => tabController!.animateTo(3),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget membershipInfo(SignUpAndUserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: Text(
              EARN_POINTS +
                  (user.currentYearTargetHours! - user.totalSpentHrs!)
                      .toString() +
                  REMAING_POINT_TO_GET_BADGE,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 13.0, top: 6, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    lineHeight: 20.0,
                    animationDuration: 3000,
                    percent: double.parse(user.totalSpentHrs.toString()) /
                        user.currentYearTargetHours!,
                    center: Text(
                      (double.parse(user.totalSpentHrs.toString()) /
                                  (user.currentYearTargetHours! / 100))
                              .toStringAsFixed(2) +
                          ' %',
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 10,
                        color: double.parse(user.totalSpentHrs.toString()) /
                                    (user.currentYearTargetHours! / 100) >
                                45.0
                            ? WHITE
                            : BLACK,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    animateFromLastPercent: true,
                    progressColor: BLACK,
                    backgroundColor: GRAY,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  user.currentYearTargetHours.toString(),
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          CustomSeparator(
            color: DIVIDER_COLOR,
            height: 0.3,
          ),
          infoTile(
              title: MEMBER_SINCE,
              data: _dateFormatFromTimeStamp.dateYYYY(
                  timestamp: user.joiningDate!)),
          // infoTile(title: MEMBERSHIP_NUMBER, data: '8900 1199 1222 22'),
          infoTile(title: EARNED_POINT, data: user.totalSpentHrs.toString()),
        ],
      ),
    );
  }

  Widget infoTile({required String title, required String data}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                data,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        CustomSeparator(
          color: DIVIDER_COLOR,
          height: 0.3,
        ),
      ],
    );
  }
}
