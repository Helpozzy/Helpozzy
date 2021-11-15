class ProjectActivityModel {
  ProjectActivityModel(
      {required String monthVal,
      int projectCounterVal = 0,
      int projectActivities = 0}) {
    month = monthVal;
    projectCounter = projectCounterVal;
    activities = projectActivities;
  }
  late String month;
  late int projectCounter;
  late int activities;
}
