import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'project_details.dart';
import 'user_project_sign_up.dart';

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
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();

  @override
  void initState() {
    _userProjectsBloc.getCategorisedProjects(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(
        title: PROJECT_APPBAR,
        color: WHITE,
        textColor: DARK_PINK_COLOR,
        elevation: 1,
      ),
      body: projectListView(),
    );
  }

  Widget projectListView() {
    return StreamBuilder<Projects>(
      stream: _userProjectsBloc.getCategorisedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LinearLoader(minheight: 12),
            ),
          );
        }
        return snapshot.data!.projects.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data!.projects.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = snapshot.data!.projects[index];
                  return UserProjectCard(
                    project: project,
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailsScreen(project: project),
                      ),
                    ),
                    onPressedSignUpButton: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectUserSignUpScreen(),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No projects available..',
                    style: _theme.textTheme.headline6),
              );
      },
    );
  }
}
