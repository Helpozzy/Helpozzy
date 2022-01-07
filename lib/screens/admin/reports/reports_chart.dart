import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/utils/constants.dart';

class ReportLineChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportLineChartState();
}

class ReportLineChartState extends State<ReportLineChart> {
  late bool isShowingMainData;

  late double height;
  late double width;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: const BoxDecoration(
          color: ACCENT_GRAY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              UNFOLD_REPORT + DateTime.now().year.toString(),
              style: _theme.textTheme.bodyText2!.copyWith(
                color: Color(0xff827daa),
                letterSpacing: 1,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              MONTHY_HOURS,
              style: _theme.textTheme.headline6!.copyWith(
                color: DARK_PINK_COLOR,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                child: _LineChart(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 6,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: DARK_GRAY.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: bottomTitles,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '50';
              case 2:
                return '100';
              case 3:
                return '150';
              case 4:
                return '200';
              case 5:
                return '250';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData => [lineChartBarData];

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 1,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: SILVER_GRAY,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: SILVER_GRAY,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        getTitles: (value) {
          final List<String> lastFiveMonth =
              DateFormatFromTimeStamp().getLastFiveMonth();
          switch (value.toInt()) {
            case 1:
              return lastFiveMonth[4];
            case 2:
              return lastFiveMonth[3];
            case 3:
              return lastFiveMonth[2];
            case 4:
              return lastFiveMonth[1];
            case 5:
              return lastFiveMonth[0];
          }

          return '';
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: SILVER_GRAY, width: 0.5),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0.3,
        colors: [DARK_PINK_COLOR.withOpacity(0.3)],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          colors: [DARK_PINK_COLOR.withOpacity(0.1)],
        ),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(2, 1.9),
          FlSpot(3, 5),
          FlSpot(4, 2.8),
          FlSpot(5, 3.9),
        ],
      );
}
