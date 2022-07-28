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
  final projectByIdController = PublishSubject<ProjectModel>();
  final onGoingProjectsController = PublishSubject<Projects>();
  final otherUserInfoController = PublishSubject<List<SignUpAndUserModel>>();
  final projectsActivityStatusController = PublishSubject<ProjectHelper>();
  final categorisedProjectsController = PublishSubject<List<ProjectModel>>();
  final selectedMembersController = PublishSubject<List<SignUpAndUserModel>>();

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;
  Stream<List<ProjectModel>> get getProjectsStream => projectsController.stream;
  Stream<ProjectModel> get getProjectByIdStream => projectByIdController.stream;
  Stream<Projects> get getOnGoingProjectsStream =>
      onGoingProjectsController.stream;
  Stream<List<SignUpAndUserModel>> get getOtherUsersStream =>
      otherUserInfoController.stream;
  Stream<ProjectHelper> get getMonthlyProjectsStream =>
      projectsActivityStatusController.stream;
  Stream<List<ProjectModel>> get getCategorisedSignedUpProjectsStream =>
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

  List<ProjectModel> searchedProjects = [];

  Future getProjects(
      {ProjectTabType? projectTabType, String? searchText}) async {
    final Projects response =
        await repo.getprojectsRepo(projectTabType: projectTabType);
    searchedProjects.clear();
    if (searchText != null) {
      if (searchText.isEmpty) {
        projectsController.sink.add(response.projectList);
      } else {
        response.projectList.forEach((project) {
          if (project.projectName!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              project.organization!
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) {
            searchedProjects.add(project);
          }
        });
        projectsController.sink.add(searchedProjects);
      }
    } else {
      projectsController.sink.add(response.projectList);
    }
  }

  Future<ResponseModel> removeSignedUpProject(String enrolledProjectId) async {
    final ResponseModel response =
        await repo.removeEnrolledProjectRepo(enrolledProjectId);
    return response;
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

  List<ProjectModel> searchedCategorisedProjects = [];

  Future getCategorisedProjects(
      {required int categoryId, String? searchText}) async {
    final Projects response = await repo.getCategorisedProjectsRepo(categoryId);
    searchedCategorisedProjects.clear();
    if (searchText != null) {
      if (searchText.isEmpty) {
        categorisedProjectsController.sink.add(response.projectList);
      } else {
        response.projectList.forEach((project) {
          if (project.projectName!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              project.organization!
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) {
            searchedCategorisedProjects.add(project);
          }
        });
        categorisedProjectsController.sink.add(searchedCategorisedProjects);
      }
    } else {
      categorisedProjectsController.sink.add(response.projectList);
    }
  }

  Future<ProjectModel> getSignedUpProjectByProjectId(
      String projectId, String signUpUserId) async {
    final ProjectModel response =
        await repo.getSignedUpProjectByProjectIdRepo(projectId, signUpUserId);
    return response;
  }

  Future<ProjectModel> getProjectByProjectId(String projectId) async {
    final ProjectModel response =
        await repo.getProjectByProjectIdRepo(projectId);
    projectByIdController.sink.add(response);
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
    projectByIdController.close();
    onGoingProjectsController.close();
    categorisedProjectsController.close();
    selectedMembersController.close();
  }
}
