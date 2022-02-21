import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/projects/volunteer_sign_up.dart';
import 'package:helpozzy/screens/dashboard/projects/project_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class CategorisedProjectsScreen extends StatefulWidget {
  const CategorisedProjectsScreen({required this.categoryId});
  final int categoryId;

  @override
  _CategorisedProjectsScreenState createState() =>
      _CategorisedProjectsScreenState();
}

class _CategorisedProjectsScreenState extends State<CategorisedProjectsScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _projectsBloc.getCategorisedProjects(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(elevation: 0, title: PROJECT_APPBAR),
      body: projectListView(),
    );
  }

  Widget projectListView() {
    return StreamBuilder<Projects>(
      stream: _projectsBloc.getCategorisedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LinearLoader(),
            ),
          );
        }
        return snapshot.data!.projectList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                itemCount: snapshot.data!.projectList.length,
                itemBuilder: (context, index) {
                  final ProjectModel project =
                      snapshot.data!.projectList[index];
                  return ProjectCard(
                    project: project,
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailsInfo(project: project),
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
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        NO_PROJECTS_FOUNDS,
                        style: _theme.textTheme.headline5!.copyWith(
                            color: DARK_GRAY, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        PLEASE_VISIT_OTHER,
                        textAlign: TextAlign.center,
                        style: _theme.textTheme.bodyText2!
                            .copyWith(color: DARK_GRAY),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
