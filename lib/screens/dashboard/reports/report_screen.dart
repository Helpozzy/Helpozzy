import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/report_chart_model.dart';
import 'package:helpozzy/screens/dashboard/reports/pvsa_chart.dart';
import 'package:helpozzy/screens/dashboard/reports/report_chart.dart';
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
  late List<ChartDataModel> data = [];
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  void initState() {
    loadYear();
    super.initState();
  }

  Future loadYear() async {
    yAxisLabel = CHART_YEARS_LABEL;
    final List<String> years = _dateFormatFromTimeStamp.getYear();
    data = <ChartDataModel>[
      ChartDataModel(x: years[4], y: 45),
      ChartDataModel(x: years[3], y: 25),
      ChartDataModel(x: years[2], y: 35),
      ChartDataModel(x: years[1], y: 30),
      ChartDataModel(x: years[0], y: 25),
    ];
    setState(() {});
  }

  Future loadMonths(int year) async {
    yAxisLabel = CHART_MONTHS_LABEL;
    final List<String> months = _dateFormatFromTimeStamp.getMonths(year);
    data = <ChartDataModel>[
      ChartDataModel(x: months[11], y: 25),
      ChartDataModel(x: months[10], y: 45),
      ChartDataModel(x: months[9], y: 25),
      ChartDataModel(x: months[8], y: 35),
      ChartDataModel(x: months[7], y: 45),
      ChartDataModel(x: months[6], y: 25),
      ChartDataModel(x: months[5], y: 35),
      ChartDataModel(x: months[4], y: 45),
      ChartDataModel(x: months[3], y: 25),
      ChartDataModel(x: months[2], y: 35),
      ChartDataModel(x: months[1], y: 30),
      ChartDataModel(x: months[0], y: 25),
    ];
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
            ListDividerLabel(label: 'Service Accomplishments'),
            ListTile(
              title: Text('Service Detail'),
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
    return ReportBarChart();
  }

  Widget monthlyReportList() {
    Reports reports = Reports.fromJson(list: data);
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => CommonDivider(),
      physics: ScrollPhysics(),
      itemCount: reports.monthlyReports.length,
      itemBuilder: (context, index) {
        ChartDataModel report = reports.monthlyReports[index];
        return Padding(
          padding:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.x.toString(),
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                PROJECTS_LABEL + report.y.toString(),
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
