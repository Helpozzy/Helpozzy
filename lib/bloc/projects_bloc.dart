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
  final categorisedProjectsController = PublishSubject<Projects>();
  final selectedMembersController = PublishSubject<List<SignUpAndUserModel>>();

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;
  Stream<List<ProjectModel>> get getProjectsStream => projectsController.stream;
  Stream<Projects> get getOnGoingProjectsStream =>
      onGoingProjectsController.stream;
  Stream<List<SignUpAndUserModel>> get getOtherUsersStream =>
      otherUserInfoController.stream;
  Stream<ProjectHelper> get getMonthlyProjectsStream =>
      projectsActivityStatusController.stream;
  Stream<Projects> get getCategorisedSignedUpProjectsStream =>
      categorisedProjectsController.stream;
  Stream<List<SignUpAndUserModel>> get getSelectedMembersStream =>
      selectedMembersController.stream;

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

  Future<List<ProjectModel>> getProjects(
      {ProjectTabType? projectTabType}) async {
    final Projects response =
        await repo.getprojectsRepo(projectTabType: projectTabType);
    projectsFromAPI = response.projectList;
    projectsController.sink.add(response.projectList);
    return response.projectList;
  }

  Future<ResponseModel> removeSignedUpProject(String enrolledProjectId) async {
    final ResponseModel response =
        await repo.removeEnrolledProjectRepo(enrolledProjectId);
    return response;
  }

  List<ProjectModel> projectsFromAPI = [];
  List<ProjectModel> searchedProjectList = [];

  Future searchProject(String searchText) async {
    searchedProjectList = [];
    if (searchText.isEmpty) {
      projectsController.sink.add(projectsFromAPI);
    } else {
      projectsFromAPI.forEach((project) {
        if (project.projectName!.contains(searchText) ||
            project.organization!.contains(searchText)) {
          searchedProjectList.add(project);
          print(project.toJson());
          print('Searched list length : ${searchedProjectList.length}');
        }
      });
      projectsController.sink.add(searchedProjectList);
    }
  }

  Future getProjectsActivityStatus(
      {required ProjectTabType projectTabType}) async {
    final Projects response =
        await repo.getprojectsRepo(projectTabType: projectTabType);
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
            user.firstName!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedUserList.add(user);
        }
      });
      otherUserInfoController.sink.add(searchedUserList);
    }
  }

  Future getCategorisedProjects(int categoryId) async {
    final Projects response = await repo.getCategorisedProjectsRepo(categoryId);
    categorisedProjectsController.sink.add(response);
  }

  Future<ProjectModel> getProjectByProjectId(
      String projectId, String signUpUserId) async {
    final ProjectModel response =
        await repo.getprojectByProjectIdRepo(projectId, signUpUserId);
    return response;
  }

  Future<ResponseModel> updateEnrolledProjectHrs(
      String signupUserId, String projectId, int hrs) async {
    final ResponseModel response =
        await repo.updateEnrolledProjectHrsRepo(signupUserId, projectId, hrs);
    return response;
  }

  Future getSelectedMembers({required List<SignUpAndUserModel> members}) async {
    selectedMembersController.sink.add(members);
  }

  void dispose() {
    projectDetailsExpandController.close();
    projectsActivityStatusController.close();
    projectsController.close();
    otherUserInfoController.close();
    onGoingProjectsController.close();
    categorisedProjectsController.close();
    selectedMembersController.close();
  }
}
