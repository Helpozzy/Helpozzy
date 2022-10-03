import 'package:helpozzy/models/project_model.dart';

class Reports {
  Reports.fromList({required List<ReportsDataModel> list}) {
    list.forEach((element) {
      reportList.add(ReportsDataModel(
        month: element.month,
        year: element.year,
        hrs: element.hrs,
        projects: element.projects,
      ));
    });
  }
  late List<ReportsDataModel> reportList = [];
}

class ReportsDataModel {
  ReportsDataModel({
    this.year,
    this.month,
    this.hrs,
    this.projects,
  });

  late String? year;
  late String? month;
  late int? hrs = 0;
  late List<ProjectModel>? projects;
}
