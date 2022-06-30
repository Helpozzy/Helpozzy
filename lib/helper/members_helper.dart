import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/task_model.dart';

class ProjectMembers {
  Future<List<SignUpAndUserModel>> fromTasks(List<TaskModel> tasks) async {
    List<SignUpAndUserModel> projectMembers = [];
    if (tasks.isNotEmpty) {
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].members != null && tasks[i].members!.isNotEmpty) {
          tasks[i].members!.forEach((memberId) async {
            if (!projectMembers.contains(memberId)) {
              final SignUpAndUserModel user =
                  await Repository().userInfoRepo(memberId);
              projectMembers.add(user);
            }
          });
        }
      }
    }
    projectMembers.sort((a, b) =>
        a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
    await Future.delayed(Duration(seconds: 1));
    return projectMembers;
  }
}
