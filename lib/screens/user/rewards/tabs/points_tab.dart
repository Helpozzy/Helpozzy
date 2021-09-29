import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PointsTabScreen extends StatefulWidget {
  @override
  _PointsTabScreenState createState() => _PointsTabScreenState();
}

class _PointsTabScreenState extends State<PointsTabScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData _theme;
  late double height;
  late double width;

  bool boo = true;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 500).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    animateContainer();
  }

  void animateContainer() {
    setState(() {
      if (boo == true) {
        controller.forward();
      } else {
        controller.reverse();
      }
      boo = !boo;
    });
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
          topMemberShipSection(),
          membershipInfo(),
        ],
      ),
    );
  }

  Widget topMemberShipSection() {
    return Container(
      height: height / 2.5,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      width: animation.value,
      color: ACCENT_GRAY,
      child: animation.value > 400
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/medal_silver.png',
                  height: height / 5.8,
                  width: height / 5.8,
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      SILVER_MEMBER,
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
                    Text(
                      '35',
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: height / 10,
                        fontWeight: FontWeight.bold,
                        color: DARK_PINK_COLOR,
                      ),
                    ),
                    Text(
                      POINT_TO_REDEEM,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: 36,
                      width: height / 4.5,
                      margin: EdgeInsets.only(top: 7),
                      child: CommonButton(
                        text: REDEEM_MY_POINT,
                        color: LIGHT_BLACK,
                        fontSize: 12,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            )
          : SizedBox(),
    );
  }

  Widget membershipInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: Text(
              SECOND_TEXT_POINTS,
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
                    percent: 0.35,
                    animateFromLastPercent: true,
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: BLACK,
                    backgroundColor: DARK_ACCENT_GRAY,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '300',
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
          infoTile(title: MEMBER_SINCE, data: '2020'),
          infoTile(title: MEMBERSHIP_NUMBER, data: '8900 1199 1222 22'),
          infoTile(title: EARNED_POINT, data: '722'),
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
