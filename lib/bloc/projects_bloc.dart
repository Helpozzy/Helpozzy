import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/project_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class ProjectsBloc {
  final repo = Repository();

  final projectDetailsExpandController = PublishSubject<bool>();
  final projectsController = PublishSubject<List<ProjectModel>>();
  final onGoingProjectsController = PublishSubject<Projects>();
  final otherUserInfoController = PublishSubject<List<SignUpAndUserModel>>();
  final projectsActivityStatusController = PublishSubject<ProjectHelper>();
  final completedOwnProjectsController = PublishSubject<Projects>();
  final categorisedProjectsController = PublishSubject<Projects>();

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;
  Stream<List<ProjectModel>> get getProjectsStream => projectsController.stream;
  Stream<Projects> get getOnGoingProjectsStream =>
      onGoingProjectsController.stream;
  Stream<List<SignUpAndUserModel>> get getOtherUsersStream =>
      otherUserInfoController.stream;
  Stream<ProjectHelper> get getMonthlyProjectsStream =>
      projectsActivityStatusController.stream;
  Stream<Projects> get getCompletedProjectsStream =>
      completedOwnProjectsController.stream;
  Stream<Projects> get getCategorisedProjectsStream =>
      categorisedProjectsController.stream;

  Future isExpanded(bool isExpanded) async {
    projectDetailsExpandController.sink.add(isExpanded);
  }

  Future<ResponseModel> postProject(ProjectModel project) async {
    final ResponseModel response = await repo.postProjectRepo(project);
    return response;
  }

  Future<ResponseModel> updateProject(ProjectModel project) async {
    final ResponseModel response = await repo.updateProjectRepo(project);
    return response;
  }

  Future<ResponseModel> deleteProject(String projectId) async {
    final ResponseModel response = await repo.deleteProjectRepo(projectId);
    return response;
  }

  Future getProjects({ProjectTabType? projectTabType}) async {
    final Projects response =
        await repo.getprojectsRepo(projectTabType: projectTabType);
    projectsFromAPI = response.projectList;
    projectsController.sink.add(response.projectList);
  }

  List<ProjectModel> projectsFromAPI = [];
  List<ProjectModel> searchedProjectList = [];

  Future searchProject(String searchText) async {
    searchedProjectList = [];
    if (searchText.isEmpty) {
      projectsController.sink.add(projectsFromAPI);
    } else {
      projectsFromAPI.forEach((project) {
        if (project.projectName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            project.location!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            project.organization!
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          searchedProjectList.add(project);
        }
      });
      projectsController.sink.add(searchedProjectList);
    }
  }

  Future getProjectsActivityStatus() async {
    final Projects response = await repo.getprojectsRepo();
    final ProjectHelper projectHelper = ProjectHelper.fromProjects(response);
    projectsActivityStatusController.sink.add(projectHelper);
  }

  Future getOnGoingProjects({required ProjectTabType projectTabType}) async {
    final Projects response =
        await repo.getprojectsRepo(projectTabType: projectTabType);
    onGoingProjectsController.sink.add(response);
  }

  Future getOtherUsersInfo() async {
    final Users response = await repo.getOtherUserInfoRepo();
    usersFromAPI = response.peoples;
    otherUserInfoController.sink.add(response.peoples);
  }

  List<SignUpAndUserModel> usersFromAPI = [];
  List<SignUpAndUserModel> searchedUserList = [];

  Future searchUsers(String searchText) async {
    searchedUserList = [];
    if (searchText.isEmpty) {
      otherUserInfoController.sink.add([]);
    } else {
      usersFromAPI.forEach((user) {
        if (user.email!.toLowerCase().contains(searchText.toLowerCase()) ||
            user.name!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedUserList.add(user);
        }
      });
      otherUserInfoController.sink.add(searchedUserList);
    }
  }

  Future getOwnCompletedProjects() async {
    final Projects response = await repo.getuserCompletedProjectsRepo();
    completedOwnProjectsController.sink.add(response);
  }

  Future getCategorisedProjects(int categoryId) async {
    final Projects response = await repo.getCategorisedProjectsRepo(categoryId);
    categorisedProjectsController.sink.add(response);
  }

  void dispose() {
    projectDetailsExpandController.close();
    projectsActivityStatusController.close();
    projectsController.close();
    otherUserInfoController.close();
    onGoingProjectsController.close();
    completedOwnProjectsController.close();
    categorisedProjectsController.close();
  }
}
