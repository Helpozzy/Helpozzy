import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectOtherDetailsScreen extends StatefulWidget {
  ProjectOtherDetailsScreen({required this.project});
  final ProjectModel project;
  @override
  _ProjectOtherDetailsScreenState createState() =>
      _ProjectOtherDetailsScreenState(project: project);
}

class _ProjectOtherDetailsScreenState extends State<ProjectOtherDetailsScreen> {
  _ProjectOtherDetailsScreenState({required this.project});
  final ProjectModel project;
  late double height;
  late double width;
  late ThemeData _theme;
  TextEditingController _reviewController = TextEditingController();
  UserInfoBloc _userInfoBloc = UserInfoBloc();

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString('uID')!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            aboutOraganizer(),
            overviewDetails(),
            projectDetails(),
            locationMap(),
            scheduleTimeAndLocation(),
            infoSection(),
            reviewSection(),
            reviewCard(),
            reviewList(),
          ],
        ),
      ),
    );
  }

  Widget aboutOraganizer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              ABOUT_ORGANIZER,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              project.aboutOrganizer,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 12,
                fontFamily: QUICKSAND,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget overviewDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OVERVIEW,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          overViewTile(
            icon: Icons.verified_outlined,
            text: 'Verified Non-Profit Organization',
          ),
          overViewTile(
            icon: Icons.schedule_rounded,
            text: '23 yrs in Service',
          ),
          overViewTile(
            icon: Icons.people_outlined,
            text: '15 Employees',
          ),
          overViewTile(
            icon: Icons.emoji_people_outlined,
            text: '75 Routine Volunteers',
          ),
        ],
      ),
    );
  }

  Widget overViewTile({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, size: 15),
          SizedBox(width: 7),
          Text(
            text,
            style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget projectDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              PROJECT_DETAILS,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              project.description,
              style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleTimeAndLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Contact Dublin Senior Center',
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.call_outlined,
                  size: 15,
                  color: DARK_GRAY,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.messenger_outline_rounded,
                    size: 15,
                    color: DARK_GRAY,
                  ),
                ),
              ],
            ),
          ),
          CommonDivider(),
        ],
      ),
    );
  }

  Widget infoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            INFO,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          infoMenu(
            icon: Icons.language_rounded,
            text: 'Visit Website',
          ),
          infoMenu(
            icon: Icons.image_outlined,
            text: 'Project Photos',
          ),
        ],
      ),
    );
  }

  Widget infoMenu({required String text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            text,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Icon(
            icon,
            size: 16,
            color: DARK_GRAY,
          ),
        ],
      ),
    );
  }

  Widget reviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            REVIEWS,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Volunteers rated this non-profit highly for the work\nResponsiveness and professionalism',
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewCard() {
    return StreamBuilder<SignUpAndUserModel>(
      stream: _userInfoBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LinearLoader(minheight: 12),
          );
        }
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: width * 0.04),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CommonUserProfileOrPlaceholder(size: 30),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.name!,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!.address!,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 12,
                            color: DARK_GRAY,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    itemSize: 18,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    unratedColor: LIGHT_GRAY,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: AMBER_COLOR),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                Container(
                  height: 35,
                  width: width / 2,
                  child: TextField(
                    style: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                    controller: _reviewController,
                    decoration: reviewFieldDecoration(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration reviewFieldDecoration() {
    return InputDecoration(
      hintText: REVIEW_HINT,
      contentPadding: EdgeInsets.only(bottom: 10.0),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      hintStyle:
          _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY, fontSize: 12),
    );
  }

  Widget reviewList() {
    final snapShot = Reviews(list: reviewData);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: snapShot.reviews.length,
      itemBuilder: (context, index) {
        final ReviewModel review = snapShot.reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommonUserProfileOrPlaceholder(size: 30),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        review.address,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: DARK_GRAY,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: RatingBar.builder(
                  initialRating: review.rating,
                  ignoreGestures: true,
                  minRating: 1,
                  itemSize: 18,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: LIGHT_GRAY,
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
              review.reviewText != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        review.reviewText,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: DARK_GRAY_FONT_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SizedBox(),
              CommonDivider(),
            ],
          ),
        );
      },
    );
  }

  Widget locationMap() {
    return Container(
      height: height / 4,
      width: width,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
