import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

class ProjectMembersTab extends StatefulWidget {
  @override
  _ProjectMembersTabState createState() => _ProjectMembersTabState();
}

class _ProjectMembersTabState extends State<ProjectMembersTab> {
  final TextEditingController _searchController = TextEditingController();
  final MembersBloc _membersBloc = MembersBloc();
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  late double width;
  late double height;
  late ThemeData _theme;

  @override
  void initState() {
    _membersBloc.searchMembers(searchText: '');
    super.initState();
  }

  String getLastSeen(String timeStamp) {
    final String lastseen =
        _dateFormatFromTimeStamp.getPastTimeFromCurrent(timeStamp);
    return lastseen;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(body: body());
  }

  Widget body() {
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Container(
            height: 34,
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 5.0,
            ),
            child: CommonRoundedTextfield(
              fillColor: GRAY,
              controller: _searchController,
              textAlignCenter: false,
              hintText: SEARCH_MEMBERS_HINT,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: DARK_GRAY,
                  size: 20,
                ),
              ),
              validator: (val) => null,
              onChanged: (val) => _membersBloc.searchMembers(searchText: val),
            ),
          ),
          CommonDivider(),
          Expanded(child: membersList()),
        ],
      ),
    );
  }

  Widget membersList() {
    return StreamBuilder<dynamic>(
      stream: _membersBloc.getSearchedMembersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return ListView.separated(
          separatorBuilder: (context, index) => CommonDivider(),
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final SignUpAndUserModel volunteer = snapshot.data[index];
            return memberItem(volunteer: volunteer);
          },
        );
      },
    );
  }

  Widget memberItem({required SignUpAndUserModel volunteer}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: width * 0.035, horizontal: width * 0.04),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: CommonUserProfileOrPlaceholder(
              size: width * 0.10,
              imgUrl: volunteer.profileUrl,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CommonBadge(
                      color: volunteer.presence! ? GREEN : RED_COLOR,
                      size: width * 0.02,
                    ),
                    SizedBox(width: 2),
                    Text(
                      volunteer.firstName! + ' ' + volunteer.lastName!,
                      style: _theme.textTheme.bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  getLastSeen(volunteer.lastSeen!),
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 10,
                    color: UNSELECTED_TAB_COLOR,
                  ),
                ),
                Text(
                  volunteer.address!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyText2!.copyWith(fontSize: 10),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                        bottom: 3.0,
                        right: 5.0,
                      ),
                      child: RatingBar.builder(
                        initialRating: volunteer.rating!,
                        ignoreGestures: true,
                        minRating: 1,
                        itemSize: 15,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        unratedColor: GRAY,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AMBER_COLOR,
                        ),
                        onRatingUpdate: (rating) => print(rating),
                      ),
                    ),
                    Text(
                      '(${volunteer.reviewsByPersons} Reviews)',
                      style: _theme.textTheme.bodyText2!.copyWith(fontSize: 10),
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
