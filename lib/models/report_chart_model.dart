class Reports {
  Reports.fromJson({required List<ChartDataModel> list}) {
    list.forEach((element) {
      monthlyReports.add(ChartDataModel(
        x: element.x,
        y: element.y,
      ));
    });
  }

  late List<ChartDataModel> monthlyReports = [];
}

class ChartDataModel {
  ChartDataModel({
    this.x,
    this.y,
  });

  final String? x;
  final num? y;
}
