import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/event_bloc.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

import 'event_details.dart';
import 'event_sign_up.dart';

class CategorisedEventsScreen extends StatefulWidget {
  const CategorisedEventsScreen({required this.categoryId});
  final int categoryId;

  @override
  _CategorisedEventsScreenState createState() =>
      _CategorisedEventsScreenState();
}

class _CategorisedEventsScreenState extends State<CategorisedEventsScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  final EventsBloc _eventsBloc = EventsBloc();

  @override
  void initState() {
    _eventsBloc.getCategorisedEvents(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(title: 'Events'),
      body: eventListView(),
    );
  }

  Widget eventListView() {
    return StreamBuilder<Events>(
      stream: _eventsBloc.getCategorisedEventsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LinearLoader(minheight: 12),
            ),
          );
        }
        return snapshot.data!.events.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data!.events.length,
                itemBuilder: (context, index) {
                  final EventModel event = snapshot.data!.events[index];
                  return eventItem(event);
                },
              )
            : Center(
                child: Text('No events available..',
                    style: _theme.textTheme.headline6));
      },
    );
  }

  Widget eventItem(EventModel event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: event),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                child: Image.asset(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  height: height / 5,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          event.dateTime,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: QUICKSAND,
                            color: PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        event.isLiked
                            ? Icon(Icons.favorite_rounded,
                                color: Colors.red, size: 19)
                            : Icon(Icons.favorite_border_rounded,
                                color: DARK_GRAY, size: 19),
                      ],
                    ),
                    Text(
                      event.eventName,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: QUICKSAND,
                        color: BLUE_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      event.organization,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: QUICKSAND,
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: QUICKSAND,
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          itemSize: 18,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          unratedColor: GRAY,
                          itemCount: 5,
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
                          '(${event.reviewCount} Reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: QUICKSAND,
                            color: DARK_GRAY,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        CustomButton(
                          fontSize: 11,
                          text: SIGN_UP,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventSignUpScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
