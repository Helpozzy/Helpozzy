import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ReportLineChart extends StatefulWidget {
  @override
  _ReportLineChartState createState() => _ReportLineChartState();
}

class _ReportLineChartState extends State<ReportLineChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.60,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: ACCENT_GRAY,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 25.0,
                left: 12.0,
                top: 40,
                bottom: 12,
              ),
              child: LineChart(showAvg ? avgData : mainData),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: SmallCommonButton(
            fontSize: 10,
            buttonColor: BLUE_GRAY,
            onPressed: () => setState(() => showAvg = !showAvg),
            text: 'AVG',
          ),
        ),
      ],
    );
  }

  LineChartData get mainData => LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: BLUR_GRAY,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: BLUR_GRAY,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTextStyles: (context, value) => const TextStyle(
              color: BUTTON_GRAY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 2:
                  return '2019';
                case 5:
                  return '2020';
                case 8:
                  return '2021';
              }
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTextStyles: (context, value) => const TextStyle(
              color: BUTTON_GRAY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '50';
                case 3:
                  return '100';
                case 5:
                  return '150';
              }
              return '';
            },
            reservedSize: 32,
            margin: 12,
          ),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: BLUR_GRAY, width: 1)),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineBarsData: [mainBarData],
      );

  LineChartBarData get mainBarData => LineChartBarData(
        spots: const [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        show: true,
        // isStepLineChart: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      );

  LineChartData get avgData => LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: BLUR_GRAY,
              strokeWidth: 1,
            );
          },
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: BLUR_GRAY,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (context, value) => const TextStyle(
              color: BUTTON_GRAY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 2:
                  return 'MAR';
                case 5:
                  return 'JUN';
                case 8:
                  return 'SEP';
              }
              return '';
            },
            margin: 8,
            interval: 1,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: BUTTON_GRAY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '10k';
                case 3:
                  return '30k';
                case 5:
                  return '50k';
              }
              return '';
            },
            reservedSize: 32,
            interval: 1,
            margin: 12,
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: BLUR_GRAY, width: 1)),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineBarsData: [avgBarData],
      );

  LineChartBarData get avgBarData => LineChartBarData(
        spots: const [
          FlSpot(0, 3.44),
          FlSpot(2.6, 3.44),
          FlSpot(4.9, 3.44),
          FlSpot(6.8, 3.44),
          FlSpot(8, 3.44),
          FlSpot(9.5, 3.44),
          FlSpot(11, 3.44),
        ],
        isCurved: true,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!,
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!,
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
          ],
        ),
      );
}
