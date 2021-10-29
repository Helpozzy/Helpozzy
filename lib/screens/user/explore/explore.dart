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
import 'package:helpozzy/screens/user/explore/user_project/user_project_card.dart';
import 'package:helpozzy/screens/user/rewards/rewards.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:timelines/timelines.dart';
import 'user_project/user_project_sign_up.dart';
import 'user_project/project_details.dart';

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

  @override
  void initState() {
    super.initState();
    _userProjectsBloc.getProjects();
    _categoryBloc.getCategories();
    _membersBloc.getMembers();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 350).animate(controller)
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
      if (boo) {
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
    return SafeArea(
      child: GestureDetector(
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
              projectListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topImageView() {
    return Stack(
      children: [
        Container(
          height: height / 4,
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
        Container(
          height: height / 4,
          width: double.infinity,
          color: TRANSPARENT_BLACK,
        ),
        animation.value == 0
            ? Positioned(
                top: 25,
                left: 20,
                child: GestureDetector(
                  onTap: animateTextfield,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: TRANSPARENT_WHITE),
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
                top: 25,
                left: 20,
                child: Container(
                  width: animation.value,
                  height: 38,
                  child: TextField(
                    onTap: () => SearchProject().modalBottomSheetMenu(context),
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
        Positioned(
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

  Widget targetGoalSection() {
    return StreamBuilder<UserRewardsDetailsHelper>(
        stream: _membersBloc.getuserRewardDetailsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
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
                detailsRedeemButton(),
              ],
            ),
          );
        });
  }

  Widget timelineProgress(UserRewardsDetailsHelper? rewardsDetail) {
    _processIndex = rewardsDetail!.totalPoint;
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
            Color color;
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
                )),
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
            physics: NeverScrollableScrollPhysics(),
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
                          CategorisedProjectsScreen(categoryId: category.id),
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
          itemCount: snapshot.data!.projects.length,
          itemBuilder: (context, index) {
            final ProjectModel project = snapshot.data!.projects[index];
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
