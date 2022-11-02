import 'package:helpozzy/models/report_data_model.dart';

class ProjectHelper {
  ProjectHelper.fromProjects(List<ReportsDataModel> projects) {
    late List<String> monthList = [];
    projects.forEach((filteredProject) {
      if (!monthList.contains(filteredProject.month)) {
        monthList.add(filteredProject.month!);
      }
    });
    monthList.forEach((String selectedMonth) {
      final tempList =
          projects.where((element) => element.month == selectedMonth).toList();
      final finalList = tempList.map((e) => e.projects).toList();
      final finalProjects =
          finalList.reduce((value, element) => value! + element!);
      monthlyList.add(ReportsDataModel(
        month: tempList.first.month,
        year: tempList.first.year,
        projects: finalProjects,
      ));
    });
  }

  late List<ReportsDataModel> monthlyList = [];
}
