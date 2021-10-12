import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:rxdart/rxdart.dart';

class UserProjectsBloc {
  final repo = Repository();

  final projectsController = PublishSubject<Projects>();
  final categorisedProjectsController = PublishSubject<Projects>();
  final _searchProjectsList = BehaviorSubject<dynamic>();

  Stream<Projects> get getProjectsStream => projectsController.stream;
  Stream<Projects> get getCategorisedProjectsStream =>
      categorisedProjectsController.stream;
  Stream<dynamic> get getSearchedProjectsStream => _searchProjectsList.stream;

  Future getProjects() async {
    final Projects response = await repo.getuserProjectsRepo();
    projectsFromAPI = response.projects;
    projectsController.sink.add(response);
  }

  List<ProjectModel> projectsFromAPI = [];
  dynamic searchedProjectList = [];

  Future searchProjects(String searchText) async {
    searchedProjectList = [];
    if (searchText.isEmpty) {
      _searchProjectsList.sink.add(projectsFromAPI);
    } else {
      projectsFromAPI.forEach((project) {
        if (project.projectName
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            project.location.toLowerCase().contains(searchText.toLowerCase()) ||
            project.organization
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          searchedProjectList.add(project);
        }
      });
      _searchProjectsList.sink.add(searchedProjectList);
    }
  }

  Future getCategorisedProjects(int categoryId) async {
    final Projects response = await repo.getCategorisedProjectsRepo(categoryId);
    categorisedProjectsController.sink.add(response);
  }

  void dispose() {
    projectsController.close();
    categorisedProjectsController.close();
    _searchProjectsList.close();
  }
}
