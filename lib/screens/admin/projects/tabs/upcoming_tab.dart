import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/screens/admin/projects/create_project.dart';
import 'package:helpozzy/screens/admin/projects/project_tile.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectListScreen extends StatefulWidget {
  ProjectListScreen({required this.events});
  final List<EventModel> events;
  @override
  _ProjectListScreenState createState() =>
      _ProjectListScreenState(events: events);
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  _ProjectListScreenState({required this.events});
  final List<EventModel> events;
  late double height;
  late double width;
  late bool isExpanded = false;

  AdminProjectsBloc _adminProjectsBloc = AdminProjectsBloc();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(child: projectList()),
        Container(
          padding: EdgeInsets.symmetric(vertical: width * 0.03),
          child: CommonButton(
            text: ADD_NEW_PROJECT_BUTTON.toUpperCase(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProject(),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget projectList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final EventModel event = events[index];
        return StreamBuilder<bool>(
          initialData: false,
          stream: _adminProjectsBloc.getProjectExpandStream,
          builder: (context, snapshot) {
            return ProjectTile(
              event: event,
              isExpanded: snapshot.data!,
              adminProjectsBloc: _adminProjectsBloc,
            );
          },
        );
      },
    );
  }
}
