import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';

class ProjectReportHelper {
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  ProjectReportHelper.fromProjects(List<ProjectModel> projects) {
    projects.forEach((project) {
      final String projectStartYear =
          _dateFormatFromTimeStamp.dateYearYYYY(timestamp: project.startDate!);
      final String projectStartMonth =
          _dateFormatFromTimeStamp.dateMonthMMM(timestamp: project.startDate!);

      chartDetailsList.add(ReportsDataModel(
        month: projectStartMonth,
        year: projectStartYear,
        hrs: project.totalTaskshrs,
        project: project,
      ));
    });
  }

  late List<ReportsDataModel> chartDetailsList = [];
}
