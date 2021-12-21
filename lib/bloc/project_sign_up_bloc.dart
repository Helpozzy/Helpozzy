import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/project_sign_up_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectSignUpBloc {
  final repo = Repository();

  final projectSignUpController = PublishSubject<ProjectSignedUpUsers>();

  Stream<ProjectSignedUpUsers> get getProjectSignUpStream =>
      projectSignUpController.stream;

  Future<ResponseModel> postVolunteerProjectSignUp(
      ProjectSignUpModel projectSignUpVal) async {
    final ResponseModel response =
        await repo.postProjectSignupRepo(projectSignUpVal);
    return response;
  }

  Future getProjectTasks(String projectId) async {
    // final ProjectSignedUpUsers response = await repo.getProjectTasksRepo(projectId);
    // projectTasksController.sink.add(response);
  }

  void dispose() {
    projectSignUpController.close();
  }
}
