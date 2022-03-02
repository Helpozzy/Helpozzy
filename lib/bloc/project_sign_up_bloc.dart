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

  Future getEnrolledProjects() async {
    final Projects response = await repo.getEnrolledProjectRepo();
    projectSignUpController.sink.add(response);
  }

  Future<ResponseModel> updateSignedUpProject(ProjectModel project) async {
    final ResponseModel response =
        await repo.updateEnrolledProjectRepo(project);
    return response;
  }

  void dispose() {
    projectSignUpController.close();
  }
}
