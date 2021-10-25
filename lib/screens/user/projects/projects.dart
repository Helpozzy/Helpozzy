import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/user/explore/user_project/project_details.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_card.dart';
import 'package:helpozzy/screens/user/explore/user_project/user_project_sign_up.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class UserProjects extends StatefulWidget {
  @override
  _UserProjectsState createState() => _UserProjectsState();
}

class _UserProjectsState extends State<UserProjects> {
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();
  late ThemeData _themeData;
  late double width;

  @override
  void initState() {
    super.initState();
    _userProjectsBloc.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.05),
          alignment: Alignment.centerLeft,
          child: Text(
            PROJECT_APPBAR,
            textAlign: TextAlign.center,
            style: _themeData.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: projectListView()),
      ],
    ));
  }

  Widget projectListView() {
    return StreamBuilder<Projects>(
      stream: _userProjectsBloc.getProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: LinearLoader(minheight: 12)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
          itemCount: snapshot.data!.projects.length,
          itemBuilder: (context, index) {
            final ProjectModel project = snapshot.data!.projects[index];
            return UserProjectCard(
              project: project,
              onTapCard: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(project: project),
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
        );
      },
    );
  }
}
