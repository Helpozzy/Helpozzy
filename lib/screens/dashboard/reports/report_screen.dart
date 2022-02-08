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
      ChartDataModel(
        x: months[5],
        yHrsValue: 25,
        yProjectsValue: 22,
      ),
      ChartDataModel(
        x: months[4],
        yHrsValue: 45,
        yProjectsValue: 55,
      ),
      ChartDataModel(
        x: months[3],
        yHrsValue: 25,
        yProjectsValue: 36,
      ),
      ChartDataModel(
        x: months[2],
        yHrsValue: 35,
        yProjectsValue: 55,
      ),
      ChartDataModel(
        x: months[1],
        yHrsValue: 30,
        yProjectsValue: 50,
      ),
      ChartDataModel(
        x: months[0],
        yHrsValue: 25,
        yProjectsValue: 15,
      ),
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
              child: ReportGraph(
                chartData: data,
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
      separatorBuilder: (context, index) => Divider(height: 0.5),
      physics: ScrollPhysics(),
      itemCount: reports.monthlyReports.length,
      itemBuilder: (context, index) {
        ChartDataModel report = reports.monthlyReports[index];
        return ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
          title: Text(
            report.x.toString(),
            style: _theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              keyValueTile(
                key: PROJECTS_LABEL,
                value: report.yHrsValue.toString(),
              ),
              keyValueTile(
                key: TOTAL_HRS_LABEL,
                value: report.yProjectsValue.toString(),
              ),
            ],
          ),
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
