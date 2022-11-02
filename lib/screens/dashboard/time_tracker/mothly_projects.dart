import 'package:flutter/material.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/projects/project_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MonthlyProjects extends StatefulWidget {
  const MonthlyProjects({required this.projectActivity});
  final ReportsDataModel projectActivity;

  @override
  _MonthlyProjectsState createState() =>
      _MonthlyProjectsState(projectActivity: projectActivity);
}

class _MonthlyProjectsState extends State<MonthlyProjects> {
  _MonthlyProjectsState({required this.projectActivity});
  final ReportsDataModel projectActivity;

  late ThemeData _theme;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: WHITE,
        appBar: CommonAppBar(context).show(
          elevation: 0,
          title: projectActivity.month! + ' Activity',
        ),
        body: projectListView(projectActivity),
      ),
    );
  }

  Widget projectListView(ReportsDataModel projectActivity) {
    return projectActivity.projects!.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            itemCount: projectActivity.projects!.length,
            itemBuilder: (context, index) {
              final ProjectModel project = projectActivity.projects![index];
              return ProjectCard(
                project: project,
                onTapCard: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectDetailsInfo(
                        projectID: project.projectId!,
                        projectTabType: ProjectTabType.COMPLETED_SCREEN),
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
                    style:
                        _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
                  ),
                ],
              ),
            ),
          );
  }
}
