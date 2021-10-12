import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/user_rewards_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class MembersBloc {
  final repo = Repository();

  final membersController = PublishSubject<Volunteers>();
  final _searchMembersList = BehaviorSubject<dynamic>();
  final _filteredFavContoller = BehaviorSubject<bool>();

  Stream<Volunteers> get getMembersStream => membersController.stream;
  Stream<dynamic> get getSearchedMembersStream => _searchMembersList.stream;
  Stream<bool> get getFavVolunteersStream => _filteredFavContoller.stream;

  Future getMembers() async {
    membersFromAPI = Volunteers(list: peoplesList).peoples;
    membersController.sink.add(Volunteers(list: peoplesList));
    return membersFromAPI;
  }

  List<PeopleModel> membersFromAPI = [];
  dynamic searchedMembersList = [];

  Future searchMembers({required String searchText}) async {
    await getMembers();
    searchedMembersList = [];
    if (searchText.isEmpty) {
      _searchMembersList.sink.add(membersFromAPI);
    } else {
      membersFromAPI.forEach((project) {
        if (project.name.toLowerCase().contains(searchText.toLowerCase()) ||
            project.address.toLowerCase().contains(searchText.toLowerCase())) {
          searchedMembersList.add(project);
        }
      });
      _searchMembersList.sink.add(searchedMembersList);
    }
  }

  Future sortMembersByName() async {
    final List<PeopleModel> list = await getMembers();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _searchMembersList.sink.add(list);
  }

  Future sortMembersByReviewedPersons() async {
    final List<PeopleModel> list = await getMembers();
    list.sort((a, b) => a.reviewsByPersons.compareTo(b.reviewsByPersons));
    _searchMembersList.sink.add(list);
  }

  Future sortMembersByRating() async {
    final List<PeopleModel> list = await getMembers();
    list.sort((a, b) => a.rating.compareTo(b.rating));
    _searchMembersList.sink.add(list);
  }

  Future changeFavVal(bool enabled) async {
    _filteredFavContoller.sink.add(enabled);
  }

  void dispose() {
    membersController.close();
    _searchMembersList.close();
    _filteredFavContoller.close();
  }
}
