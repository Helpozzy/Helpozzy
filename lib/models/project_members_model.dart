import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/task_model.dart';

class ProjectMembers {
  const ProjectMembers({required this.projectMembers});
  final List<SignUpAndUserModel> projectMembers;
  factory ProjectMembers.fromJson(List<QueryDocumentSnapshot> tasks) {
    List<SignUpAndUserModel> projectMembersTest = [];
    tasks.forEach((element) {
      final TaskModel task =
          TaskModel.fromjson(json: element.data() as Map<String, dynamic>);
      if (task.members != null && task.members!.isNotEmpty) {
        task.members!.forEach((memberId) async {
          if (!projectMembersTest.contains(memberId)) {
            final SignUpAndUserModel user =
                await Repository().userInfoRepo(memberId);
            projectMembersTest.add(user);
          }
        });
      }
    });
    projectMembersTest.sort((a, b) =>
        a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
    return ProjectMembers(projectMembers: projectMembersTest);
  }
}
