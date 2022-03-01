import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectSignUpBloc {
  final repo = Repository();

  final projectSignUpController = PublishSubject<Projects>();

  Stream<Projects> get getProjectSignUpStream => projectSignUpController.stream;

  Future<ResponseModel> postVolunteerProjectSignUp(
      ProjectModel projectSignUpVal) async {
    final ResponseModel response =
        await repo.postProjectSignupRepo(projectSignUpVal);
    return response;
  }

  Future getProjectTasks(String projectId) async {
    // final Projects response = await repo.getProjectTasksRepo(projectId);
    // projectTasksController.sink.add(response);
  }

  void dispose() {
    projectSignUpController.close();
  }
}
