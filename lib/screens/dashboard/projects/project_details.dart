import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/sliver_class.dart';
import 'package:helpozzy/widget/url_launcher.dart';

import 'project_tabs/members_tab.dart';
import 'project_tabs/other_details_tab.dart';
import 'project_tabs/tasks_tab.dart';
import 'volunteer_sign_up.dart';

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

  final ScrollController scrollController = ScrollController();
  late double currentPosition = 0.0;

  @override
  void initState() {
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
    scrollController.addListener(() {
      setState(() => currentPosition = scrollController.offset);
    });
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
                ],
              ),
            ),
            SliverFillRemaining(
              child: Scaffold(
                appBar: _tabBar(),
                body: _getPage(),
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
            SizedBox(
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
            currentPosition < height / 10
                ? Positioned(
                    left: 16,
                    bottom: 42,
                    child: Container(
                      width: width - 30,
                      child: Text(
                        project.projectName,
                        maxLines: 2,
                        style: _theme.textTheme.headline6!.copyWith(
                          color: WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            currentPosition < height / 10
                ? Positioned(
                    left: 16,
                    bottom: 28,
                    child: Text(
                      project.organization,
                      maxLines: 2,
                      style: _theme.textTheme.headline5!.copyWith(
                        color: GRAY,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : SizedBox(),
            currentPosition < height / 10
                ? Positioned(
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
                          unratedColor: GRAY,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: AMBER_COLOR,
                          ),
                          onRatingUpdate: (rating) => print(rating),
                        ),
                        Text(
                          ' (${project.reviewCount} Reviews)',
                          style: _theme.textTheme.bodyText2!.copyWith(
                            color: GRAY,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            currentPosition < height / 10
                ? Positioned(
                    right: 17,
                    bottom: 11,
                    child: InkWell(
                      onTap: () {
                        setState(() => project.isLiked = !project.isLiked);
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
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget scheduleTiming() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dateWithLabel(
                label: START_DATE_LABEL,
                date: project.startDate,
              ),
              SizedBox(height: 2),
              dateWithLabel(
                label: END_DATE_LABEL,
                date: project.endDate,
              ),
            ],
          ),
          project.projectOwner == prefsObject.getString(CURRENT_USER_ID)
              ? SizedBox()
              : project.status == PROJECT_COMPLETED
                  ? SizedBox()
                  : SmallCommonButton(
                      fontSize: 10,
                      text: SIGN_UP,
                      onPressed: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              VolunteerProjectTaskSignUp(project: project),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget dateWithLabel({String? label, String? date}) {
    return Row(
      children: [
        Text(
          label!,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 11,
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(timeStamp: date!),
          style: _theme.textTheme.bodyText2!
              .copyWith(fontSize: 11, color: BLUE_COLOR),
        ),
      ],
    );
  }

  Widget contactPersontile() {
    return ListDividerLabel(
      label: PROJECT_LEAD_LABEL + project.contactName,
      hasIcon: true,
      suffixIcon: InkWell(
        onTap: () => CommonUrlLauncher().launchCall(project.contactNumber),
        child: Icon(
          CupertinoIcons.phone,
          size: 18,
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
        enableFeedback: true,
        tabs: [
          _tab(text: DETAILS_TAB),
          _tab(text: TASKS_TAB),
          _tab(text: MEMBERS_TAB),
          _tab(text: MESSENGER_TAB),
          _tab(text: ATTACHMENTS_TAB),
        ],
      );

  Tab _tab({required String text}) => Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 13,
            color: DARK_PINK_COLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _getPage() {
    return TabBarView(
      controller: _tabController,
      children: [
        ProjectOtherDetailsScreen(project: project),
        TaskTab(project: project),
        ProjectMembersTab(),
        Text(COMING_SOON_SCREEN_TEXT),
        Text(COMING_SOON_SCREEN_TEXT),
      ],
    );
  }
}
