import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';

class TaskHelper {
  TaskHelper({required List<TaskModel> tasks}) {
    tasks.forEach((task) {
      if (task.status == PROJECT_NOT_STARTED) {
        projectNotStarted++;
      } else if (task.status == PROJECT_IN_PROGRESS) {
        projectInProgress++;
      } else {
        projectCompleted++;
      }
    });
  }
  late int projectNotStarted = 0;
  late int projectInProgress = 0;
  late int projectCompleted = 0;
}
