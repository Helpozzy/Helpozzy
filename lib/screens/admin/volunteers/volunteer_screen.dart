import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/admin/volunteer_bloc.dart';
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

  @override
  void didChangeDependencies() {
    getList();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _volunteersBloc.getVolunteers();
    getList();
    super.initState();
  }

  Future getList() async {
    if (_searchController.text.isNotEmpty) {
      volunteerStream = _volunteersBloc.getSearchedVolunteersStream;
    } else {
      volunteerStream = _volunteersBloc.getVolunteersStream;
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
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
    return Column(
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
                getList();
                _volunteersBloc.searchVolunteers(val!);
              },
            ),
          ),
        ),
        volunteerList(),
      ],
    );
  }

  Widget volunteerList() {
    return StreamBuilder<dynamic>(
        stream: volunteerStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: LinearLoader(minheight: 12)),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            itemCount: snapshot.data.peoples.length,
            itemBuilder: (context, index) {
              final PeopleModel volunteer = snapshot.data.peoples[index];
              return Stack(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
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
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
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
                    top: 10,
                    right: 16,
                    child: Icon(
                      volunteer.favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: volunteer.favorite ? PINK_COLOR : BLACK,
                      size: 13,
                    ),
                  )
                ],
              );
            },
          );
        });
  }
}
