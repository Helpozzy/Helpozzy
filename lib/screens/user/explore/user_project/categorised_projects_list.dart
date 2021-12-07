import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import '../../../projects/user_project_tabs/other_details_tab.dart';
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
      appBar: CommonAppBar(context).show(elevation: 0, title: PROJECT_APPBAR),
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
        return snapshot.data!.projectList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                itemCount: snapshot.data!.projectList.length,
                itemBuilder: (context, index) {
                  final ProjectModel project =
                      snapshot.data!.projectList[index];
                  return UserProjectCard(
                    project: project,
                    onTapCard: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectOtherDetailsScreen(project: project),
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
