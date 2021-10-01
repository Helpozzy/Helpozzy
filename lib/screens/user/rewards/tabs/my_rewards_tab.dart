import 'package:flutter/material.dart';
import 'package:helpozzy/models/user_rewards_model.dart';
import 'package:helpozzy/screens/user/rewards/tabs/accept_gift_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MyRewardsTabScreen extends StatefulWidget {
  @override
  _MyRewardsTabScreenState createState() => _MyRewardsTabScreenState();
}

class _MyRewardsTabScreenState extends State<MyRewardsTabScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  late bool expanded = false;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: LIGHT_ACCENT_GRAY,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AVAILABLE_POINT,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '35',
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          sectionTile(text: REWARDS_RECEIVED),
          peopleRewards(),
          seeAllButton(),
          sectionTile(text: REWARDS_REDEEM),
          pointTableItem(title: USED_POINTS, data: '0'),
          pointTableItem(title: GIFT_REDEEM, data: '0'),
          pointTableItem(title: POINT_SENT, data: '3'),
        ],
      ),
    );
  }

  Widget sectionTile({required String text}) {
    return Column(
      children: [
        CommonDivider(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Text(
            REWARDS_RECEIVED,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 18,
              color: DARK_PINK_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CommonDivider(),
      ],
    );
  }

  Widget peopleRewards() {
    final peoples = Volunteers(list: peoplesList).peoples;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expanded ? peoples.length : 2,
      itemBuilder: (context, index) {
        final PeopleModel people = peoples[index];
        return rewardItem(people);
      },
    );
  }

  Widget seeAllButton() {
    return InkWell(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              expanded ? EXPAND_LESS : EXPAND_ALL,
              textAlign: TextAlign.center,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 16,
                color: LIGHT_BLACK,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            )
          ],
        ),
      ),
    );
  }

  Widget rewardItem(PeopleModel people) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
          child: Row(
            children: [
              CommonUserPlaceholder(size: 30),
              SizedBox(width: 14.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    people.name,
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${people.pointGifted} points gifted',
                    style: _theme.textTheme.bodyText2!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  showAcceptDialog(people);
                },
                icon: Icon(Icons.wallet_giftcard_rounded),
              )
            ],
          ),
        ),
        CommonDivider(),
      ],
    );
  }

  Future showAcceptDialog(PeopleModel people) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: AcceptGiftScreen(people: people),
        );
      },
    );
  }

  Widget pointTableItem({required String title, required String data}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
        CustomSeparator(color: DIVIDER_COLOR, height: 0.5)
      ],
    );
  }
}