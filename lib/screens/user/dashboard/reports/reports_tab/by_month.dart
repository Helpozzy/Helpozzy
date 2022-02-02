import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/report_model.dart';
import 'package:helpozzy/screens/user/dashboard/reports/reports_chart.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportsByMonthDetails extends StatefulWidget {
  @override
  _ReportsByMonthDetailsState createState() => _ReportsByMonthDetailsState();
}

class _ReportsByMonthDetailsState extends State<ReportsByMonthDetails> {
  late ThemeData _theme;
  late double height;
  late double width;
  late List<BarChartModel> data = [];

  final ProjectsBloc _projectsBloc = ProjectsBloc();

  @override
  void initState() {
    _projectsBloc.getProjects();
    setListData();
    super.initState();
  }

  Future setListData() async {
    final List<String> previousSixMonth =
        DateFormatFromTimeStamp().getPreviousSixMonths();
    data = [
      BarChartModel(users: 12, hours: 16, month: previousSixMonth[5]),
      BarChartModel(users: 8, hours: 22, month: previousSixMonth[4]),
      BarChartModel(users: 5, hours: 55, month: previousSixMonth[3]),
      BarChartModel(users: 10, hours: 38, month: previousSixMonth[2]),
      BarChartModel(users: 13, hours: 16, month: previousSixMonth[1]),
      BarChartModel(users: 18, hours: 20, month: previousSixMonth[0]),
    ];
    setState(() {});
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
          ListDividerLabel(label: MONTHLY_REPORTS_LABEL),
          yearlyReportList(),
          ListDividerLabel(label: PROJECT_HOURS_LABEL),
          projectHrsList(),
        ],
      ),
    );
  }

  Widget yearlyReportList() {
    Reports reports = Reports.fromJson(list: data);
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      physics: ScrollPhysics(),
      itemCount: reports.monthlyReports.length,
      itemBuilder: (context, index) {
        BarChartModel report = reports.monthlyReports[index];
        return ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
          title: Text(
            report.month.toString(),
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
                value: report.hours.toString(),
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
