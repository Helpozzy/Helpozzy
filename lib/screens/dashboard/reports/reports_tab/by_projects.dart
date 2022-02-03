import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/report_model.dart';
import 'package:helpozzy/screens/dashboard/reports/reports_chart.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportsByProjects extends StatefulWidget {
  @override
  _ReportsByProjectsState createState() => _ReportsByProjectsState();
}

class _ReportsByProjectsState extends State<ReportsByProjects> {
  late ThemeData _theme;
  late double height;
  late double width;
  late List<BarChartModel> data = [];

  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _projectsBloc.getProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: width * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: BarChartGraph(data: data),
          ),
          SizedBox(height: width * 0.05),
          ListDividerLabel(label: PROJECT_HOURS_LABEL),
          projectHrsList(),
        ],
      ),
    );
  }

  Widget projectHrsList() {
    return StreamBuilder<Projects>(
      stream: _projectsBloc.getProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LinearLoader(),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(height: 0.5),
          physics: ScrollPhysics(),
          itemCount: snapshot.data!.projectList.length,
          itemBuilder: (context, index) {
            ProjectModel project = snapshot.data!.projectList[index];
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: width * 0.04),
              title: Text(
                project.projectName,
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.organization,
                    style: _theme.textTheme.bodyText2!,
                  ),
                  keyValueTile(
                    key: TOTAL_HRS_LABEL,
                    value: '55',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget keyValueTile({String? key, String? value}) {
    return Row(
      children: [
        Text(
          key!,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DARK_GRAY,
          ),
        ),
        Text(
          value!,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            color: DARK_GRAY,
          ),
        ),
      ],
    );
  }
}
