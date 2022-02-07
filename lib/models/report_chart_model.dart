import 'package:flutter/material.dart';

class Reports {
  Reports.fromJson({required List<ChartDataModel> list}) {
    list.forEach((element) {
      monthlyReports.add(ChartDataModel(
          x: element.x,
          yHrsValue: element.yHrsValue,
          yProjectsValue: element.yProjectsValue));
    });
  }

  late List<ChartDataModel> monthlyReports = [];
}

class ChartDataModel {
  ChartDataModel(
      {this.x,
      this.xValue,
      this.yHrsValue,
      this.yProjectsValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  final dynamic x;
  final dynamic xValue;
  final num? yHrsValue;
  final num? yProjectsValue;
  final Color? pointColor;
  final num? size;
  final String? text;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
  final num? volume;
}
