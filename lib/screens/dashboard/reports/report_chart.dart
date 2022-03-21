import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/report_chart_model.dart';
import 'package:helpozzy/utils/constants.dart';

class ReportBarChart extends StatefulWidget {
  const ReportBarChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ReportBarChartState();
}

class ReportBarChartState extends State<ReportBarChart> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  late ThemeData _theme;
  late double height;
  late double width;
  late String yAxisLabel = CHART_YEARS_LABEL;
  late List<ChartDataModel> data = [];
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  @override
  void initState() {
    loadYear();
    super.initState();
  }

  Future loadYear() async {
    yAxisLabel = CHART_YEARS_LABEL;
    final List<String> years = _dateFormatFromTimeStamp.getYear();
    data = <ChartDataModel>[
      ChartDataModel(x: years[4], y: 45),
      ChartDataModel(x: years[3], y: 25),
      ChartDataModel(x: years[2], y: 35),
      ChartDataModel(x: years[1], y: 30),
      ChartDataModel(x: years[0], y: 25),
    ];
    setState(() {});
  }

  Future loadMonths(int year) async {
    yAxisLabel = CHART_MONTHS_LABEL;
    final List<String> months = _dateFormatFromTimeStamp.getMonths(year);
    data = <ChartDataModel>[
      ChartDataModel(x: months[11], y: 25),
      ChartDataModel(x: months[10], y: 45),
      ChartDataModel(x: months[9], y: 25),
      ChartDataModel(x: months[8], y: 35),
      ChartDataModel(x: months[7], y: 45),
      ChartDataModel(x: months[6], y: 25),
      ChartDataModel(x: months[5], y: 35),
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
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 15.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (touchEvent, response) async {
                        // print(response!.spot!.spot.x);
                        await loadMonths(2021);
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff939393), fontSize: 10),
                        margin: 10,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 45:
                              return 'Apr';
                            case 25:
                              return 'May';
                            case 2:
                              return 'Jun';
                            case 35:
                              return 'Jul';
                            case 30:
                              return 'Aug';
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff939393), fontSize: 10),
                        margin: 0,
                      ),
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: GRAY,
                        strokeWidth: 0.5,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: GRAY,
                        strokeWidth: 0.5,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    groupsSpace: data.length == 12 ? 13 : 30,
                    barGroups: getData(),
                  ),
                ),
              ),
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
                yAxisLabel,
                textAlign: TextAlign.center,
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return data.map((e) {
      final yVal = double.parse(e.y!.toString());
      return BarChartGroupData(
        x: e.y!,
        barRods: [
          BarChartRodData(
              toY: yVal,
              width: data.length == 12 ? 12 : 20,
              rodStackItems: [
                BarChartRodStackItem(0, yVal / 4, dark),
                BarChartRodStackItem(yVal / 4, yVal / 2, normal),
                BarChartRodStackItem(yVal / 2, yVal / 1, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      );
    }).toList();
  }
}
