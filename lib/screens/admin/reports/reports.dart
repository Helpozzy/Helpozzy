import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/screens/admin/reports/line_chart.dart';
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
          child: ReportLineChart(),
        ),
        SizedBox(height: width * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SmallInfoLabel(label: 'Yearly Report'),
        ),
        reportList(),
      ],
    );
  }

  Widget reportList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.02),
      separatorBuilder: (context, index) => Divider(),
      physics: ScrollPhysics(),
      itemCount: sampleReportList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            sampleReportList[index]['year'].toString(),
            style: _theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tile(
                key: 'Users : ',
                value: sampleReportList[index]['users'].toString(),
              ),
              tile(
                key: 'Total Hours : ',
                value: sampleReportList[index]['hours'].toString(),
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
            color: DARK_GRAY_FONT_COLOR,
          ),
        ),
        Text(
          value!,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontSize: 12,
            color: DARK_GRAY_FONT_COLOR,
          ),
        ),
      ],
    );
  }
}
