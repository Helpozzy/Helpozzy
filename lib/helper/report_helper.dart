import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';

class ProjectReportHelper {
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  ProjectReportHelper.fromProjects(List<ProjectModel> projects) {
    projects.forEach((project) {
      final String projectSignedUpYear = _dateFormatFromTimeStamp.dateYearYYYY(
          timestamp: project.signedUpDate!);
      final String projectSignedUpMonth = _dateFormatFromTimeStamp.dateMonthMMM(
          timestamp: project.signedUpDate!);
      late List<ProjectModel> tempList = [];
      tempList.clear();
      if (chartDetails.isNotEmpty) {
        for (int i = 0; i < chartDetails.length; i++) {
          final ReportsDataModel report = chartDetails[i];
          if (report.month == projectSignedUpMonth) {
            report.month = projectSignedUpMonth;
            report.year = report.year;
            report.hrs = report.hrs! + project.totalTaskshrs!;
            report.projects!.add(project);
          } else {
            tempList.add(project);
            chartDetails.add(ReportsDataModel(
              month: projectSignedUpMonth,
              year: projectSignedUpYear,
              hrs: project.totalTaskshrs,
              projects: tempList,
            ));
          }
        }
      } else {
        tempList.add(project);
        chartDetails.add(ReportsDataModel(
          month: projectSignedUpMonth,
          year: projectSignedUpYear,
          hrs: project.totalTaskshrs,
          projects: tempList,
        ));
      }
    });
  }
  late List<ReportsDataModel> chartDetails = [];
}
