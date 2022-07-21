import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/projects/volunteer_sign_up.dart';
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
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late double currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _userInfoBloc.getUser(prefsObject.getString(CURRENT_USER_ID)!);
    _projectsBloc.getProjects(projectTabType: ProjectTabType.EXPLORE_SCREEN);
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
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(
            Duration(seconds: 1),
            () async => await _projectsBloc.getProjects(
                projectTabType: ProjectTabType.EXPLORE_SCREEN),
          ),
          color: PRIMARY_COLOR,
          child: SingleChildScrollView(
            child: Column(
              children: [
                searchField(),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
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
          SizedBox(
            width: width / 1,
            height: 37,
            child: CommonRoundedTextfield(
              textAlignCenter: false,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: DARK_MARUN,
                size: 18,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  _projectsBloc.getProjects(
                      projectTabType: ProjectTabType.EXPLORE_SCREEN,
                      searchText: '');
                },
                icon: Icon(
                  CupertinoIcons.clear,
                  color: DARK_MARUN,
                  size: 18,
                ),
              ),
              fillColor: GRAY,
              controller: _searchController,
              hintText: TYPE_KEYWORD_HINT,
              onChanged: (val) => _projectsBloc.getProjects(
                  projectTabType: ProjectTabType.EXPLORE_SCREEN,
                  searchText: val),
              validator: (val) => null,
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
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      shrinkWrap: true,
      childAspectRatio: 1.2,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      children: categoriesList.map((CategoryModel category) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategorisedProjectsScreen(
                category: category,
                fromPrefs: false,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                category.asset!,
                fit: BoxFit.fill,
                color: PRIMARY_COLOR,
                height: width * 0.1,
                width: width * 0.1,
              ),
              SizedBox(height: 4),
              Text(
                category.label!,
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
    );
  }

  Widget projectListView() {
    return StreamBuilder<List<ProjectModel>>(
      stream: _projectsBloc.getProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader()),
          );
        }
        return snapshot.data!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = snapshot.data![index];
                  return ProjectCard(
                    project: project,
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailsInfo(projectID: project.projectId!),
                      ),
                    ),
                    onPressedSignUpButton: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VolunteerProjectTaskSignUp(project: project),
                      ),
                    ),
                  );
                },
              )
            : Container(
                height: height / 3,
                alignment: Alignment.center,
                child: Text(
                  NO_CURRENT_VOLUNTEERING_OPPORTUNITIES,
                  textAlign: TextAlign.center,
                  style: _themeData.textTheme.headline6!
                      .copyWith(color: DARK_GRAY),
                ),
              );
      },
    );
  }
}
