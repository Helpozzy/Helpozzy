import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/screens/projects/create_project.dart';
import 'package:helpozzy/screens/projects/project_list.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late double width;
  late ThemeData _theme;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        elevation: 1,
        backButton: false,
        title: PROJECTS_APPBAR,
        bottom: topSearchWithTab(),
      ),
      body: body(),
    );
  }

  PreferredSize topSearchWithTab() => PreferredSize(
        preferredSize: Size(width, width / 4.5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 41,
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: CommonRoundedTextfield(
                      textAlignCenter: true,
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: DARK_GRAY,
                      ),
                      fillColor: GRAY,
                      controller: _searchController,
                      hintText: SEARCH_PROJECT_HINT,
                      validator: (val) {},
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: FloatingActionButton.extended(
                    elevation: 4,
                    label: Text(
                      ADD_NEW_PROJECT_BUTTON.toUpperCase(),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        color: WHITE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateProject(),
                      ),
                    ),
                    backgroundColor: PRIMARY_COLOR,
                    icon: Icon(
                      CupertinoIcons.add_circled,
                      color: WHITE,
                    ),
                  ),
                ),
              ],
            ),
            _tabBar(),
          ],
        ),
      );

  TabBar _tabBar() => TabBar(
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        isScrollable: true,
        tabs: [
          _tab(text: PROJECT_UPCOMING_TAB),
          _tab(
            text: PROJECT_INPROGRESS_TAB,
          ),
          _tab(
            text: PROJECT_CONTRIBUTION_TRACKER_TAB,
          ),
        ],
      );

  Tab _tab({required String text}) => Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 13,
                color: DARK_PINK_COLOR,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  Widget body() {
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: TabBarView(
        controller: _tabController,
        children: [
          ProjectListScreen(
            projectTabType: ProjectTabType.PROJECT_UPCOMING_TAB,
          ),
          ProjectListScreen(
            projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB,
          ),
          ProjectListScreen(
            projectTabType: ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB,
          ),
        ],
      ),
    );
  }
}
