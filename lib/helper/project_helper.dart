import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/project_counter_model.dart';
import 'package:intl/intl.dart';

class ProjectHelper {
  ProjectHelper.fromProjects(Projects projects) {
    projects.projectList.forEach((project) {
      final String month = DateFormat('MMMM').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(project.startDate)),
      );
      late ProjectActivityModel monthActivity;
      if (monthlyList.isNotEmpty) {
        monthlyList.forEach((monthData) {
          if (monthData.month == month) {
            monthData.projectCounter++;
            monthActivity = ProjectActivityModel(
              monthVal: month,
              projectCounterVal: monthData.projectCounter,
            );
          } else {
            monthData.projectCounter++;
            monthActivity = ProjectActivityModel(
              monthVal: month,
              projectCounterVal: monthData.projectCounter,
            );
          }
        });
      } else {
        monthActivity =
            ProjectActivityModel(monthVal: month, projectCounterVal: 1);
      }
      monthlyList.add(monthActivity);
    });
  }
  late List<ProjectActivityModel> monthlyList = [];
}
