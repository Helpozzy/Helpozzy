import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/rewards_helper.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class MembersBloc {
  final repo = Repository();

  final membersController = PublishSubject<Users>();
  final userRewardDetailsController =
      PublishSubject<UserRewardsDetailsHelper>();
  final _searchMembersList = BehaviorSubject<dynamic>();
  final _searchProjectMembersList = BehaviorSubject<dynamic>();
  final _filteredFavContoller = BehaviorSubject<bool>();

  Stream<Users> get getMembersStream => membersController.stream;
  Stream<UserRewardsDetailsHelper> get getuserRewardDetailsStream =>
      userRewardDetailsController.stream;
  Stream<dynamic> get getSearchedMembersStream => _searchMembersList.stream;
  Stream<dynamic> get getSearchedProjectMembersStream =>
      _searchProjectMembersList.stream;
  Stream<bool> get getFavVolunteersStream => _filteredFavContoller.stream;

  Future getMembers() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    membersController.sink.add(users);
    userRewardDetailsController.sink
        .add(UserRewardsDetailsHelper.fromUsers(users));
  }

  dynamic searchedMembersList = [];

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
            volunteer.email!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedMembersList.add(volunteer);
        }
      });
      _searchMembersList.sink.add(searchedMembersList);
    }
  }

  Future searchProjectMembers(
      {required String searchText, required String projectId}) async {
    searchedMembersList = [];
    final ProjectTasksHelper projectTaskHelper =
        await repo.projectUsersRepo(projectId);
    if (searchText.isEmpty) {
      _searchProjectMembersList.sink.add(projectTaskHelper.projectMembers);
    } else {
      projectTaskHelper.projectMembers.forEach((volunteer) {
        if (volunteer.firstName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            volunteer.email!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedMembersList.add(volunteer);
        }
      });
      _searchProjectMembersList.sink.add(searchedMembersList);
    }
  }

  Future sortMembersByName() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    users.peoples.sort((a, b) =>
        a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
    _searchMembersList.sink.add(users.peoples);
  }

  Future sortMembersByReviewedPersons() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    users.peoples
        .sort((a, b) => a.reviewsByPersons!.compareTo(b.reviewsByPersons!));
    _searchMembersList.sink.add(users.peoples);
  }

  Future sortMembersByRating() async {
    final Users users =
        await repo.usersRepo(prefsObject.getString(CURRENT_USER_ID)!);
    users.peoples.sort((a, b) => b.rating!.compareTo(a.rating!));
    _searchMembersList.sink.add(users.peoples);
  }

  Future changeFavVal(bool enabled) async {
    _filteredFavContoller.sink.add(enabled);
  }

  void dispose() {
    membersController.close();
    userRewardDetailsController.close();
    _searchMembersList.close();
    _searchProjectMembersList.close();
    _filteredFavContoller.close();
  }
}
