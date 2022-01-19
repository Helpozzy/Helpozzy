import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:helpozzy/models/report_model.dart';

class BarChartGraph extends StatefulWidget {
  final List<BarChartModel> data;

  const BarChartGraph({required this.data});

  @override
  _BarChartGraphState createState() => _BarChartGraphState();
}

class _BarChartGraphState extends State<BarChartGraph> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: 'Financial',
        data: widget.data,
        domainFn: (BarChartModel series, _) => series.month,
        measureFn: (BarChartModel series, _) => series.hours,
      ),
    ];

    return _buildFinancialList(series);
  }

  Widget _buildFinancialList(series) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      padding: EdgeInsets.all(10),
      child: charts.BarChart(series, animate: true),
    );
  }
}
