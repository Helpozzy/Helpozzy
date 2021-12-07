import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/projects/user_project_tabs/other_details_tab.dart';
import 'package:helpozzy/screens/projects/user_project_tabs/members_tab.dart';
import 'package:helpozzy/screens/projects/user_project_tabs/tasks_tab.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/sliver_class.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:intl/intl.dart';

class ProjectDetailsInfo extends StatefulWidget {
  ProjectDetailsInfo({required this.project});
  final ProjectModel project;
  @override
  _ProjectDetailsInfoState createState() =>
      _ProjectDetailsInfoState(project: project);
}

class _ProjectDetailsInfoState extends State<ProjectDetailsInfo>
    with TickerProviderStateMixin {
  _ProjectDetailsInfoState({required this.project});
  final ProjectModel project;
  late double height;
  late double width;
  late ThemeData _theme;
  late TabController _tabController;
  final scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            projectOrganizer(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  scheduleTiming(),
                  contactPersontile(),
                  _tabBar(),
                  Container(width: width, height: 1, color: GRAY),
                  _getPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget projectOrganizer() {
    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: height / 10,
        maxHeight: height / 4,
        child: Stack(
          children: [
            Container(
              height: height / 4,
              width: double.infinity,
              child: Image.asset(
                project.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: height / 4,
              width: double.infinity,
              color: BLACK.withOpacity(0.3),
            ),
            Positioned(
              left: 10,
              top: 8,
              child: IconButton(
                iconSize: 18,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  CupertinoIcons.arrowshape_turn_up_left,
                  color: WHITE,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 45,
              child: Container(
                width: width - 30,
                child: Text(
                  project.projectName,
                  maxLines: 2,
                  style: _theme.textTheme.headline6!
                      .copyWith(color: WHITE, fontSize: 28),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 25,
              child: Text(
                project.organization,
                maxLines: 2,
                style: _theme.textTheme.headline5!.copyWith(
                    color: WHITE, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: project.rating,
                    ignoreGestures: true,
                    minRating: 1,
                    itemSize: 14,
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
                    ' (${project.reviewCount} Reviews)',
                    style: _theme.textTheme.bodyText2!.copyWith(
                      color: WHITE,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 17,
              bottom: 11,
              child: InkWell(
                onTap: () {
                  setState(() {
                    project.isLiked = !project.isLiked;
                  });
                },
                child: Icon(
                  project.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: project.isLiked ? Colors.red : WHITE,
                  size: 19,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget scheduleTiming() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, MMMM dd, yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(project.startDate),
              ),
            ),
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              color: BLUE_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Text(
            project.startTime + ' - ' + project.endTime,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 12,
              color: BLUE_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget contactPersontile() {
    return ListDividerLabel(
      label: 'Project Lead : ' + project.contactName,
      hasIcon: true,
      suffixIcon: InkWell(
        onTap: () => CommonUrlLauncher().launchCall(project.contactNumber),
        child: Icon(
          CupertinoIcons.phone,
          size: 20,
        ),
      ),
    );
  }

  TabBar _tabBar() => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        tabs: [
          _tab(text: TASKS_TAB),
          _tab(text: MEMBERS_TAB),
          _tab(text: MESSENGER_TAB),
          _tab(text: ATTACHMENTS_TAB),
          _tab(text: DETAILS_TAB),
        ],
      );

  Tab _tab({required String text}) => Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontFamily: QUICKSAND,
            color: DARK_PINK_COLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _getPage() {
    return Container(
      height: height,
      child: TabBarView(
        controller: _tabController,
        children: [
          TaskTab(project: project),
          ProjectMembersTab(),
          Text('Coming Soon!'),
          Text('Coming Soon!'),
          ProjectOtherDetailsScreen(project: project),
        ],
      ),
    );
  }
}
