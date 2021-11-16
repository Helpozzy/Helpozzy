import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_volunteer_bloc.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/helper/rewards_helper.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/screens/user/explore/user_project/categorised_projects_list.dart';
import 'package:helpozzy/screens/user/explore/search_bar/search_project.dart';
import 'package:helpozzy/screens/user/explore/user_project/project_details.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_card.dart';
import 'package:helpozzy/screens/user/rewards/rewards.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/sliver_class.dart';
import 'package:timelines/timelines.dart';
import 'user_project/user_project_sign_up.dart';

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
  final CategoryBloc _categoryBloc = CategoryBloc();
  final MembersBloc _membersBloc = MembersBloc();
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();
  final scrollController = ScrollController();
  double currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _userProjectsBloc.getProjects();
    _categoryBloc.getCategories();
    _membersBloc.getMembers();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 350).animate(controller)
      ..addListener(() => setState(() {}));
    scrollController.addListener(() {
      setState(() => currentPosition = scrollController.offset);
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
      if (boo)
        controller.forward();
      else
        controller.reverse();
      boo = !boo;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: GestureDetector(
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
          controller.reverse();
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            topImageView(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  targetGoalSection(),
                  categoryView(),
                  projectListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topImageView() {
    return SliverPersistentHeader(
      pinned: currentPosition < height / 8.5 ? true : false,
      delegate: SliverAppBarDelegate(
        minHeight: height / 10,
        maxHeight: height / 3.5,
        child: Stack(
          children: [
            Container(
              height: height / 3.5,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    MATE_WHITE,
                    BLUE_GRAY,
                    PRIMARY_COLOR,
                  ],
                ),
              ),
            ),
            animation.value == 0
                ? Positioned(
                    top: 22,
                    left: 20,
                    child: GestureDetector(
                      onTap: animateTextfield,
                      child: Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: TRANSPARENT_WHITE),
                          borderRadius: BorderRadius.circular(25),
                          color: WHITE.withOpacity(0.23),
                        ),
                        child: Icon(
                          CupertinoIcons.search,
                          color: MATE_WHITE,
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    top: 22,
                    left: 20,
                    child: Container(
                      width: animation.value,
                      height: 38,
                      child: TextField(
                        onTap: () => SearchProject()
                            .modalBottomSheetMenu(context)
                            .then((value) => setState(() => boo = true)),
                        decoration: InputDecoration(
                          hintText: SEARCH_HINT,
                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: MATE_WHITE,
                            fontFamily: QUICKSAND,
                            fontWeight: FontWeight.w500,
                          ),
                          fillColor: WHITE.withOpacity(0.23),
                          prefixIcon: GestureDetector(
                            onTap: animateTextfield,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Icon(
                                CupertinoIcons.search,
                                color: MATE_WHITE,
                                size: 25,
                              ),
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
            currentPosition < height / 12
                ? Positioned(
                    bottom: 20,
                    left: 21,
                    child: Text(
                      MSG_DASHBOARD,
                      style: TextStyle(
                        fontSize: width / 12,
                        color: WHITE,
                        fontFamily: QUICKSAND,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  InputBorder searchBarDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: TRANSPARENT_WHITE),
    );
  }

  Widget targetGoalSection() {
    return StreamBuilder<UserRewardsDetailsHelper>(
      stream: _membersBloc.getuserRewardDetailsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _membersBloc.getMembers();
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: LinearLoader(minheight: 12),
          );
        }
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
                      snapshot.data!.totalPoint.toString(),
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
              timelineProgress(snapshot.data!),
              // detailsRedeemButton(),
            ],
          ),
        );
      },
    );
  }

  Widget timelineProgress(UserRewardsDetailsHelper? rewardsDetail) {
    _processIndex = rewardsDetail!.totalPoint;
    return Container(
      height: height / 12,
      width: double.infinity,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(thickness: 3.0),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (ctx, index) =>
              MediaQuery.of(context).size.width / items.length,
          contentsBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                '${items[index]}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: getColor(items[index]),
                ),
              ),
            );
          },
          indicatorBuilder: (ctx, index) {
            Color color;
            if (items[index] == _processIndex) {
              color = AMBER_COLOR;
            } else if (items[index] < _processIndex) {
              color = AMBER_COLOR;
            } else {
              color = LIGHT_GRAY;
            }

            if (items[index] <= _processIndex) {
              return Container(
                height: width * 0.04,
                width: width * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: color,
                ),
              );
            } else {
              return Container(
                height: width * 0.03,
                width: width * 0.03,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: color,
                ),
              );
            }
          },
          connectorBuilder: (ctx, index, type) {
            if (items[index] > 0) {
              if (items[index] == _processIndex) {
                final color = getColor(items[index]);
                return DecoratedLineConnector(
                  decoration: BoxDecoration(color: color),
                );
              } else {
                return SolidLineConnector(
                  color: getColor(items[index]),
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
      padding: EdgeInsets.only(left: width * 0.05, top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonButton(
            fontSize: 11,
            text: DETAILS,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RewardsScreen(initialIndex: 0, fromBottomBar: false),
                )),
          ),
          SizedBox(width: 7),
          CommonButton(
            fontSize: 11,
            text: REDEEM,
            color: LIGHT_MARUN,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RewardsScreen(initialIndex: 3, fromBottomBar: false),
              ),
            ),
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
            _categoryBloc.getCategories();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: LinearLoader(minheight: 12)),
            );
          }
          return Column(
            children: [
              Divider(),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                children: snapshot.data!.item.map((CategoryModel category) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorisedProjectsScreen(
                              categoryId: category.id),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => Center(
                            child: LinearLoader(minheight: 10),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline_rounded),
                          imageUrl: category.imgUrl,
                          fit: BoxFit.fill,
                          color: PRIMARY_COLOR,
                          height: width * 0.1,
                          width: width * 0.1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          category.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: QUICKSAND,
                            color: DARK_GRAY_FONT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
              Divider(),
            ],
          );
        });
  }

  Widget projectListView() {
    return StreamBuilder<Projects>(
      stream: _userProjectsBloc.getProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader(minheight: 12)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(5),
          itemCount: snapshot.data!.projectList.length,
          itemBuilder: (context, index) {
            final ProjectModel project = snapshot.data!.projectList[index];
            return UserProjectCard(
              project: project,
              onTapCard: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(project: project),
                ),
              ),
              onPressedSignUpButton: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectUserSignUpScreen(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
