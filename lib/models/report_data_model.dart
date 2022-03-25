import 'package:helpozzy/models/project_model.dart';

class Reports {
  Reports.fromList({required List<ReportsDataModel> list}) {
    list.forEach((element) {
      reports.add(ReportsDataModel(
        month: element.month,
        year: element.year,
        projectsCounter: element.projectsCounter,
        projectsList: element.projectsList,
      ));
    });
  }
  late List<ReportsDataModel> reports = [];
}

class ReportsDataModel {
  ReportsDataModel({
    this.projectsList,
    this.year,
    this.month,
    this.projectsCounter,
  });

  late String? year;
  late String? month;
  late int? projectsCounter = 0;
  late List<ProjectModel>? projectsList = [];
}
