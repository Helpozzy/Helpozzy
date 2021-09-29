import 'package:flutter/material.dart';
import 'package:helpozzy/models/user_rewards_model.dart';
import 'package:helpozzy/utils/constants.dart';

class AcceptGiftScreen extends StatefulWidget {
  AcceptGiftScreen({required this.people});
  final PeopleModel people;
  @override
  _AcceptGiftScreenState createState() => _AcceptGiftScreenState();
}

class _AcceptGiftScreenState extends State<AcceptGiftScreen> {
  late ThemeData _theme;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '+${widget.people.pointGifted} Points',
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: width / 13,
                    color: PINK_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.card_giftcard_rounded,
                color: PINK_COLOR,
                size: height / 4.0,
              ),
              SizedBox(height: 14.0),
              Text(
                'Gift From ${widget.people.name}',
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: width / 20,
                  color: PINK_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: height / 11,
            width: double.infinity,
            alignment: Alignment.center,
            color: PINK_COLOR,
            child: Text(
              ACCEPT_GIFT,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: width / 15,
                color: WHITE,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
