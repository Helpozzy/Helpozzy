import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/rewards_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';

class DetailsTabScreen extends StatefulWidget {
  @override
  _DetailsTabScreenState createState() => _DetailsTabScreenState();
}

class _DetailsTabScreenState extends State<DetailsTabScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData _theme;
  late double height;
  late double width;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  late AnimationController _animationController;

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topContents(),
          gridPointTable(),
        ],
      ),
    );
  }

  Widget topContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            TOP_REWARD_DETAILS,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
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
      ],
    );
  }

  Widget gridPointTable() {
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
          final Rewards rewards = Rewards.fromJson(rewardsList);
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rewards.rewardTypes.length,
            itemBuilder: (context, index) {
              final RewardsDetailsModel reward = rewards.rewardTypes[index];
              final String categoryName = rewards.keys[index];
              return Container(
                color:
                    index % 2 == 0 ? LIGHT_ACCENT_GRAY.withOpacity(0.3) : WHITE,
                child: Row(
                  children: [
                    rewardCategory(reward, categoryName),
                    pointsListView(
                        reward.points, snapshot.data, rewards.rewardTypes[0])
                  ],
                ),
              );
            },
          );
        });
  }

  Widget rewardCategory(RewardsDetailsModel reward, String label) {
    return Container(
      height: width * 0.23,
      width: width / 5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: BorderDirectional(
        top: BorderSide(
          color: GRAY,
          width: 0.5,
        ),
        bottom: BorderSide(
          color: GRAY,
          width: 1,
        ),
        start: BorderSide(
          color: GRAY,
          width: 0.5,
        ),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          reward.asset.isNotEmpty
              ? Image.asset(
                  reward.asset,
                  height: width * 0.11,
                  width: width * 0.11,
                )
              : SizedBox(),
          SizedBox(height: 2),
          Text(
            label,
            maxLines: reward.asset.isNotEmpty ? 2 : 3,
            textAlign: TextAlign.center,
            style: reward.asset.isNotEmpty
                ? _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 10,
                    color: DARK_PINK_COLOR,
                    fontWeight: FontWeight.bold,
                  )
                : _theme.textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
          )
        ],
      ),
    );
  }

  Widget pointsListView(List<PointsModel> points,
      SignUpAndUserModel? currentUser, RewardsDetailsModel reward) {
    return SizedBox(
      height: width * 0.23,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: points.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final PointsModel data = points[index];
          return currentUser!.totalSpentHrs! > data.to &&
                  currentUser.totalSpentHrs! < data.from &&
                  ageCalculation(currentUser.dateOfBirth!) >
                      reward.points[index].to &&
                  ageCalculation(currentUser.dateOfBirth!) <
                      reward.points[index].from
              ? FadeTransition(
                  opacity: _animationController,
                  child: pointBoxContainer(data, true),
                )
              : pointBoxContainer(data, false);
        },
      ),
    );
  }

  Widget pointBoxContainer(PointsModel data, bool currentGoal) {
    return Container(
      height: width * 0.25,
      width: width / 5,
      decoration: BoxDecoration(
          color: currentGoal ? GREEN : null,
          border: BorderDirectional(
            top: BorderSide(
              color: GRAY,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: GRAY,
              width: 1,
            ),
            start: BorderSide(
              color: GRAY,
              width: 0.5,
            ),
            end: BorderSide(
              color: GRAY,
              width: 0.5,
            ),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.title != null
                ? (data.to == data.from)
                    ? '${data.title}\n(${data.to}+)'
                    : '${data.title}\n(${data.to}-${data.from})'
                : (data.to == data.from)
                    ? '${data.to}+\nHrs'
                    : '${data.to}-${data.from}\nHrs',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
