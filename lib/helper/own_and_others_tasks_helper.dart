import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';

class ProjectOwnTaskAndOthersHelper {
  ProjectOwnTaskAndOthersHelper.fromProject(List<TaskModel> tasks) {
    tasks.forEach((task) {
      if (task.ownerId == prefsObject.getString(CURRENT_USER_ID)) {
        ownTasks.add(task);
      } else {
        othersTasks.add(task);
      }
    });
  }
  late List<TaskModel> ownTasks = [];
  late List<TaskModel> othersTasks = [];
}
