import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/user_rewards_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class VolunteersBloc {
  final repo = Repository();

  final volunteersController = PublishSubject<Volunteers>();
  final _searchVolunteersList = BehaviorSubject<dynamic>();
  final _filteredFavContoller = BehaviorSubject<bool>();

  Stream<Volunteers> get getVolunteersStream => volunteersController.stream;
  Stream<dynamic> get getSearchedVolunteersStream =>
      _searchVolunteersList.stream;
  Stream<bool> get getFavVolunteersStream => _filteredFavContoller.stream;

  Future<bool> postEvents(List events) async {
    final bool response = await repo.postEventsRepo(events);
    return response;
  }

  Future getVolunteers() async {
    final Events response = await repo.getEventsRepo();
    volunteersFromAPI = Volunteers(list: peoplesList).peoples;
    volunteersController.sink.add(Volunteers(list: peoplesList));
    return volunteersFromAPI;
  }

  List<PeopleModel> volunteersFromAPI = [];
  dynamic searchedVolunteersList = [];

  Future searchVolunteers({required String searchText}) async {
    await getVolunteers();
    searchedVolunteersList = [];
    if (searchText.isEmpty) {
      _searchVolunteersList.sink.add(volunteersFromAPI);
    } else {
      volunteersFromAPI.forEach((event) {
        if (event.name.toLowerCase().contains(searchText.toLowerCase()) ||
            event.address.toLowerCase().contains(searchText.toLowerCase())) {
          searchedVolunteersList.add(event);
        }
      });
      _searchVolunteersList.sink.add(searchedVolunteersList);
    }
  }

  Future sortVolunteersByName() async {
    final List<PeopleModel> list = await getVolunteers();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _searchVolunteersList.sink.add(list);
  }

  Future sortVolunteersByReviewedPersons() async {
    final List<PeopleModel> list = await getVolunteers();
    list.sort((a, b) => a.reviewsByPersons.compareTo(b.reviewsByPersons));
    _searchVolunteersList.sink.add(list);
  }

  Future sortVolunteersByRating() async {
    final List<PeopleModel> list = await getVolunteers();
    list.sort((a, b) => a.rating.compareTo(b.rating));
    _searchVolunteersList.sink.add(list);
  }

  Future changeFavVal(bool enabled) async {
    _filteredFavContoller.sink.add(enabled);
  }

  void dispose() {
    volunteersController.close();
    _searchVolunteersList.close();
    _filteredFavContoller.close();
  }
}
