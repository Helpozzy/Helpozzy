import 'dart:async';
import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/members_helper.dart';
import 'package:helpozzy/helper/rewards_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class MembersBloc {
  final repo = Repository();

  final _membersController = PublishSubject<Users>();
  final _userRewardDetailsController =
      PublishSubject<UserRewardsDetailsHelper>();
  final _searchMembersList = BehaviorSubject<List<SignUpAndUserModel>>();
  final _searchProjectMembersList = BehaviorSubject<List<SignUpAndUserModel>>();
  final _projectMembersList = BehaviorSubject<List<SignUpAndUserModel>>();

  Stream<Users> get getMembersStream => _membersController.stream;
  Stream<UserRewardsDetailsHelper> get getuserRewardDetailsStream =>
      _userRewardDetailsController.stream;
  Stream<List<SignUpAndUserModel>> get getSearchedMembersStream =>
      _searchMembersList.stream;
  Stream<List<SignUpAndUserModel>> get getSearchedProjectMembersStream =>
      _searchProjectMembersList.stream;
  Stream<List<SignUpAndUserModel>> get getProjectMembersStream =>
      _projectMembersList.stream;

  Future getMembers() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    _membersController.sink.add(users);
    _userRewardDetailsController.sink
        .add(UserRewardsDetailsHelper.fromUsers(users));
  }

  List<SignUpAndUserModel> searchedMembersList = [];

  Future searchMembers({required String searchText}) async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    searchedMembersList = [];
    if (searchText.isEmpty) {
      _searchMembersList.sink.add(users.peoples);
    } else {
      users.peoples.forEach((volunteer) {
        if (volunteer.firstName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            volunteer.lastName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            volunteer.email!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedMembersList.add(volunteer);
        }
      });
      _searchMembersList.sink.add(searchedMembersList);
    }
  }

  Future getProjectMembers(String projectId) async {
    final Tasks tasksResponse =
        await repo.getProjectTasksRepo(projectId, false);
    final List<SignUpAndUserModel> _projectMember =
        await ProjectMembers().fromTasks(tasksResponse.tasks);
    _projectMember.sort((a, b) =>
        a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
    projectMembersList = _projectMember;
    _projectMembersList.sink.add(_projectMember);
  }

  List<SignUpAndUserModel> projectMembersList = [];
  List<SignUpAndUserModel> searchedProjectMembersList = [];

  Future searchProjectMembers({required String searchText}) async {
    searchedProjectMembersList = [];
    if (searchText.isEmpty) {
      _searchProjectMembersList.sink.add(projectMembersList);
    } else {
      projectMembersList.forEach((volunteer) {
        if (volunteer.firstName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            volunteer.lastName!
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          searchedProjectMembersList.add(volunteer);
        }
      });
      _searchProjectMembersList.sink.add(searchedProjectMembersList);
    }
  }

  Future sortMembersByName() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    users.peoples.sort((a, b) =>
        a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
    _searchMembersList.sink.add(users.peoples);
  }

  Future sortMembersByRating() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    users.peoples.sort((a, b) => b.rating!.compareTo(a.rating!));
    _searchMembersList.sink.add(users.peoples);
  }

  void dispose() {
    _membersController.close();
    _userRewardDetailsController.close();
    _searchMembersList.close();
    _projectMembersList.close();
    _searchProjectMembersList.close();
  }
}
