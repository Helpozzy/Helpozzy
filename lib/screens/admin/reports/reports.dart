import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/report_model.dart';
import 'package:helpozzy/screens/admin/reports/reports_chart.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class AdminReportsScreen extends StatefulWidget {
  @override
  _AdminReportsScreenState createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  late ThemeData _theme;
  late double height;
  late double width;

  late bool test = false;
  late bool test1 = false;

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
    return Scaffold(
      appBar: CommonAppBar(context).show(
        title: REPORTS_APPBAR,
        elevation: 0,
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: width * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: ReportLineChart(),
          ),
          SizedBox(height: width * 0.05),
          // choiceSelection(),
          ListDividerLabel(label: MONTHLY_REPORTS_LABEL),
          yearlyReportList(),
          ListDividerLabel(label: PROJECT_HOURS_LABEL),
          projectHrsList(),
        ],
      ),
    );
  }

  Widget choiceSelection() {
    return Row(
      children: [
        ChoiceChip(
          label: Text('Test'),
          selected: test,
          onSelected: (val) {
            setState(() {
              test = val;
            });
          },
        ),
        ChoiceChip(
          label: Text('Test1'),
          selected: test1,
          onSelected: (val) {
            setState(() {
              test1 = val;
            });
          },
        ),
      ],
    );
  }

  Widget yearlyReportList() {
    Reports reports = Reports.fromJson(list: sampleReportList);
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      physics: ScrollPhysics(),
      itemCount: reports.yearlyReports.length,
      itemBuilder: (context, index) {
        ReportModel report = reports.yearlyReports[index];
        return ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
          title: Text(
            report.year.toString(),
            style: _theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              keyValueTile(
                key: USERS_LABEL,
                value: report.users.toString(),
              ),
              keyValueTile(
                key: TOTAL_HRS_LABEL,
                value: report.totalHrs.toString(),
              ),
            ],
          ),
        );
      },
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
            child: LinearLoader(minheight: 12),
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
