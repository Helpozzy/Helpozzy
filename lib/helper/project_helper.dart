import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/project_counter_model.dart';
import 'package:intl/intl.dart';

class ProjectHelper {
  ProjectHelper.fromProjects(Projects projects) {
    projects.projectList.forEach((project) {
      final String month = DateFormat('MMMM').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(project.startDate!)),
      );
      if (monthlyList.isNotEmpty) {
        for (int i = 0; i < monthlyList.length; i++) {
          final ProjectActivityModel monthData = monthlyList[i];
          if (monthData.month == month) {
            monthData.month = month;
            monthData.projectCounter = monthData.projectCounter + 1;
          } else {
            monthlyList.add(ProjectActivityModel(
              monthVal: month,
              projectCounterVal: 1,
            ));
          }
          break;
        }
      } else {
        monthlyList.add(ProjectActivityModel(
          monthVal: month,
          projectCounterVal: 1,
        ));
      }
    });
  }
  late List<ProjectActivityModel> monthlyList = [];
}
