import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/report_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/helper/report_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';
import 'package:helpozzy/screens/dashboard/reports/pvsa_chart.dart';
import 'package:helpozzy/screens/dashboard/reports/report_project_tile.dart';
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
  late List<ReportsDataModel> data = [];
  final DateFormatFromTimeStamp _dateFromTimeStamp = DateFormatFromTimeStamp();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final ReportBloc _reportBloc = ReportBloc();

  @override
  void initState() {
    loadMonth(DateTime.now().year.toString());
    super.initState();
  }

  Future loadMonth(String year) async {
    final List<ProjectModel> projects = await _reportBloc.getSignedUpProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    data = projectReportHelper.chartDetailsList
        .where((element) => element.year == year)
        .toList();
    setState(() {});
  }

  Future loadProject(String year, String month) async {
    final List<ProjectModel> projects = await _reportBloc.getSignedUpProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    data = projectReportHelper.chartDetailsList
        .where((element) =>
            element.year == year && element.month == month.substring(0, 3))
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
            ListDividerLabel(label: ANALYSIS_LABEL),
            filterDropDown(),
            reportView(),
            SizedBox(height: width * 0.05),
            ListDividerLabel(label: MONTHLY_REPORTS_LABEL),
            reportList(),
          ],
        ),
      ),
    );
  }

  Widget filterDropDown() {
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.05, width * 0.03, width * 0.05, 0),
      child: Row(
        children: [
          Expanded(child: selectYearDropDown()),
          SizedBox(width: 15),
          Expanded(child: selectMonthDropDown())
        ],
      ),
    );
  }

  Widget selectYearDropDown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_rounded),
      decoration: InputDecoration(
        hintText: SELECT_YEAR_HINT,
        hintStyle: TextStyle(color: DARK_GRAY),
        filled: true,
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      isExpanded: true,
      onChanged: (String? newValue) async {
        setState(() => _yearController.text = newValue!);
        await loadMonth(newValue!);
      },
      validator: (val) => null,
      items: _dateFromTimeStamp
          .getYears()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2,
          ),
        );
      }).toList(),
    );
  }

  Widget selectMonthDropDown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_rounded),
      decoration: InputDecoration(
        hintText: SELECT_MONTH_HINT,
        hintStyle: TextStyle(color: DARK_GRAY),
        filled: true,
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      isExpanded: true,
      onChanged: (String? newValue) async {
        setState(() => _monthController.text = newValue!);
        await loadProject(_yearController.text, newValue!);
      },
      validator: (val) => null,
      items: months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: _theme.textTheme.bodyText2,
          ),
        );
      }).toList(),
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
                padding: EdgeInsets.only(top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => TextStyle(
                          color: NORMAL_BAR_COLOR,
                          fontSize: 10,
                        ),
                        margin: 10,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTextStyles: (context, value) => TextStyle(
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
                CHART_MONTHS_LABEL,
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
      final yVal = e.hrs != null ? double.parse(e.hrs.toString()) : 0.0;
      return BarChartGroupData(
        x: e.hrs != null ? e.hrs! : 0,
        barRods: [
          BarChartRodData(
            toY: yVal,
            width: data.length == 12 ? 12 : 20,
            rodStackItems: [
              BarChartRodStackItem(0, yVal, DARK_BAR_COLOR),
              BarChartRodStackItem(yVal / 2, yVal, NORMAL_BAR_COLOR),
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

  Widget reportList() {
    Reports reports = Reports.fromList(list: data);
    return reports.reportList.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => CommonDivider(),
            physics: ScrollPhysics(),
            itemCount: reports.reportList.length,
            itemBuilder: (context, index) {
              ReportsDataModel report = reports.reportList[index];
              final ProjectModel project = report.project!;
              return StreamBuilder<bool>(
                initialData: false,
                stream: _reportBloc.getProjectExpandStream,
                builder: (context, snapshot) {
                  return ReportProjectTile(
                    project: project,
                    isExpanded: snapshot.data!,
                    reportBloc: _reportBloc,
                  );
                },
              );
            },
          )
        : Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    NO_ACTIVITIES_FOUNDS,
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
