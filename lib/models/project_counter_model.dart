class ProjectActivityModel {
  ProjectActivityModel({required String monthVal, int projectCounterVal = 0}) {
    month = monthVal;
    projectCounter = projectCounterVal;
  }
  late String month;
  late int projectCounter;
}
