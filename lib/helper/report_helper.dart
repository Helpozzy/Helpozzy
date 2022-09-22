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

      chartDetailsList.add(ReportsDataModel(
        month: projectSignedUpMonth,
        year: projectSignedUpYear,
        hrs: project.totalTaskshrs,
        project: project,
      ));
    });
  }

  late List<ReportsDataModel> chartDetailsList = [];
}
