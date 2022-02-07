import 'package:flutter/material.dart';
import 'package:helpozzy/models/report_model.dart';
import 'package:helpozzy/screens/dashboard/reports/reports_chart.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportsByMonths extends StatefulWidget {
  @override
  _ReportsByMonthsState createState() => _ReportsByMonthsState();
}

class _ReportsByMonthsState extends State<ReportsByMonths> {
  late ThemeData _theme;
  late double height;
  late double width;
  late List<BarChartModel> data = [];

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: width * 0.02),
          Container(
            height: height / 2,
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: ReportGraph(),
          ),
          SizedBox(height: width * 0.05),
          ListDividerLabel(label: MONTHLY_REPORTS_LABEL),
          monthlyReportList(),
        ],
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
