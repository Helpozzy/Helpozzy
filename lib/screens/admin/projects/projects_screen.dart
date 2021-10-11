import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/event_bloc.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/screens/admin/projects/tabs/upcoming_tab.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final EventsBloc _eventsBloc = EventsBloc();

  @override
  void initState() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _eventsBloc.getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context).show(
          title: PROJECTS_APPBAR,
          elevation: 1,
          color: WHITE,
          textColor: PRIMARY_COLOR,
          bottom: _tabBar(),
          onBackPressed: () {
            Navigator.of(context).pop();
          }),
      body: body(),
    );
  }

  TabBar _tabBar() => TabBar(
        controller: _tabController,
        indicatorColor: DARK_PINK_COLOR,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        tabs: [
          _tab(text: PROJECT_UPCOMING_TAB),
          _tab(text: PROJECT_INPROGRESS_TAB),
          _tab(text: PROJECT_PAST_TAB),
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

  Widget body() {
    return StreamBuilder<Events>(
      stream: _eventsBloc.getEventsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader(minheight: 12));
        }
        final List<EventModel> events = snapshot.data!.events;
        return TabBarView(
          controller: _tabController,
          children: [
            ProjectListScreen(events: events),
            ProjectListScreen(events: events),
            ProjectListScreen(events: events),
          ],
        );
      },
    );
  }
}
