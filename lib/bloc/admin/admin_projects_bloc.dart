import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:rxdart/rxdart.dart';

class AdminProjectsBloc {
  final repo = Repository();

  final projectDetailsExpandController = PublishSubject<bool>();
  final projectsController = PublishSubject<Projects>();

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;
  Stream<Projects> get getProjectsStream => projectsController.stream;

  Future isExpanded(bool isExpanded) async {
    projectDetailsExpandController.sink.add(isExpanded);
  }

  Future<bool> postProject(ProjectModel project) async {
    final bool response = await repo.postProjectRepo(project);
    return response;
  }

  Future getProjects() async {
    final Projects response = await repo.getprojectsRepo();
    projectsController.sink.add(response);
  }

  void dispose() {
    projectDetailsExpandController.close();
    projectsController.close();
  }
}
