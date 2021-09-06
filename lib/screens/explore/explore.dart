import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/event_bloc.dart';
import 'package:helpozzy/bloc/event_categories_bloc.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/screens/explore/event/categorised_event_list.dart';
import 'package:helpozzy/screens/rewards/rewards.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:timelines/timelines.dart';
import 'event/event_sign_up.dart';
import 'event/event_details.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  int _processIndex = 2;
  bool boo = true;
  late Animation<double> animation;
  late AnimationController controller;
  TextEditingController _searchController = TextEditingController();
  final CategoryBloc _categoryBloc = CategoryBloc();
  final EventsBloc _eventsBloc = EventsBloc();

  @override
  void initState() {
    super.initState();
    _eventsBloc.getEvents();
    _categoryBloc.getCategories();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 280).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Color getColor(int index) {
    if (index == _processIndex) {
      return AMBER_COLOR;
    } else if (index < _processIndex) {
      return AMBER_COLOR;
    } else {
      return LIGHT_GRAY;
    }
  }

  void animateTextfield() {
    setState(() {
      if (boo == true) {
        controller.forward();
      } else {
        controller.reverse();
      }
      boo = !boo;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        controller.reverse();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topImageView(),
            Divider(
              color: TRANSPARENT_BLACK,
              height: 1,
            ),
            targetGoalSection(),
            CommonDivider(),
            categoryView(),
            CommonDivider(),
            eventListView(),
          ],
        ),
      ),
    );
  }

  Widget topImageView() {
    return Stack(
      children: [
        Container(
          height: height / 3,
          width: double.infinity,
          child: Image.asset(
            'assets/images/explore_img.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: height / 3,
          width: double.infinity,
          color: TRANSPARENT_BLACK,
        ),
        animation.value == 0
            ? Positioned(
                top: 29,
                left: 19,
                child: GestureDetector(
                  onTap: animateTextfield,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: TRANSPARENT_WHITE),
                      borderRadius: BorderRadius.circular(25),
                      color: WHITE.withOpacity(0.23),
                    ),
                    child: Icon(Icons.search),
                  ),
                ),
              )
            : Positioned(
                top: 29,
                left: 19,
                child: Container(
                  width: animation.value,
                  height: 35,
                  child: TextField(
                    onTap: _modalBottomSheetMenu,
                    decoration: InputDecoration(
                      hintText: SEARCH_HINT,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        color: DARK_GRAY,
                        fontFamily: QUICKSAND,
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: WHITE.withOpacity(0.23),
                      prefixIcon: GestureDetector(
                        onTap: animateTextfield,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(Icons.search, color: BLACK, size: 25),
                        ),
                      ),
                      enabledBorder: searchBarDecoration(),
                      disabledBorder: searchBarDecoration(),
                      focusedBorder: searchBarDecoration(),
                      border: searchBarDecoration(),
                    ),
                  ),
                ),
              ),
        Positioned(
          bottom: 30,
          left: 21,
          child: Text(
            MSG_DASHBOARD,
            style: TextStyle(
              fontSize: height / 18,
              color: WHITE,
              fontFamily: QUICKSAND,
            ),
          ),
        ),
      ],
    );
  }

  InputBorder searchBarDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: TRANSPARENT_WHITE),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(11.0),
          topRight: const Radius.circular(11.0),
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 23,
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              bottomSheetSearchbar(),
              currentLocationCard(),
              searchList(),
            ],
          ),
        );
      },
    );
  }

  Widget bottomSheetSearchbar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: SEARCH_HINT,
        hintStyle: TextStyle(
          fontSize: 17,
          color: DARK_GRAY,
          fontFamily: QUICKSAND,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 3, left: 12),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: BLACK,
            ),
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 3, right: 10),
          child: IconButton(
            onPressed: () {
              _searchController.clear();
            },
            icon: Icon(
              Icons.close_rounded,
              color: BLACK,
              size: 25,
            ),
          ),
        ),
        enabledBorder: bottomSheetSearchBarDecoration(),
        disabledBorder: bottomSheetSearchBarDecoration(),
        focusedBorder: bottomSheetSearchBarDecoration(),
        border: bottomSheetSearchBarDecoration(),
      ),
    );
  }

  Widget currentLocationCard() {
    final BorderSide border = BorderSide(color: DIVIDER_COLOR, width: 0.3);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: WHITE,
          border: Border(left: border, right: border, bottom: border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: SHADOW_GRAY,
              offset: Offset(0.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: 0.5,
            ), //Bo//BoxShado
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 21.0, right: 8.0),
              child: Icon(Icons.pin_drop_outlined),
            ),
            Text(
              CURRENT_LOCATION,
              style: TextStyle(
                fontSize: 17,
                color: BLUE,
                fontFamily: QUICKSAND,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputBorder bottomSheetSearchBarDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(31.0),
        topRight: const Radius.circular(31.0),
      ),
      borderSide: BorderSide(
        color: DIVIDER_COLOR,
        width: 0.3,
      ),
    );
  }

  Widget searchList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventStrings.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Icon(Icons.search),
                    ),
                    Text(
                      eventStrings[index],
                      style: TextStyle(
                        fontSize: 17,
                        color: DARK_GRAY,
                        fontFamily: QUICKSAND,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: DIVIDER_COLOR,
                height: 0.3,
                endIndent: 5,
                indent: 5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget targetGoalSection() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Text(
              MSG_GOAL,
              style: TextStyle(
                fontSize: 15,
                color: DARK_GRAY_FONT_COLOR,
                fontFamily: QUICKSAND,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              children: [
                Text(
                  '35',
                  style: TextStyle(
                    fontSize: 21,
                    color: DARK_GRAY_FONT_COLOR,
                    fontFamily: QUICKSAND,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.star),
              ],
            ),
          ),
          timelineProgress(),
          detailsRedeemButton(),
        ],
      ),
    );
  }

  Widget timelineProgress() {
    return Container(
      height: height / 12,
      width: double.infinity,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            thickness: 3.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (ctx, index) =>
              MediaQuery.of(context).size.width / items.length,
          contentsBuilder: (ctx, index) {
            return Text(
              '${items[index]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColor(index),
              ),
            );
          },
          indicatorBuilder: (ctx, index) {
            var color;
            if (index == _processIndex) {
              color = AMBER_COLOR;
            } else if (index < _processIndex) {
              color = AMBER_COLOR;
            } else {
              color = LIGHT_GRAY;
            }

            if (index <= _processIndex) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: color,
                    ),
                  ),
                  DotIndicator(
                    size: 10.0,
                    color: color,
                  ),
                ],
              );
            } else {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: color,
                    ),
                  ),
                  DotIndicator(
                    size: 10.0,
                    color: color,
                  ),
                ],
              );
            }
          },
          connectorBuilder: (ctx, index, type) {
            if (index > 0) {
              if (index == _processIndex) {
                final color = getColor(index);
                return DecoratedLineConnector(
                  decoration: BoxDecoration(color: color),
                );
              } else {
                return SolidLineConnector(
                  color: getColor(index),
                );
              }
            } else {
              return null;
            }
          },
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget detailsRedeemButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 15, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomButton(
            fontSize: 11,
            text: DETAILS,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RewardsScreen(initialIndex: 0),
                  ));
            },
          ),
          SizedBox(width: 7),
          CustomButton(
            fontSize: 11,
            text: REDEEM,
            color: LIGHT_MARUN,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget categoryView() {
    return StreamBuilder<Categories>(
        stream: _categoryBloc.getCategoriesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: LinearLoader(minheight: 12)),
            );
          }
          return GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            childAspectRatio: 0.85,
            padding: const EdgeInsets.all(10.0),
            children: snapshot.data!.item.map((CategoryModel category) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategorisedEventsScreen(categoryId: category.id),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        category.imgUrl,
                        fit: BoxFit.fill,
                        height: 50,
                        width: 50,
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
              );
            }).toList(),
          );
        });
  }

  Widget eventListView() {
    return StreamBuilder<Events>(
        stream: _eventsBloc.getEventsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: LinearLoader(minheight: 12)),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            itemCount: snapshot.data!.events.length,
            itemBuilder: (context, index) {
              final EventModel event = snapshot.data!.events[index];
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                                      : Icon(
                                          Icons.favorite_border_rounded,
                                          color: DARK_GRAY,
                                          size: 19,
                                        ),
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
                                    itemSize: width / 20.5,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    unratedColor: GRAY,
                                    itemCount: 5,
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
                                          builder: (context) =>
                                              EventSignUpScreen(),
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
            },
          );
        });
  }
}
