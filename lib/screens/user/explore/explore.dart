import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/user/explore/user_project/categorised_projects_list.dart';
import 'package:helpozzy/screens/projects/user_project_tabs/other_details_tab.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_card.dart';
import 'package:helpozzy/screens/user/rewards/rewards.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/sliver_class.dart';
import 'package:timelines/timelines.dart';
import '../../projects/volunteer_project_sign_up.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  late ThemeData _themeData;
  late int _processIndex = 2;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final CategoryBloc _categoryBloc = CategoryBloc();
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late double currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _userInfoBloc.getUser(prefsObject.getString('uID')!);
    _categoryBloc.getCategories();
    _userProjectsBloc.searchProjects('');
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
      return MATE_WHITE;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _themeData = Theme.of(context);
    return SafeArea(
      child: GestureDetector(
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            topImageView(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  searchField(),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        bottom: width * 0.02),
                    child: SmallInfoLabel(label: SEARCH_BY_CATEGORY),
                  ),
                  categoryView(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SmallInfoLabel(
                        label: 'Current open projects in your area'),
                  ),
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
      delegate: SliverAppBarDelegate(
        minHeight: height / 6,
        maxHeight: height / 3.5,
        child: StreamBuilder<SignUpAndUserModel>(
          stream: _userInfoBloc.userStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            final SignUpAndUserModel user = snapshot.data!;
            return Stack(
              children: [
                Container(
                  height: height / 3.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: GRAY)),
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
                currentPosition < height / 30
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            MSG_DASHBOARD,
                            textAlign: TextAlign.center,
                            style: _themeData.textTheme.bodyText2!.copyWith(
                              fontSize: width / 16,
                              color: WHITE,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                Positioned(
                  bottom: width * 0.17,
                  left: 0,
                  child: targetGoalSection(user),
                ),
                Positioned(
                  bottom: width * 0.02,
                  left: 0,
                  child: timelineProgress(user),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget targetGoalSection(SignUpAndUserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Row(
            children: [
              Text(
                YOUR_HOURS_1,
                style: _themeData.textTheme.bodyText2!.copyWith(
                    fontSize: 16,
                    color: MATE_WHITE,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '50',
                style: _themeData.textTheme.bodyText2!.copyWith(
                    fontSize: width * 0.1,
                    color: AMBER_COLOR,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                YOUR_HOURS_2,
                style: _themeData.textTheme.bodyText2!.copyWith(
                    fontSize: 16,
                    color: MATE_WHITE,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${DateTime.now().year}',
                style: _themeData.textTheme.bodyText2!.copyWith(
                  fontSize: 20,
                  color: MATE_WHITE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget timelineProgress(SignUpAndUserModel user) {
    _processIndex = 50;
    List<int> items =
        List<int>.generate(user.currentYearTargetHours!, (i) => i * 25)
            .take((user.currentYearTargetHours! / 23).round())
            .toList();

    return Container(
      height: height / 9,
      width: width,
      alignment: Alignment.topCenter,
      child: Timeline.tileBuilder(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        shrinkWrap: true,
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(thickness: 3.0),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (ctx, index) => width / 9.5,
          contentsBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                index == items.length - 1
                    ? '${items[index]}\nTarget'
                    : '${items[index]}',
                textAlign: TextAlign.center,
                style: _themeData.textTheme.bodyText2!.copyWith(
                  fontWeight: index == items.length - 1
                      ? FontWeight.bold
                      : FontWeight.w600,
                  fontSize: 12,
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
              color = MATE_WHITE;
            }

            if (items[index] <= _processIndex) {
              return Container(
                height: width * 0.025,
                width: width * 0.025,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: color,
                ),
              );
            } else {
              return Container(
                height: width * 0.025,
                width: width * 0.025,
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

  Widget searchField() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.02),
      child: Column(
        children: [
          SmallInfoLabel(label: SEARCH_PROJECT_LABEL),
          SizedBox(height: width * 0.02),
          Container(
            width: width / 1,
            height: 37,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                _userProjectsBloc.searchProjects(val);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 1.0, bottom: 1.0),
                hintText: TYPE_KEYWORD_HINT,
                hintStyle: _themeData.textTheme.bodyText2!.copyWith(
                  fontSize: 14,
                  color: LABEL_TILE_COLOR,
                ),
                fillColor: WHITE.withOpacity(0.23),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    CupertinoIcons.search,
                    color: LABEL_TILE_COLOR,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _userProjectsBloc.searchProjects('');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: LABEL_TILE_COLOR,
                    size: 22,
                  ),
                ),
                enabledBorder: searchBarDecoration(),
                disabledBorder: searchBarDecoration(),
                focusedBorder: searchBarDecoration(),
                border: searchBarDecoration(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder searchBarDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: LABEL_TILE_COLOR),
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
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children:
                    snapshot.data!.categories.map((CategoryModel category) {
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategorisedProjectsScreen(categoryId: category.id),
                      ),
                    ),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _themeData.textTheme.bodyText2!.copyWith(
                            fontSize: 10,
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
    return StreamBuilder<dynamic>(
      stream: _userProjectsBloc.getSearchedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader(minheight: 12)),
          );
        }
        return snapshot.data.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = snapshot.data[index];
                  return UserProjectCard(
                    project: project,
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectOtherDetailsScreen(project: project),
                      ),
                    ),
                    onPressedSignUpButton: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectVolunteerSignUp(project: project),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'Not available..',
                  style: _themeData.textTheme.bodyText2,
                ),
              );
      },
    );
  }
}
