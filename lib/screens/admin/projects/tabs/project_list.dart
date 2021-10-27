import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/admin/projects/create_project.dart';
import 'package:helpozzy/screens/admin/projects/project_tile.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectListScreen extends StatefulWidget {
  ProjectListScreen({required this.projectTabType});
  final ProjectTabType projectTabType;
  @override
  _ProjectListScreenState createState() =>
      _ProjectListScreenState(projectTabType: projectTabType);
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  _ProjectListScreenState({required this.projectTabType});
  final ProjectTabType projectTabType;
  late ThemeData _themeData;
  late double height;
  late double width;
  late bool isExpanded = false;

  AdminProjectsBloc _adminProjectsBloc = AdminProjectsBloc();

  @override
  void initState() {
    if (projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB) {
      _adminProjectsBloc.getProjects(projectTabType: projectTabType);
    } else if (projectTabType == ProjectTabType.PROJECT_INPROGRESS_TAB) {
      _adminProjectsBloc.getProjects(projectTabType: projectTabType);
    } else if (projectTabType == ProjectTabType.PROJECT_PAST_TAB) {
      _adminProjectsBloc.getProjects(projectTabType: projectTabType);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(child: projectList()),
        Container(
          padding: EdgeInsets.symmetric(vertical: width * 0.02),
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
    return StreamBuilder<Projects>(
      stream: _adminProjectsBloc.getProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader(minheight: 12));
        }
        final List<ProjectModel> projects = snapshot.data!.projects;
        return projects.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = projects[index];
                  return StreamBuilder<bool>(
                    initialData: false,
                    stream: _adminProjectsBloc.getProjectExpandStream,
                    builder: (context, snapshot) {
                      return ProjectTile(
                        project: project,
                        isExpanded: snapshot.data!,
                        adminProjectsBloc: _adminProjectsBloc,
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'No Projects Available',
                  style: _themeData.textTheme.headline6!
                      .copyWith(color: SHADOW_GRAY),
                ),
              );
      },
    );
  }
}
