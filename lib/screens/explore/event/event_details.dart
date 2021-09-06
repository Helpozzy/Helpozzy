import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/screens/explore/event/event_sign_up.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({required this.event});
  final EventModel event;
  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late double height;
  late double width;
  TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  eventOrganizer(),
                  aboutOraganizer(),
                  overviewDetails(),
                  eventDetails(),
                  scheduleTimeAndLocation(),
                  infoSection(),
                  reviewSection(),
                  reviewCard(),
                  reviewList(),
                ],
              ),
            ),
          ),
          Container(
            height: 43,
            width: width,
            margin: EdgeInsets.symmetric(vertical: 18, horizontal: width / 4),
            child: CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventSignUpScreen(),
                  ),
                );
              },
              text: SIGN_UP,
            ),
          ),
        ],
      ),
    );
  }

  Widget eventOrganizer() {
    return Stack(
      children: [
        Container(
          height: height / 3,
          width: double.infinity,
          child: Image.asset(
            widget.event.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: height / 3,
          width: double.infinity,
          color: BLUR_GRAY,
        ),
        Positioned(
          left: 15,
          top: 6,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.chevron_left,
              color: WHITE,
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 33,
          child: Text(
            widget.event.organization,
            style: TextStyle(
              fontSize: 25,
              color: WHITE,
              fontFamily: QUICKSAND,
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 18,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                itemSize: 18,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: WHITE,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: AMBER_COLOR,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              Text(
                '(${widget.event.reviewCount} Reviews)',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: QUICKSAND,
                  color: WHITE,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 17,
          bottom: 11,
          child: widget.event.isLiked
              ? Icon(Icons.favorite_rounded, color: Colors.red, size: 19)
              : Icon(
                  Icons.favorite_border_rounded,
                  color: WHITE,
                  size: 19,
                ),
        )
      ],
    );
  }

  Widget aboutOraganizer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event.dateTime,
            style: TextStyle(
              fontSize: 16,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.event.eventName,
            style: TextStyle(
              fontSize: 22,
              fontFamily: QUICKSAND,
              color: BLUE_GRAY,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              ABOUT_ORGANIZER,
              style: TextStyle(
                fontSize: 15,
                fontFamily: QUICKSAND,
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              widget.event.aboutOrganizer,
              style: TextStyle(
                fontSize: 13,
                fontFamily: QUICKSAND,
                color: PRIMARY_COLOR,
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
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
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
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget eventDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              EVENT_DETAILS,
              style: TextStyle(
                fontSize: 15,
                fontFamily: QUICKSAND,
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              widget.event.eventDetails,
              style: TextStyle(
                fontSize: 13,
                fontFamily: QUICKSAND,
                color: PRIMARY_COLOR,
              ),
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
          Text(
            SCHEDULES,
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Thu , Dec 31 2020 10:30 AM - 4:30 PM',
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '(Schedules are allocated on slots basics)',
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            DIRECTION,
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.directions_car_filled_outlined,
                size: 15,
                color: DARK_GRAY,
              ),
              SizedBox(width: 5),
              Text(
                '12 mins drive',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: QUICKSAND,
                  color: DARK_GRAY,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '3.2 mil',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: QUICKSAND,
                  color: DARK_GRAY,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '7600 Amador Valley Blvd, Dublin, CA 94568',
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          CommonDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Contact Dublin Senior Center',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: QUICKSAND,
                    color: PRIMARY_COLOR,
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
            style: TextStyle(
              fontSize: 14,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          infoMenu(
            icon: Icons.language_rounded,
            text: 'Visit Website',
          ),
          infoMenu(
            icon: Icons.image_outlined,
            text: 'Event Photos',
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
            style: TextStyle(
              fontSize: 13,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
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
            style: TextStyle(
              fontSize: 13,
              fontFamily: QUICKSAND,
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Volunteers rated this non-profit highly for the work\nResponsiveness and professionalism',
            style: TextStyle(
              fontSize: 12,
              fontFamily: QUICKSAND,
              color: DARK_GRAY,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewCard() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CommonUserPlaceholder(),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Smith',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: QUICKSAND,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Dublin, CA 94568',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: QUICKSAND,
                        color: LIGHT_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                itemSize: 18,
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
            Container(
              height: 35,
              width: width / 2,
              child: TextField(
                style: TextStyle(
                    color: BLACK, fontFamily: QUICKSAND, fontSize: 11),
                controller: _reviewController,
                decoration: reviewFieldDecoration(),
              ),
            ),
          ],
        ),
      ),
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
      hintStyle: TextStyle(color: GRAY, fontFamily: QUICKSAND, fontSize: 11),
    );
  }

  Widget reviewList() {
    final snapShot = Reviews(list: reviewData);
    return ListView.builder(
      shrinkWrap: true,
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
                  CommonUserPlaceholder(),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: QUICKSAND,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        review.address,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: QUICKSAND,
                          color: LIGHT_GRAY,
                          fontWeight: FontWeight.bold,
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
                  minRating: 1,
                  itemSize: 18,
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
              review.reviewText != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        review.reviewText,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: QUICKSAND,
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
}
