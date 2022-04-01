import 'package:helpozzy/models/project_model.dart';

class Reports {
  Reports.fromList({required List<ReportsDataModel> list}) {
    list.forEach((element) {
      reportList.add(ReportsDataModel(
        month: element.month,
        year: element.year,
        hrs: element.hrs,
        project: element.project,
      ));
    });
  }
  late List<ReportsDataModel> reportList = [];
}

class ReportsDataModel {
  ReportsDataModel({
    this.project,
    this.year,
    this.month,
    this.hrs,
  });

  late String? year;
  late String? month;
  late int? hrs = 0;
  late ProjectModel? project;
}
