import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/user_rewards_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class VolunteersBloc {
  final repo = Repository();

  final volunteersController = PublishSubject<Volunteers>();
  final _searchVolunteersList = BehaviorSubject<dynamic>();

  Stream<Volunteers> get getVolunteersStream => volunteersController.stream;
  Stream<dynamic> get getSearchedVolunteersStream =>
      _searchVolunteersList.stream;

  Future<bool> postEvents(List events) async {
    final bool response = await repo.postEventsRepo(events);
    return response;
  }

  Future getVolunteers() async {
    final Events response = await repo.getEventsRepo();
    volunteersFromAPI = Volunteers(list: peoplesList).peoples;
    volunteersController.sink.add(Volunteers(list: peoplesList));
  }

  List<PeopleModel> volunteersFromAPI = [];
  dynamic searchedVolunteersList = [];

  Future searchVolunteers(String searchText) async {
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

  void dispose() {
    volunteersController.close();
    _searchVolunteersList.close();
  }
}
