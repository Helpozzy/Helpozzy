import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpozzy/bloc/review_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:readmore/readmore.dart';

class ProjectDetailsTab extends StatefulWidget {
  ProjectDetailsTab({required this.project});
  final ProjectModel project;
  @override
  _ProjectDetailsTabState createState() =>
      _ProjectDetailsTabState(project: project);
}

class _ProjectDetailsTabState extends State<ProjectDetailsTab> {
  _ProjectDetailsTabState({required this.project});
  final ProjectModel project;
  late double height;
  late double width;
  late ThemeData _theme;
  final TextEditingController _reviewController = TextEditingController();
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final ProjectReviewsBloc _projectReviewsBloc = ProjectReviewsBloc();
  final CommonUrlLauncher _commonUrlLauncher = CommonUrlLauncher();
  late GoogleMapController mapController;
  late double selectedRating = 0.0;
  final Set<Marker> _markers = {};
  Future _mapFuture = Future.delayed(Duration(seconds: 2), () => true);

  @override
  void initState() {
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _projectReviewsBloc.getProjectReviews(project.projectId!);
    super.initState();
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
              projectDetails(),
              locationMap(),
              // infoSection(),
              reviewSection(),
              reviewCard(),
              reviewList(),
            ],
          ),
        ),
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
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              PROJECT_DETAILS,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: ReadMoreText(
              project.description!,
              trimLines: 4,
              colorClickableText: BLUE_COLOR,
              trimMode: TrimMode.Line,
              trimCollapsedText: SHOW_MORE,
              trimExpandedText: SHOW_LESS,
              moreStyle: _theme.textTheme.bodyText2!.copyWith(fontSize: 12),
            ),
          ),
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
            icon: CupertinoIcons.photo_on_rectangle,
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
          Icon(icon, size: 20, color: DARK_PINK_COLOR),
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
            REVIEW_SUBTITLE,
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
            child: LinearLoader(),
          );
        }
        return Card(
          elevation: 3,
          margin:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.04),
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
                      size: width * 0.10,
                      imgUrl: snapshot.data!.profileUrl,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.firstName!,
                            style: _theme.textTheme.bodyText2!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                color: DARK_GRAY,
                                size: 14,
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data!.address!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    fontSize: 10,
                                    color: DARK_GRAY,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          RatingBar.builder(
                            initialRating: selectedRating,
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
                            onPressed: () async => onPostReview(snapshot.data!),
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

  Future onPostReview(SignUpAndUserModel data) async {
    final ReviewModel reviewModel = ReviewModel();
    reviewModel.projectId = project.projectId;
    reviewModel.reviewerId = prefsObject.getString(CURRENT_USER_ID);
    reviewModel.address = data.address;
    reviewModel.imageUrl = data.profileUrl;
    reviewModel.name = data.firstName;
    reviewModel.rating = selectedRating;
    reviewModel.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    reviewModel.reviewText = _reviewController.text;
    final ResponseModel response =
        await _projectReviewsBloc.postReview(reviewModel);

    if (response.status!) {
      ScaffoldSnakBar().show(context, msg: response.message!);
      selectedRating = 0.0;
      _reviewController.clear();
      setState(() {});
      _projectReviewsBloc.getProjectReviews(project.projectId!);
    } else {
      ScaffoldSnakBar().show(context, msg: response.error!);
    }
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
            child: LinearLoader(),
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
                        size: width * 0.10,
                        imgUrl: review.imageUrl,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.name!,
                              style: _theme.textTheme.bodyText2!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.location,
                                  color: DARK_GRAY,
                                  size: 14,
                                ),
                                Expanded(
                                  child: Text(
                                    review.address!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: _theme.textTheme.bodyText2!.copyWith(
                                      fontSize: 10,
                                      color: DARK_GRAY,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            RatingBar.builder(
                              initialRating: review.rating!,
                              minRating: 1,
                              itemSize: 15,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              unratedColor: LIGHT_GRAY,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) =>
                                  Icon(Icons.star, color: AMBER_COLOR),
                              onRatingUpdate: (rating) => print(rating),
                            ),
                          ],
                        ),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DIRECTION,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          FutureBuilder(
            future: _mapFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: LinearLoader(),
                );
              }
              return Container(
                height: height / 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GoogleMap(
                        gestureRecognizers: <
                            Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer()),
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        mapType: MapType.normal,
                        indoorViewEnabled: true,
                        onMapCreated: (GoogleMapController controller) async {
                          mapController = controller;
                          final int markerIdVal = generateIds();
                          final MarkerId markerId =
                              MarkerId(markerIdVal.toString());
                          final Marker marker = Marker(
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen),
                            markerId: markerId,
                            position: LatLng(
                              project.projectLocationLati!,
                              project.projectLocationLongi!,
                            ),
                            infoWindow: InfoWindow(
                              title: project.projectName,
                              snippet: project.location,
                            ),
                          );
                          _markers.add(marker);
                          setState(() {});
                        },
                        mapToolbarEnabled: false,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            project.projectLocationLati!,
                            project.projectLocationLongi!,
                          ),
                          zoom: 11.0,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: FloatingActionButton(
                        mini: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: WHITE,
                        onPressed: () async =>
                            await _commonUrlLauncher.openSystemMap(
                          project.projectLocationLati!,
                          project.projectLocationLongi!,
                        ),
                        child: Icon(CupertinoIcons.arrow_up_right_diamond_fill,
                            size: 25, color: GREEN),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
