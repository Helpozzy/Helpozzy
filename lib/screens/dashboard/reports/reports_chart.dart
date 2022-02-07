import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/report_chart_val_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportGraph extends StatefulWidget {
  const ReportGraph({Key? key}) : super(key: key);

  @override
  _ReportGraphState createState() => _ReportGraphState();
}

class _ReportGraphState extends State<ReportGraph> {
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  late double _columnWidth;
  late double _columnSpacing;
  List<ChartDataModel>? chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  Future loadData() async {
    _columnWidth = 0.75;
    _columnSpacing = 0.4;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      elevation: 0,
      opacity: 0.7,
      activationMode: ActivationMode.singleTap,
      canShowMarker: true,
      color: DARK_PINK_COLOR,
    );

    final List<String> months = _dateFormatFromTimeStamp.getPreviousSixMonths();
    chartData = <ChartDataModel>[
      ChartDataModel(
        x: months[5],
        yHrsValue: 25,
        yUsersValue: 30,
        yProjectsValue: 22,
      ),
      ChartDataModel(
        x: months[4],
        yHrsValue: 45,
        yUsersValue: 42,
        yProjectsValue: 55,
      ),
      ChartDataModel(
        x: months[3],
        yHrsValue: 25,
        yUsersValue: 24,
        yProjectsValue: 36,
      ),
      ChartDataModel(
        x: months[2],
        yHrsValue: 35,
        yUsersValue: 45,
        yProjectsValue: 55,
      ),
      ChartDataModel(
        x: months[1],
        yHrsValue: 30,
        yUsersValue: 35,
        yProjectsValue: 50,
      ),
      ChartDataModel(
        x: months[0],
        yHrsValue: 25,
        yUsersValue: 10,
        yProjectsValue: 15,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => _buildSpacingColumnChart();

  Widget _buildSpacingColumnChart() {
    return SfCartesianChart(
      backgroundColor: WHITE,
      title: ChartTitle(text: 'Volunteering Summary'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          maximum: 60,
          minimum: 0,
          interval: 10,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<ColumnSeries<ChartDataModel, String>> _getDefaultColumn() {
    return <ColumnSeries<ChartDataModel, String>>[
      ColumnSeries<ChartDataModel, String>(
          width: _columnWidth,
          spacing: _columnSpacing,
          dataSource: chartData!,
          color: const Color.fromRGBO(252, 216, 20, 1),
          xValueMapper: (ChartDataModel sales, _) => sales.x as String,
          yValueMapper: (ChartDataModel sales, _) => sales.yHrsValue,
          name: 'Users'),
      ColumnSeries<ChartDataModel, String>(
          dataSource: chartData!,
          width: _columnWidth,
          spacing: _columnSpacing,
          color: const Color.fromRGBO(169, 169, 169, 1),
          xValueMapper: (ChartDataModel sales, _) => sales.x as String,
          yValueMapper: (ChartDataModel sales, _) => sales.yUsersValue,
          name: 'Hours'),
      ColumnSeries<ChartDataModel, String>(
          dataSource: chartData!,
          width: _columnWidth,
          spacing: _columnSpacing,
          color: const Color.fromRGBO(205, 127, 50, 1),
          xValueMapper: (ChartDataModel sales, _) => sales.x as String,
          yValueMapper: (ChartDataModel sales, _) => sales.yProjectsValue,
          name: 'Projects')
    ];
  }
}
