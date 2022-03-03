import 'package:flutter/material.dart';
import 'package:helpozzy/models/rewards_model.dart';
import 'package:helpozzy/utils/constants.dart';

class DetailsTabScreen extends StatefulWidget {
  @override
  _DetailsTabScreenState createState() => _DetailsTabScreenState();
}

class _DetailsTabScreenState extends State<DetailsTabScreen> {
  late ThemeData _theme;
  late double height;
  late double width;

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
          tableColumn(),
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

  Widget tableColumn() {
    return Row(
      children: [
        columnKeyName(COLUMN_ONE),
        columnKeyName(COLUMN_TWO),
        columnKeyName(COLUMN_THREE),
        columnKeyName(COLUMN_FOUR),
        columnKeyName(COLUMN_FIVE),
      ],
    );
  }

  Widget columnKeyName(String text) {
    return Container(
      height: width * 0.17,
      width: width / 5,
      alignment: Alignment.center,
      color: TABLE_ROW_GRAY_COLOR,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _theme.textTheme.bodyText2!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget gridPointTable() {
    final Rewards snapshot = Rewards.fromJson(rewardsList);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: snapshot.rewardTypes.length,
      itemBuilder: (context, index) {
        final RewardsDetailsModel reward = snapshot.rewardTypes[index];
        final String categoryName = snapshot.keys[index];
        return Container(
          color: index % 2 == 0 ? TABLE_ROW_GRAY_COLOR : WHITE,
          child: Row(
            children: [
              rewardCategory(reward, categoryName),
              pointsListView(reward.points)
            ],
          ),
        );
      },
    );
  }

  Widget rewardCategory(RewardsDetailsModel reward, String label) {
    return Container(
      height: width * 0.23,
      width: width / 5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
        color: ACCENT_GRAY,
        width: 0.5,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            reward.asset,
            height: width * 0.11,
            width: width * 0.11,
          ),
          SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 10,
              color: DARK_PINK_COLOR,
              fontWeight: FontWeight.w800,
            ),
          )
        ],
      ),
    );
  }

  Widget pointsListView(List<PointsModel> points) {
    return SizedBox(
      height: width * 0.23,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: points.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final PointsModel data = points[index];
          return Container(
            height: width * 0.25,
            width: width / 5,
            decoration: BoxDecoration(
                border: Border.all(
              color: ACCENT_GRAY,
              width: 0.5,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       data.rating.toString(),
                //       style: _theme.textTheme.bodyText2!.copyWith(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     Icon(
                //       Icons.star,
                //       size: 12,
                //       color: DARK_PINK_COLOR,
                //     )
                //   ],
                // ),
                Text(
                  data.hrs,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
