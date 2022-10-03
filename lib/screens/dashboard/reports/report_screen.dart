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
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ThemeData _theme;
  late double height;
  late double width;
  final DateFormatFromTimeStamp _dateFromTimeStamp = DateFormatFromTimeStamp();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final ReportBloc _reportBloc = ReportBloc();
  late String selectedYear = DateTime.now().year.toString();
  late String selectedMonth = '';
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    loadMonth(selectedYear);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Future loadMonth(String year) async {
    selectedYear = year;
    final List<ProjectModel> projects = await _reportBloc.getSignedUpProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    final List<ReportsDataModel> filterdList =
        projectReportHelper.chartDetails.where((e) => e.year == year).toList();
    await _reportBloc.getFilteredReportProjects(filterdList);
  }

  Future loadProject(String year, String month) async {
    selectedYear = year;
    selectedMonth = month;
    final List<ProjectModel> projects = await _reportBloc.getSignedUpProjects();
    final ProjectReportHelper projectReportHelper =
        ProjectReportHelper.fromProjects(projects);
    final List<ReportsDataModel> filterdList = projectReportHelper.chartDetails
        .where((e) => e.year == year && e.month == month.substring(0, 3))
        .toList();
    await _reportBloc.getFilteredReportProjects(filterdList);
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
            ListDividerLabel(
              label: selectedMonth.isNotEmpty
                  ? ANALYSIS_LABEL +
                      ' : ' +
                      selectedMonth.toUpperCase() +
                      ' - ' +
                      selectedYear
                  : ANALYSIS_LABEL + ' : ' + selectedYear,
            ),
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
        fillColor: Colors.transparent,
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
        fillColor: Colors.transparent,
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
    return StreamBuilder<List<ReportsDataModel>>(
      stream: _reportBloc.getFilteredReportProjectsTaskStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }
        final List<ReportsDataModel> reportList = snapshot.data!;
        return reportList.isNotEmpty
            ? AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding:
                      EdgeInsets.only(right: width * 0.05, left: width * 0.02),
                  child: SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                      name: CHART_MONTHS_LABEL,
                      title: AxisTitle(text: CHART_MONTHS_LABEL),
                    ),
                    primaryYAxis: NumericAxis(
                      name: CHART_HOURS_VERTICAL_LABEL,
                      numberFormat: NumberFormat.decimalPattern(),
                      title: AxisTitle(text: CHART_HOURS_VERTICAL_LABEL),
                    ),
                    isTransposed: true,
                    series: <ChartSeries>[
                      BarSeries<ReportsDataModel, String>(
                        width: 0.5,
                        spacing: 0.3,
                        dataSource: reportList,
                        name: 'Project Hrs',
                        isVisibleInLegend: true,
                        enableTooltip: true,
                        xValueMapper: (ReportsDataModel data, _) => data.month,
                        yValueMapper: (ReportsDataModel data, _) => data.hrs,
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      NO_RECORDS_FOUNDS,
                      style: _theme.textTheme.headline6!.copyWith(
                          color: DARK_GRAY, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NO_ANALYST_FOUNDS,
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.bodyText2!
                          .copyWith(color: DARK_GRAY),
                    ),
                  ],
                ),
              );
      },
    );
  }

  List getData(List<ReportsDataModel> reportList) {
    return reportList.map((e) {
      final double yVal = e.hrs != null ? double.parse(e.hrs.toString()) : 0.0;
      BarSeries<ReportsDataModel, String>(
        dataSource: reportList,
        xValueMapper: (ReportsDataModel data, _) => data.month,
        yValueMapper: (ReportsDataModel data, _) => yVal,
        width: 0.6,
        spacing: 0.3,
      );
    }).toList();
  }

  Widget reportList() {
    return StreamBuilder<List<ReportsDataModel>>(
      stream: _reportBloc.getFilteredReportProjectsTaskStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: LinearLoader(),
          );
        }
        final List<ReportsDataModel> reportList = snapshot.data!;
        Reports reports = Reports.fromList(list: reportList);
        return reports.reportList.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  for (var list in reports.reportList)
                    for (var project in list.projects!)
                      StreamBuilder<bool>(
                        initialData: false,
                        stream: _reportBloc.getProjectExpandStream,
                        builder: (context, snapshot) {
                          return ReportProjectTile(
                            project: project,
                            isExpanded: snapshot.data!,
                            reportBloc: _reportBloc,
                          );
                        },
                      ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Text(
                  NO_ACTIVITIES_FOUNDS,
                  style: _theme.textTheme.headline6!
                      .copyWith(color: DARK_GRAY, fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }
}
