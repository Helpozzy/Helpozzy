import 'package:helpozzy/models/project_model.dart';

class ProjectActivityModel {
  ProjectActivityModel({
    required String monthVal,
    int projectCounterVal = 0,
    required List<ProjectModel> projectsVal,
  }) {
    month = monthVal;
    projectCounter = projectCounterVal;
    projects = projectsVal;
  }
  late String month;
  late int projectCounter;
  late List<ProjectModel> projects;
}
