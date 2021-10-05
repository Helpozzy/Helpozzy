import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/event_bloc.dart';
import 'package:helpozzy/bloc/event_categories_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/user/common_screen.dart';
import 'package:helpozzy/screens/user/explore/event/categorised_event_list.dart';
import 'package:helpozzy/screens/user/explore/event/event_details.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final CategoryBloc _categoryBloc = CategoryBloc();
  final EventsBloc _eventsBloc = EventsBloc();

  @override
  void initState() {
    final uId = prefsObject.getString('uID');
    _userInfoBloc.getUser(uId!);
    _categoryBloc.getCategories();
    _eventsBloc.getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return SafeArea(
      child: StreamBuilder<UserModel>(
        stream: _userInfoBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LinearLoader(minheight: 15),
            );
          }
          final UserModel? user = snapshot.data;
          final DateTime date = DateTime.fromMicrosecondsSinceEpoch(
              user!.dateOfBirth!.seconds * 1000);
          final dob = DateFormat('MMM yyyy').format(date);
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 15.0),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: PRIMARY_COLOR,
                          ),
                          child: CommonUserPlaceholder(size: width / 5),
                        ),
                      ),
                      Center(
                        child: Text(
                          user.name,
                          style: _theme.textTheme.headline6!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people_alt_outlined, size: 16),
                              SizedBox(width: 2),
                              Text(
                                '2 Reviews',
                                style: _theme.textTheme.bodyText2!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: DARK_GRAY_FONT_COLOR,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            dob,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: DARK_GRAY_FONT_COLOR,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '10 Hours',
                                style: _theme.textTheme.bodyText2!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: DARK_GRAY_FONT_COLOR,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.arrow_forward_ios_rounded, size: 14)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommonSampleScreen(
                                    'Edit Profile\nComing Soon'),
                              ),
                            );
                          },
                          child: Text(
                            'Edit Profile',
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: BLUE_GRAY,
                            ),
                          ),
                        ),
                      ),
                      CommonDividerWith(
                        height: 1,
                        color: DARK_GRAY,
                      ),
                      address(user),
                      CommonDividerWith(
                        height: 1,
                        color: DARK_GRAY,
                      ),
                      aboutMe(),
                      CommonDividerWith(
                        height: 1,
                        color: DARK_GRAY,
                      ),
                      projectPref(),
                    ],
                  ),
                ),
                ownEventsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget address(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            user.address,
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              CommonUrlLauncher().launchCall(user.personalPhnNo);
            },
            child: Row(
              children: [
                Text(
                  CONTACT_TEXT,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 3),
                Icon(CupertinoIcons.phone)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutMe() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              SAMPLE_LONG_TEXT,
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget projectPref() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Prefrences',
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          StreamBuilder<Categories>(
            stream: _categoryBloc.getCategoriesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                _categoryBloc.getCategories();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: LinearLoader(minheight: 12)),
                );
              }
              return Container(
                height: width * 0.25,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.item.map((category) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorisedEventsScreen(
                                categoryId: category.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                category.imgUrl,
                                fit: BoxFit.fill,
                                height: width * 0.09,
                                width: width * 0.09,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              category.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: QUICKSAND,
                                color: PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget ownEventsList() {
    return StreamBuilder<Events>(
      stream: _eventsBloc.getEventsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _eventsBloc.getEvents();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader(minheight: 12)),
          );
        }
        final List<EventModel> events = snapshot.data!.events;
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: GRAY,
              padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed Projects',
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    events.length.toString(),
                    style: _theme.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final EventModel event = events[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(event: event),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: width * 0.04),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.eventName,
                                  style: TextStyle(
                                    fontFamily: QUICKSAND,
                                    color: BLUE_GRAY,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  event.organization,
                                  style: TextStyle(
                                    fontFamily: QUICKSAND,
                                    color: DARK_GRAY,
                                  ),
                                ),
                                Text(
                                  event.dateTime,
                                  style: TextStyle(
                                    fontFamily: QUICKSAND,
                                    color: BLUE,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CommonDivider(),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                      CommonDivider(),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
