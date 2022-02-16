import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/report_chart_model.dart';
import 'package:helpozzy/screens/dashboard/reports/reports_chart.dart';
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
  late List<ChartDataModel> data = [];
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future loadData() async {
    final List<String> months = _dateFormatFromTimeStamp.getPreviousSixMonths();
    data = <ChartDataModel>[
      ChartDataModel(x: months[5], y: 25),
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
            SizedBox(height: width * 0.02),
            Container(
              height: height / 2,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: ReportGraph(chartData: data),
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
            SizedBox(height: width * 0.05),
            ListDividerLabel(label: MONTHLY_REPORTS_LABEL),
            monthlyReportList(),
          ],
        ),
      ),
    );
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
