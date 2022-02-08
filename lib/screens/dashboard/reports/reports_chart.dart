import 'package:flutter/material.dart';
import 'package:helpozzy/models/report_chart_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportGraph extends StatefulWidget {
  const ReportGraph({Key? key, required this.chartData}) : super(key: key);
  final List<ChartDataModel>? chartData;
  @override
  _ReportGraphState createState() => _ReportGraphState(chartData: chartData);
}

class _ReportGraphState extends State<ReportGraph> {
  _ReportGraphState({required this.chartData});
  final List<ChartDataModel>? chartData;
  late double _columnWidth;
  late double _columnSpacing;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  Future initialize() async {
    _columnWidth = 0.75;
    _columnSpacing = 0.4;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      elevation: 0,
      opacity: 0.7,
      activationMode: ActivationMode.singleTap,
      canShowMarker: true,
      color: BLACK,
    );
  }

  @override
  Widget build(BuildContext context) => _buildSpacingColumnChart();

  Widget _buildSpacingColumnChart() {
    return SfCartesianChart(
      backgroundColor: WHITE,
      title: ChartTitle(text: 'Volunteering Summary'),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
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
        dataSource: chartData!,
        width: _columnWidth,
        spacing: _columnSpacing,
        color: const Color.fromRGBO(169, 169, 169, 1),
        xValueMapper: (ChartDataModel sales, _) => sales.x as String,
        yValueMapper: (ChartDataModel sales, _) => sales.yHrsValue,
        name: 'Hours',
      ),
      ColumnSeries<ChartDataModel, String>(
        dataSource: chartData!,
        width: _columnWidth,
        spacing: _columnSpacing,
        color: const Color.fromRGBO(252, 216, 20, 1),
        xValueMapper: (ChartDataModel sales, _) => sales.x as String,
        yValueMapper: (ChartDataModel sales, _) => sales.yProjectsValue,
        name: 'Projects',
      )
    ];
  }
}
