import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';

class ProjectReportHelper {
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();

  ProjectReportHelper.fromProjects(List<ProjectModel> projects) {
    projects.forEach((project) {
      late List<ProjectModel> projectsList = [];
      final String projectStartYear =
          _dateFormatFromTimeStamp.dateYearYYYY(timestamp: project.startDate!);
      final String projectStartMonth =
          _dateFormatFromTimeStamp.dateMonthMMM(timestamp: project.startDate!);

      final List<ReportsDataModel> list = chartDetailsList
          .where((element) => element.year == projectStartYear)
          .toList();

      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          if (list[i].year == projectStartYear) {
            projectsList = [];
            if (list[i].month == projectStartMonth) {
              list[i].projectsList!.add(project);
              list[i].month = list[i].month;
              list[i].year = list[i].year;
              list[i].projectsList = list[i].projectsList;
              list[i].projectsCounter = list[i].projectsList!.length;
            } else {
              projectsList.add(project);
              list.add(ReportsDataModel(
                month: projectStartMonth,
                year: list[i].year,
                projectsCounter: projectsList.length,
                projectsList: projectsList,
              ));
            }
          } else {
            projectsList.add(project);
            list.add(ReportsDataModel(
              month: projectStartMonth,
              year: projectStartYear,
              projectsCounter: projectsList.length,
              projectsList: projectsList,
            ));
          }
        }
      } else {
        projectsList.add(project);
        chartDetailsList.add(ReportsDataModel(
          month: projectStartMonth,
          year: projectStartYear,
          projectsCounter: projectsList.length,
          projectsList: projectsList,
        ));
      }
    });
  }

  late List<ReportsDataModel> chartDetailsList = [];
}
