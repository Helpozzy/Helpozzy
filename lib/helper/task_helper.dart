import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';

class TasksStatusHelper {
  TasksStatusHelper({required List<TaskModel> tasks}) {
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

class ProjectTasksHelper {
  late List<SignUpAndUserModel> projectMembers = [];
  ProjectTasksHelper({required List<TaskModel> tasks}) {
    tasks.forEach((task) {
      if (task.members != null && task.members!.isNotEmpty) {
        task.members!.forEach((memberId) async {
          if (!projectMembers.contains(memberId)) {
            final SignUpAndUserModel user =
                await Repository().userInfoRepo(memberId);
            projectMembers.add(user);
          }
        });
      }
    });
  }
}
