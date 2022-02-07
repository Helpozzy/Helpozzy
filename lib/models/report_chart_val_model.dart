import 'package:flutter/material.dart';

class ChartDataModel {
  ChartDataModel(
      {this.x,
      this.xValue,
      this.yHrsValue,
      this.yUsersValue,
      this.yProjectsValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yHrsValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? yUsersValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? yProjectsValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}
