import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';

class TasksStatusHelper {
  TasksStatusHelper(List<TaskModel> tasks) {
    tasks.forEach((task) {
      if (task.status == TOGGLE_NOT_STARTED) {
        projectNotStarted++;
      } else if (task.status == TOGGLE_INPROGRESS) {
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
