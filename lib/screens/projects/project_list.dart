import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/projects/create_project.dart';
import 'package:helpozzy/screens/projects/project_tile.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectListScreen extends StatefulWidget {
  ProjectListScreen({required this.fromAdmin, required this.projectTabType});
  final bool fromAdmin;
  final ProjectTabType projectTabType;
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState(
      fromAdmin: fromAdmin, projectTabType: projectTabType);
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  _ProjectListScreenState(
      {required this.fromAdmin, required this.projectTabType});
  final bool fromAdmin;
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
      if (!fromAdmin) {
        _adminProjectsBloc.getOnGoingProjects(
            projectTabType: ProjectTabType.PROJECT_INPROGRESS_TAB);
      }
    } else if (projectTabType == ProjectTabType.PROJECT_INPROGRESS_TAB) {
      _adminProjectsBloc.getProjects(projectTabType: projectTabType);
    } else if (projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB) {
      _adminProjectsBloc.getProjects(projectTabType: projectTabType);
    } else if (projectTabType ==
        ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB) {
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
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? labelTile('New Projects')
            : SizedBox(),
        Expanded(child: projectList(_adminProjectsBloc.getProjectsStream)),
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? labelTile('Ongoing Projects')
            : SizedBox(),
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? Expanded(
                child: projectList(_adminProjectsBloc.getOnGoingProjectsStream))
            : SizedBox(),
        fromAdmin
            ? Container(
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
            : SizedBox(),
      ],
    );
  }

  Widget labelTile(String label) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
      color: LABEL_TILE_COLOR,
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget projectList(Stream<Projects>? stream) {
    return StreamBuilder<Projects>(
      stream: stream,
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
                        fromAdmin: fromAdmin,
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
