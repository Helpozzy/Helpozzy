import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpozzy/bloc/review_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

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
  final TextEditingController _reviewController = TextEditingController();
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final ProjectReviewsBloc _projectReviewsBloc = ProjectReviewsBloc();
  final CommonUrlLauncher _commonUrlLauncher = CommonUrlLauncher();

  late GoogleMapController mapController;
  late double? addressLat = 0.0;
  late double? addressLong = 0.0;
  late double selectedRating = 0.0;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    getLatLong();
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _projectReviewsBloc.getProjectReviews(project.projectId);
    super.initState();
  }

  Future getLatLong() async {
    List<Location> locations = await locationFromAddress(project.location);
    addressLat = locations[0].latitude;
    addressLong = locations[0].longitude;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              aboutOraganizer(),
              overviewDetails(),
              projectDetails(),
              scheduleTimeAndLocation(),
              locationMap(),
              infoSection(),
              reviewSection(),
              reviewCard(),
              reviewList(),
            ],
          ),
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
                  'Contact ' + project.organization,
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
    final ReviewModel reviewModel = ReviewModel();
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
            padding: EdgeInsets.only(
                top: 10.0, left: width * 0.04, right: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CommonUserProfileOrPlaceholder(
                      size: width * 0.11,
                      imgUrl: snapshot.data!.profileUrl,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.name!,
                          style: _theme.textTheme.bodyText2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          snapshot.data!.address!,
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 10,
                            color: DARK_GRAY,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          itemSize: 15,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: LIGHT_GRAY,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: AMBER_COLOR),
                          onRatingUpdate: (rating) =>
                              setState(() => selectedRating = rating),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style:
                            _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                        controller: _reviewController,
                        decoration: reviewFieldDecoration(),
                        onChanged: (val) => setState(() =>
                            _reviewController.selection =
                                TextSelection.fromPosition(
                                    TextPosition(offset: val.length))),
                      ),
                    ),
                    _reviewController.text.isNotEmpty
                        ? SizedBox(width: 10)
                        : SizedBox(),
                    _reviewController.text.isNotEmpty
                        ? SmallCommonButton(
                            text: SUBMIT_BUTTON,
                            fontSize: 12,
                            onPressed: () async {
                              reviewModel.projectId = project.projectId;
                              reviewModel.reviewerId =
                                  prefsObject.getString(CURRENT_USER_ID);
                              reviewModel.address = snapshot.data!.address;
                              reviewModel.imageUrl = snapshot.data!.profileUrl;
                              reviewModel.name = snapshot.data!.name;
                              reviewModel.rating = selectedRating;
                              reviewModel.timeStamp = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              reviewModel.reviewText = _reviewController.text;
                              final bool response = await _projectReviewsBloc
                                  .postReview(reviewModel);

                              if (response) {
                                showSnakeBar(context,
                                    msg: REVIEW_POSTED_POPUP_MSG);
                                _projectReviewsBloc
                                    .getProjectReviews(project.projectId);
                              } else {
                                showSnakeBar(context,
                                    msg: REVIEW_NOT_POSTED_ERROR_POPUP_MSG);
                              }
                            },
                          )
                        : SizedBox(),
                  ],
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
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
      hintStyle:
          _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY, fontSize: 12),
    );
  }

  Widget reviewList() {
    return StreamBuilder<Reviews>(
      stream: _projectReviewsBloc.getProjectReviewsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: LinearLoader(minheight: 12),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.reviews.length,
          itemBuilder: (context, index) {
            final ReviewModel review = snapshot.data!.reviews[index];
            return Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonUserProfileOrPlaceholder(
                        size: width * 0.11,
                        imgUrl: review.imageUrl,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.name!,
                            style: _theme.textTheme.bodyText2!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            review.address!,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 10,
                              color: DARK_GRAY,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            itemSize: 15,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            unratedColor: LIGHT_GRAY,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) =>
                                Icon(Icons.star, color: AMBER_COLOR),
                            onRatingUpdate: (rating) => print(rating),
                          ),
                        ],
                      ),
                    ],
                  ),
                  review.reviewText!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          child: Text(
                            review.reviewText!,
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
      },
    );
  }

  Widget locationMap() {
    return Container(
      height: height / 3.5,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: width * 0.05),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer()),
              },
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              mapType: MapType.normal,
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController controller) async {
                mapController = controller;
                final int markerIdVal1 = generateIds();
                final MarkerId markerId = MarkerId(markerIdVal1.toString());
                final Marker marker1 = Marker(
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  markerId: markerId,
                  onTap: () {},
                  position: LatLng(addressLat!, addressLong!),
                  infoWindow: InfoWindow(
                      title: project.projectName, snippet: project.location),
                );
                _markers.add(marker1);
                mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(addressLat!, addressLong!),
                      zoom: 11,
                    ),
                  ),
                );
              },
              mapToolbarEnabled: false,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(addressLat!, addressLong!),
                zoom: 11.0,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                onPressed: () async => await _commonUrlLauncher.openSystemMap(
                    addressLat!, addressLong!),
                icon: Icon(
                  Icons.directions,
                  color: GREEN,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
