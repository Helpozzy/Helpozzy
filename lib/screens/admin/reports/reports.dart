import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/models/admin_model/report_model.dart';
import 'package:helpozzy/screens/admin/reports/simple_line_chart.dart';
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

  ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _projectsBloc.getOnGoingProjects(
        projectTabType: ProjectTabType.PROJECT_UPCOMING_TAB);
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
    return Column(
      children: [
        SizedBox(height: width * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SimpleLineChartReport(),
        ),
        SizedBox(height: width * 0.05),
        ListDividerLabel(label: YEARLY_REPORTS_LABEL),
        reportList(),
      ],
    );
  }

  Widget reportList() {
    Reports reports = Reports.fromJson(list: sampleReportList);
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.02),
      separatorBuilder: (context, index) => Divider(),
      physics: ScrollPhysics(),
      itemCount: reports.yearlyReports.length,
      itemBuilder: (context, index) {
        ReportModel report = reports.yearlyReports[index];
        return ListTile(
          title: Text(
            report.year.toString(),
            style: _theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tile(
                key: USERS_LABEL,
                value: report.users.toString(),
              ),
              tile(
                key: TOTAL_HRS_LABEL,
                value: report.totalHrs.toString(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget tile({String? key, String? value}) {
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
