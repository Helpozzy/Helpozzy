import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final repo = Repository();

  final prefsProjectsController = PublishSubject<List<ProjectModel>>();

  Stream<List<ProjectModel>> get getPrefsProjectStream =>
      prefsProjectsController.stream;

  List<ProjectModel> searchedPrefsProjects = [];

  Future getPrefsProjects({required int categoryId, String? searchText}) async {
    final Projects response =
        await repo.getCategorisedSignUpProjectsRepo(categoryId);
    searchedPrefsProjects.clear();
    if (searchText != null) {
      if (searchText.isEmpty) {
        prefsProjectsController.sink.add(response.projectList);
      } else {
        response.projectList.forEach((project) {
          if (project.projectName!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              project.organization!
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) {
            searchedPrefsProjects.add(project);
          }
        });
        prefsProjectsController.sink.add(searchedPrefsProjects);
      }
    } else {
      prefsProjectsController.sink.add(response.projectList);
    }
  }

  void dispose() {
    prefsProjectsController.close();
  }
}
