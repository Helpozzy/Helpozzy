import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

class MemberTabCard extends StatelessWidget {
  MemberTabCard({Key? key, required this.volunteer}) : super(key: key);
  final SignUpAndUserModel volunteer;
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  Widget build(BuildContext context) {
    late ThemeData _theme = Theme.of(context);
    late double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: width * 0.035,
        horizontal: width * 0.04,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: CommonUserProfileOrPlaceholder(
              size: width * 0.11,
              borderColor: volunteer.presence! ? GREEN : PRIMARY_COLOR,
              imgUrl: volunteer.profileUrl,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer.firstName! + ' ' + volunteer.lastName!,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  _dateFormatFromTimeStamp
                      .getPastTimeFromCurrent(volunteer.lastSeen!),
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 9,
                    color: UNSELECTED_TAB_COLOR,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      size: width * 0.03,
                    ),
                    Expanded(
                      child: Text(
                        volunteer.address!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            _theme.textTheme.bodyText2!.copyWith(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async =>
                      CommonUrlLauncher().launchCall(volunteer.personalPhnNo!),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.phone,
                      color: BLACK,
                      size: 20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.chat_bubble_text,
                      color: BLACK,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
