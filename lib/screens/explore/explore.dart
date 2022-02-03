import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/bloc/project_categories_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/projects/volunteer_project_sign_up.dart';
import 'package:helpozzy/screens/dashboard/projects/categorised_projects_list.dart';
import 'package:helpozzy/screens/dashboard/projects/project_card.dart';
import 'package:helpozzy/screens/rewards/rewards.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  late ThemeData _themeData;

  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final CategoryBloc _categoryBloc = CategoryBloc();
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late double currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _categoryBloc.getCategories();
    _userProjectsBloc.searchProjects('');
    scrollController.addListener(() {
      setState(() => currentPosition = scrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _themeData = Theme.of(context);
    return SafeArea(
      child: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            searchField(),
            CommonDivider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        bottom: width * 0.02,
                        top: 5,
                      ),
                      child: SmallInfoLabel(label: SEARCH_BY_CATEGORY),
                    ),
                    categoryView(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: SmallInfoLabel(label: CURRENT_OPEN_PROJECT_LABEL),
                    ),
                    projectListView(),
                  ],
                ),
              ),
            ),
          ],
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
          SizedBox(height: width * 0.03),
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
                  color: DARK_GRAY,
                ),
                fillColor: WHITE.withOpacity(0.23),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    CupertinoIcons.search,
                    color: DARK_GRAY,
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
                    color: DARK_GRAY,
                    size: 20,
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
      borderSide: BorderSide(color: DARK_GRAY),
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
            child: Center(child: LinearLoader()),
          );
        }
        return Column(
          children: [
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: snapshot.data!.categories.map((CategoryModel category) {
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
                        placeholder: (context, url) =>
                            Center(child: LinearLoader()),
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
      },
    );
  }

  Widget projectListView() {
    return StreamBuilder<dynamic>(
      stream: _userProjectsBloc.getSearchedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader()),
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
                  return ProjectCard(
                    project: project,
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailsInfo(project: project),
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
