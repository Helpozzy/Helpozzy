import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/projects_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/helper/report_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_details.dart';
import 'package:helpozzy/screens/dashboard/reports/pvsa_chart.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  late String yAxisLabel = CHART_YEARS_LABEL;
  late List<ReportsDataModel> data = [];
  final ProjectsBloc _projectsBloc = ProjectsBloc();
  late bool yearIsLoaded = false;
  late bool monthIsLoaded = false;
  late bool projectIsLoaded = false;

  @override
  void initState() {
    loadYear();
    super.initState();
  }

  Future loadYear() async {
    yearIsLoaded = true;
    monthIsLoaded = false;
    projectIsLoaded = false;
    yAxisLabel = CHART_YEARS_LABEL;
    final List<ProjectModel> projects = await _projectsBloc.getProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    data = projectReportHelper.chartDetailsList;

    setState(() {});
  }

  Future loadMonth(String year) async {
    yearIsLoaded = true;
    monthIsLoaded = true;
    projectIsLoaded = false;
    yAxisLabel = CHART_MONTHS_LABEL;
    final List<ProjectModel> projects = await _projectsBloc.getProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    data = projectReportHelper.chartDetailsList
        .where((element) => element.year == year)
        .toList();

    setState(() {});
  }

  Future loadProject(String year, String month) async {
    yearIsLoaded = false;
    monthIsLoaded = true;
    projectIsLoaded = true;
    yAxisLabel = CHART_MONTHS_LABEL;
    final List<ProjectModel> projects = await _projectsBloc.getProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    data = projectReportHelper.chartDetailsList
        .where((element) => element.year == year && element.month == month)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: REPORTS_APPBAR),
      body: SingleChildScrollView(
        child: Column(
          children: [
            reportView(),
            SizedBox(height: width * 0.05),
            ListDividerLabel(label: SERVICE_ACCOMPLISHMENTS_LABEL),
            ListTile(
              title: Text(SERVICE_DETAILS_LABEL),
              trailing: Icon(
                CupertinoIcons.list_bullet_below_rectangle,
                color: DARK_PINK_COLOR,
              ),
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PVSAChart(),
                ),
              ),
            ),
            ListDividerLabel(label: MONTHLY_REPORTS_LABEL),
            monthlyReportList(),
          ],
        ),
      ),
    );
  }

  Widget reportView() {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 15.0,
                right: 8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (touchEvent, response) async {
                        if (yearIsLoaded &&
                            !monthIsLoaded &&
                            !projectIsLoaded) {
                          await loadMonth('2022');
                        } else if (yearIsLoaded &&
                            monthIsLoaded &&
                            projectIsLoaded) {
                          await loadProject('2022', 'Feb');
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                          color: NORMAL_BAR_COLOR,
                          fontSize: 10,
                        ),
                        margin: 10,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTextStyles: (context, value) => const TextStyle(
                          color: NORMAL_BAR_COLOR,
                          fontSize: 10,
                        ),
                        margin: 0,
                      ),
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: NORMAL_BAR_COLOR,
                        strokeWidth: 0.5,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: GRAY,
                        strokeWidth: 0.5,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(width: 0.5),
                        left: BorderSide(width: 0.2),
                      ),
                    ),
                    groupsSpace: data.length == 12 ? 13 : 30,
                    barGroups: getData(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                CHART_HOURS_VERTICAL_LABEL,
                textAlign: TextAlign.center,
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                yAxisLabel,
                textAlign: TextAlign.center,
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return data.map((e) {
      final yVal = double.parse(e.projectsCounter!.toString());
      return BarChartGroupData(
        x: e.projectsCounter!,
        barRods: [
          BarChartRodData(
            toY: yVal,
            width: data.length == 12 ? 12 : 20,
            rodStackItems: [
              BarChartRodStackItem(0, yVal, DARK_BAR_COLOR),
              BarChartRodStackItem(yVal / 2, yVal, NORMAL_BAR_COLOR),
              // BarChartRodStackItem(yVal / 2, yVal / 1, LIGHT_BAR_COLOR),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget monthlyReportList() {
    Reports reports = Reports.fromList(list: data);
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => CommonDivider(),
      physics: ScrollPhysics(),
      itemCount: reports.reports.length,
      itemBuilder: (context, index) {
        ReportsDataModel report = reports.reports[index];
        if (monthIsLoaded && projectIsLoaded) {
          final ProjectModel project = report.projectsList![index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsInfo(project: project),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: width * 0.05,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName!,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          color: BLUE_GRAY,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        project.organization != null &&
                                project.organization!.isNotEmpty
                            ? project.organization!
                            : project.categoryId == 0
                                ? VOLUNTEER_0
                                : project.categoryId == 1
                                    ? FOOD_BANK_1
                                    : project.categoryId == 2
                                        ? TEACHING_2
                                        : project.categoryId == 3
                                            ? HOMELESS_SHELTER_3
                                            : project.categoryId == 4
                                                ? ANIMAL_CARE_4
                                                : project.categoryId == 5
                                                    ? SENIOR_CENTER_5
                                                    : project.categoryId == 6
                                                        ? CHILDREN_AND_YOUTH_6
                                                        : OTHER_7,
                        style: _theme.textTheme.bodyText2!
                            .copyWith(color: DARK_GRAY),
                      ),
                      Text(
                        DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                            timeStamp: project.startDate!),
                        style: _theme.textTheme.bodyText2!.copyWith(
                          color: DARK_BLUE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CommonDivider(),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  )
                ],
              ),
            ),
          );
        }
        return Padding(
          padding:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                monthIsLoaded ? report.month! : report.year!,
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                PROJECTS_LABEL + report.projectsCounter.toString(),
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: DARK_GRAY,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
