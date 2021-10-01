import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/admin/admin_volunteer_bloc.dart';
import 'package:helpozzy/models/user_rewards_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class VolunteerScreen extends StatefulWidget {
  VolunteerScreen({this.title});
  final String? title;
  @override
  _VolunteerScreenState createState() => _VolunteerScreenState(title: title);
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  _VolunteerScreenState({this.title});
  final String? title;

  final TextEditingController _searchController = TextEditingController();
  final VolunteersBloc _volunteersBloc = VolunteersBloc();
  late double width;
  late double height;
  late ThemeData _theme;
  late Stream volunteerStream;
  late bool favVolunteers = false;

  @override
  void initState() {
    _volunteersBloc.searchVolunteers(searchText: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(context).show(
          title: title!,
          elevation: 0,
          color: WHITE,
          textColor: PRIMARY_COLOR,
          onBackPressed: () {
            Navigator.of(context).pop();
          }),
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
            child: Card(
              elevation: 4,
              color: PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: CommonTextfield(
                controller: _searchController,
                hintText: ADMIN_SEARCH_HINT,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: PRIMARY_COLOR,
                ),
                validator: (val) {
                  return null;
                },
                onChanged: (val) {
                  _volunteersBloc.searchVolunteers(searchText: val);
                },
              ),
            ),
          ),
          volunteerFilteringSection(),
          Expanded(child: volunteerList()),
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
            stream: _volunteersBloc.getFavVolunteersStream,
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
                  _volunteersBloc.changeFavVal(favVolunteers);
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
        _volunteersBloc.sortVolunteersByName();
        break;
      case 1:
        _volunteersBloc.sortVolunteersByRating();
        break;
      case 2:
        _volunteersBloc.sortVolunteersByReviewedPersons();
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

  Widget volunteerList() {
    return StreamBuilder<dynamic>(
      stream: _volunteersBloc.getSearchedVolunteersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader(minheight: 12));
        }
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final PeopleModel volunteer = snapshot.data[index];
            return StreamBuilder<bool>(
              initialData: favVolunteers,
              stream: _volunteersBloc.getFavVolunteersStream,
              builder: (context, snapshot) {
                return snapshot.data!
                    ? volunteer.favorite
                        ? volunteerItem(volunteer: volunteer)
                        : SizedBox()
                    : volunteerItem(volunteer: volunteer);
              },
            );
          },
        );
      },
    );
  }

  Widget volunteerItem({required PeopleModel volunteer}) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              children: [
                CommonUserPlaceholder(size: width * 0.13),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      volunteer.name,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      volunteer.address,
                      style: _theme.textTheme.bodyText2!,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, right: 5.0),
                          child: RatingBar.builder(
                            initialRating: volunteer.rating,
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
                          style: _theme.textTheme.bodyText2!
                              .copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              setState(() {
                volunteer.favorite = !volunteer.favorite;
              });
            },
            icon: Icon(
              volunteer.favorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: volunteer.favorite ? PINK_COLOR : BLACK,
              size: 13,
            ),
          ),
        )
      ],
    );
  }
}