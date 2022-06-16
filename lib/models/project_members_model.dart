import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/task_model.dart';

class ProjectMembers {
  ProjectMembers.fromJson(List<QueryDocumentSnapshot> tasks) {
    tasks.forEach((element) {
      final TaskModel task =
          TaskModel.fromjson(json: element.data() as Map<String, dynamic>);
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
    projectMembers.sort((a, b) =>
        a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
  }
  final List<SignUpAndUserModel> projectMembers = [];
}
