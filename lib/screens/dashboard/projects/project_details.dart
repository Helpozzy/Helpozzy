import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/bloc/chat_bloc.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/bloc/review_bloc.dart';
import 'package:helpozzy/bloc/user_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_tabs/messenger_tab.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/sliver_class.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'project_tabs/members_tab.dart';
import 'project_tabs/other_details_tab.dart';
import 'project_tabs/tasks_tab.dart';
import 'volunteer_sign_up.dart';

class ProjectDetailsInfo extends StatefulWidget {
  ProjectDetailsInfo({required this.projectID, this.projectTabType});
  final String projectID;
  final ProjectTabType? projectTabType;
  @override
  _ProjectDetailsInfoState createState() => _ProjectDetailsInfoState(
      projectID: projectID, projectTabType: projectTabType);
}

class _ProjectDetailsInfoState extends State<ProjectDetailsInfo>
    with TickerProviderStateMixin {
  _ProjectDetailsInfoState({required this.projectID, this.projectTabType});
  final ProjectTabType? projectTabType;
  final String projectID;
  late double height;
  late double width;
  late ThemeData _theme;
  late TabController _tabController;
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
  final ProjectReviewsBloc _projectReviewsBloc = ProjectReviewsBloc();
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  final ScrollController scrollController = ScrollController();
  late double currentPosition = 0.0;
  final UserInfoBloc _userInfoBloc = UserInfoBloc();
  final ChatBloc _chatBloc = ChatBloc();
  late SignUpAndUserModel projectOwner;

  @override
  void initState() {
    _projectReviewsBloc.getProjectReviews(projectID);
    _projectsBloc.getProjectByProjectId(projectID);
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
    getProjectOwnerDetails();
    scrollController.addListener(() {
      setState(() => currentPosition = scrollController.offset);
    });
    _chatBloc.getProjectChatHistory(projectID);
    super.initState();
  }

  Future getProjectOwnerDetails() async {
    _projectsBloc.getProjectByIdStream.listen((project) async {
      projectOwner = await _userInfoBloc.getUser(project.ownerId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<ProjectModel>(
          stream: _projectsBloc.getProjectByIdStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: LinearLoader());
            }
            final ProjectModel project = snapshot.data!;
            return SafeArea(
              child: CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  projectOrganizer(project),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        scheduleTiming(project),
                        project.ownerId ==
                                prefsObject.getString(CURRENT_USER_ID)
                            ? SizedBox()
                            : DateFormatFromTimeStamp()
                                        .dateTime(
                                            timeStamp:
                                                currentTimeStamp.toString())
                                        .difference(DateFormatFromTimeStamp()
                                            .dateTime(
                                                timeStamp: project.endDate!))
                                        .inDays >=
                                    1
                                ? projectEndedMsg()
                                : SizedBox(),
                        contactPersontile(project),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    child: Scaffold(
                      appBar: _tabBar(),
                      body: _getPage(project),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget projectOrganizer(ProjectModel project) {
    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: height / 10,
        maxHeight: height / 3.5,
        child: Stack(
          children: [
            Image.asset(
              project.imageUrl!,
              fit: BoxFit.fill,
              height: height / 3.5,
              width: double.infinity,
            ),
            Container(
              height: height / 3.5,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
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
                        project.projectName!,
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
                      project.organization != null &&
                              project.organization!.isNotEmpty
                          ? project.organization!
                          : project.categoryId == 0
                              ? VOLUNTEER_0
                              : project.categoryId == 1
                                  ? FOOD_BANK_1
                                  : project.categoryId == 2
                                      ? TEACHING_2
                                      : project.categoryId == 3
                                          ? HOMELESS_SHELTER_3
                                          : project.categoryId == 4
                                              ? ANIMAL_CARE_4
                                              : project.categoryId == 5
                                                  ? SENIOR_CENTER_5
                                                  : project.categoryId == 6
                                                      ? CHILDREN_AND_YOUTH_6
                                                      : OTHER_7,
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
                    child: StreamBuilder<Reviews>(
                      stream: _projectReviewsBloc.getProjectReviewsStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          _projectReviewsBloc
                              .getProjectReviews(project.projectId!);
                          return Text(
                            LOADING,
                            style: _theme.textTheme.bodyText2!.copyWith(
                              fontSize: 10,
                              color: GRAY,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                        late double rating = 0.0;
                        if (snapshot.data!.reviews.isNotEmpty) {
                          rating = snapshot.data!.reviews
                                  .map((m) => m.rating)
                                  .reduce((a, b) => a! + b!)! /
                              snapshot.data!.reviews.length;
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              initialRating: rating,
                              ignoreGestures: true,
                              minRating: 1,
                              itemSize: 14,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              unratedColor: GRAY,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AMBER_COLOR,
                              ),
                              onRatingUpdate: (rating) => print(rating),
                            ),
                            Text(
                              snapshot.data!.reviews.isNotEmpty
                                  ? ' (${snapshot.data!.reviews.length} Reviews)'
                                  : ' (0 Reviews)',
                              style: _theme.textTheme.bodyText2!.copyWith(
                                color: GRAY,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget scheduleTiming(ProjectModel project) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.035),
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
          project.ownerId == prefsObject.getString(CURRENT_USER_ID)
              ? SizedBox()
              : projectTabType == ProjectTabType.COMPLETED_SCREEN ||
                      projectTabType ==
                          ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                  ? SizedBox()
                  : DateFormatFromTimeStamp()
                              .dateTime(timeStamp: currentTimeStamp.toString())
                              .difference(DateFormatFromTimeStamp()
                                  .dateTime(timeStamp: project.endDate!))
                              .inDays >=
                          1
                      ? SizedBox()
                      : project.isSignedUp!
                          ? SizedBox()
                          : project.status == TOGGLE_COMPLETE
                              ? SizedBox()
                              : projectTabType == ProjectTabType.OWN_TAB ||
                                      projectTabType ==
                                          ProjectTabType
                                              .PROJECT_COMPLETED_TAB ||
                                      projectTabType ==
                                          ProjectTabType.MY_ENROLLED_TAB
                                  ? SizedBox()
                                  : SmallCommonButton(
                                      fontSize: 10,
                                      text: SIGN_UP,
                                      onPressed: () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              VolunteerProjectTaskSignUp(
                                                  project: project),
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

  Widget projectEndedMsg() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
      color: RED_COLOR,
      child: Text(
        NOT_SIGNUP_MESSAGE_ALERT,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: WHITE,
            ),
      ),
    );
  }

  Widget contactPersontile(ProjectModel project) {
    return ListDividerLabel(
      label: PROJECT_LEAD_LABEL + project.contactName!,
      suffixIcon: prefsObject.getString(CURRENT_USER_ID) != project.ownerId
          ? InkWell(
              onTap: () =>
                  CommonUrlLauncher().launchCall(project.contactNumber!),
              child: Icon(
                CupertinoIcons.phone,
                size: 16,
              ),
            )
          : SizedBox(),
    );
  }

  TabBar _tabBar() => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2,
        enableFeedback: true,
        onTap: (index) async =>
            await _chatBloc.getProjectChatHistory(projectID),
        tabs: [
          _tab(text: DETAILS_TAB),
          _tab(text: TASKS_TAB),
          _tab(text: MEMBERS_TAB),
          StreamBuilder<ChatList>(
              stream: _chatBloc.getChatListStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return _tab(text: MESSENGER_TAB);
                }
                final List<ChatListItem> chatHistory =
                    snapshot.data!.chats.where((e) => e.badge != 0).toList();
                return _tab(
                  text: MESSENGER_TAB,
                  badge: chatHistory.isNotEmpty ? true : false,
                );
              }),
          // _tab(text: ATTACHMENTS_TAB),
        ],
      );

  Tab _tab({required String text, bool badge = false}) => Tab(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 13,
                color: DARK_PINK_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
            badge ? SizedBox(width: 2) : SizedBox(),
            badge ? NotifyBadge() : SizedBox(),
          ],
        ),
      );

  Widget _getPage(ProjectModel project) {
    return TabBarView(
      controller: _tabController,
      children: [
        ProjectDetailsTab(project: project),
        TaskTab(
          project: project,
          projectTabType: projectTabType,
        ),
        ProjectMembersTab(project: project),
        MessengerTab(project: project),
      ],
    );
  }
}
