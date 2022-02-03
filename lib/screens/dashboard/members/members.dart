import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MembersScreen extends StatefulWidget {
  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MembersBloc _membersBloc = MembersBloc();
  late double width;
  late double height;
  late ThemeData _theme;
  late bool favVolunteers = false;

  @override
  void initState() {
    _membersBloc.searchMembers(searchText: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(context).show(
        elevation: 0,
        title: MEMBERS_APPBAR,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: body(),
    );
  }

  Widget body() {
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: CommonRoundedTextfield(
              fillColor: GRAY,
              controller: _searchController,
              hintText: SEARCH_MEMBERS_HINT,
              textAlignCenter: false,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: PRIMARY_COLOR,
              ),
              validator: (val) {
                return null;
              },
              onChanged: (val) {
                _membersBloc.searchMembers(searchText: val);
              },
            ),
          ),
          volunteerFilteringSection(),
          Expanded(child: membersList()),
        ],
      ),
    );
  }

  Widget volunteerFilteringSection() {
    return Row(
      children: [
        selectShowOption(
          buttonText: FILTERS_HINT,
          icon: Icons.tune_rounded,
          buttonColor: GRAY,
          borderColor: PRIMARY_COLOR,
          iconColor: PRIMARY_COLOR,
          fontColor: PRIMARY_COLOR,
          onPressed: () {},
        ),
        popupButton(),
        StreamBuilder<bool>(
            initialData: favVolunteers,
            stream: _membersBloc.getFavVolunteersStream,
            builder: (context, snapshot) {
              return selectShowOption(
                buttonText: FAVORITE_HINT,
                buttonColor: snapshot.data! ? PRIMARY_COLOR : GRAY,
                borderColor: snapshot.data! ? WHITE : PRIMARY_COLOR,
                iconColor: snapshot.data! ? WHITE : PRIMARY_COLOR,
                fontColor: snapshot.data! ? WHITE : PRIMARY_COLOR,
                icon: Icons.favorite_border_rounded,
                onPressed: () {
                  favVolunteers = !favVolunteers;
                  _membersBloc.changeFavVal(favVolunteers);
                },
              );
            }),
      ],
    );
  }

  Widget popupButton() {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: selectShowOption(
        buttonText: SORT_BY_HINT,
        buttonColor: GRAY,
        borderColor: PRIMARY_COLOR,
        iconColor: PRIMARY_COLOR,
        fontColor: PRIMARY_COLOR,
        icon: Icons.keyboard_arrow_down_rounded,
      ),
      onSelected: (item) async => await handleClick(item),
      itemBuilder: (context) => [
        popupMenuItem(text: NAME_TEXT, value: 0),
        PopupMenuDivider(height: 0.1),
        popupMenuItem(text: RATING_TEXT, value: 1),
        PopupMenuDivider(height: 0.1),
        popupMenuItem(text: REVIEWS_TEXT, value: 2),
      ],
    );
  }

  PopupMenuItem<int> popupMenuItem(
          {required String text, required int value}) =>
      PopupMenuItem<int>(
        value: value,
        child: Text(
          text,
          style: _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
        ),
      );

  Future handleClick(int item) async {
    switch (item) {
      case 0:
        _membersBloc.sortMembersByName();
        break;
      case 1:
        _membersBloc.sortMembersByRating();
        break;
      case 2:
        _membersBloc.sortMembersByReviewedPersons();
        break;
    }
  }

  Widget selectShowOption({
    required String buttonText,
    required IconData icon,
    void Function()? onPressed,
    required Color buttonColor,
    required Color borderColor,
    required Color fontColor,
    required Color iconColor,
  }) {
    return Container(
      width: width / 3,
      child: Transform.scale(
        scale: 0.6,
        child: CommonButtonWithIcon(
          icon: icon,
          text: buttonText,
          onPressed: onPressed,
          fontSize: 16,
          buttonColor: buttonColor,
          fontColor: fontColor,
          iconColor: iconColor,
        ),
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
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final SignUpAndUserModel volunteer = snapshot.data[index];
            return StreamBuilder<bool>(
              initialData: favVolunteers,
              stream: _membersBloc.getFavVolunteersStream,
              builder: (context, snapshot) {
                return snapshot.data!
                    ? volunteer.favorite!
                        ? memberItem(volunteer: volunteer)
                        : SizedBox()
                    : memberItem(volunteer: volunteer);
              },
            );
          },
        );
      },
    );
  }

  Widget memberItem({required SignUpAndUserModel volunteer}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.035, horizontal: width * 0.04),
        child: Row(
          children: [
            CommonUserProfileOrPlaceholder(
              size: width * 0.11,
              imgUrl: volunteer.profileUrl,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    volunteer.name!,
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    volunteer.address!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, right: 5.0),
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
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      Text(
                        '(${volunteer.reviewsByPersons} Reviews)',
                        style:
                            _theme.textTheme.bodyText2!.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      volunteer.favorite = !volunteer.favorite!;
                    });
                  },
                  child: Icon(
                    volunteer.favorite!
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: volunteer.favorite! ? PINK_COLOR : BLACK,
                    size: 16,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    CupertinoIcons.chat_bubble_2_fill,
                    color: BLACK,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
