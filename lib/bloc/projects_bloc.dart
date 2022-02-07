import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/project_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class ProjectsBloc {
  final repo = Repository();

  final projectDetailsExpandController = PublishSubject<bool>();
  final projectsController = PublishSubject<Projects>();
  final onGoingProjectsController = PublishSubject<Projects>();
  final otherUserInfoController = PublishSubject<Users>();
  final _searchUsersList = BehaviorSubject<dynamic>();
  final projectsActivityStatusController = PublishSubject<ProjectHelper>();

  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;
  Stream<Projects> get getProjectsStream => projectsController.stream;
  Stream<Projects> get getOnGoingProjectsStream =>
      onGoingProjectsController.stream;
  Stream<Users> get getOtherUsersStream => otherUserInfoController.stream;
  Stream<ProjectHelper> get getMonthlyProjectsStream =>
      projectsActivityStatusController.stream;
  Stream<dynamic> get getSearchedUsersStream => _searchUsersList.stream;

  Future isExpanded(bool isExpanded) async {
    projectDetailsExpandController.sink.add(isExpanded);
  }

  Future<bool> postProject(ProjectModel project) async {
    final bool response = await repo.postProjectRepo(project);
    return response;
  }

  Future getProjects({ProjectTabType? projectTabType}) async {
    final Projects response =
        await repo.getprojectsRepo(projectTabType: projectTabType);
    projectsController.sink.add(response);
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
    otherUserInfoController.sink.add(response);
  }

  List<SignUpAndUserModel> usersFromAPI = [];
  dynamic searchedUserList = [];

  Future searchUsers(String searchText) async {
    searchedUserList = [];
    if (searchText.isEmpty) {
      _searchUsersList.sink.add([]);
    } else {
      usersFromAPI.forEach((project) {
        if (project.email!.toLowerCase().contains(searchText.toLowerCase()) ||
            project.name!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedUserList.add(project);
        }
      });
      _searchUsersList.sink.add(searchedUserList);
    }
  }

  void dispose() {
    projectDetailsExpandController.close();
    projectsActivityStatusController.close();
    projectsController.close();
    otherUserInfoController.close();
    _searchUsersList.close();
    onGoingProjectsController.close();
  }
}
