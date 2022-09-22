import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/screens/dashboard/projects/project_list.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TimeTracker extends StatefulWidget {
  const TimeTracker({Key? key}) : super(key: key);

  @override
  State<TimeTracker> createState() => _TimeTrackerState();
}

class _TimeTrackerState extends State<TimeTracker> {
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context).show(title: TIME_TRACKER_TILE),
      body: ProjectListScreen(
        projectTabType: ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB,
        projectsBloc: _projectsBloc,
      ),
    );
  }
}
