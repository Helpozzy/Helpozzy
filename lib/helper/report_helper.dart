import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';

class FilteredProjectHelper {
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  FilteredProjectHelper.fromProjects(List<ProjectModel> projects) {
    for (int i = 0; i < projects.length; i++) {
      final ProjectModel project = projects[i];
      final String projectSignedUpYear = _dateFormatFromTimeStamp.dateYearYYYY(
          timestamp: project.signedUpDate!);
      final String projectSignedUpMonth = _dateFormatFromTimeStamp.dateMonthMMM(
          timestamp: project.signedUpDate!);
      projectListByMonthAndYear.add(ReportsDataModel(
        month: projectSignedUpMonth,
        year: projectSignedUpYear,
        hrs: project.totalTaskshrs,
        projects: [project],
      ));
    }
  }
  late List<ReportsDataModel> projectListByMonthAndYear = [];
}

class ProjectReportHelper {
  ProjectReportHelper.generateReportList(
    List<ReportsDataModel> filteredProjects,
    String monthReceived,
    String year,
  ) {
    late String month = '';
    if (monthReceived.isNotEmpty && monthReceived.length > 2) {
      month = monthReceived.substring(0, 3);
    }
    if (year.isNotEmpty && month.isNotEmpty && month.length == 3) {
      final tempList = filteredProjects
          .where((element) => element.month == month && element.year == year)
          .toList();
      final finalList = tempList.map((e) => e.hrs).toList();
      if (finalList.isNotEmpty) {
        final finalTotal =
            finalList.reduce((value, element) => value! + element!);

        barChart.add(ReportsDataModel(
          hrs: finalTotal,
          month: tempList.first.month,
          year: tempList.first.year,
          projects: [],
        ));
      }
      chartDetails.addAll(tempList);
    } else if (year.isNotEmpty) {
      late List monthList = [];
      filteredProjects.forEach((filteredProject) {
        if (!monthList.contains(filteredProject.month)) {
          monthList.add(filteredProject.month);
        }
      });
      monthList.forEach((selectedMonth) {
        final tempList = filteredProjects
            .where((element) =>
                element.month == selectedMonth && element.year == year)
            .toList();
        final finalList = tempList.map((e) => e.hrs).toList();
        if (finalList.isNotEmpty) {
          final finalTotal =
              finalList.reduce((value, element) => value! + element!);

          barChart.add(ReportsDataModel(
            hrs: finalTotal,
            month: tempList.first.month,
            year: tempList.first.year,
            projects: [],
          ));
        }
        chartDetails.addAll(tempList);
      });
    }
  }
  late List<ReportsDataModel> chartDetails = [];
  late List<ReportsDataModel> barChart = [];
}
