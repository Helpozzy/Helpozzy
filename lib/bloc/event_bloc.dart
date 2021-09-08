import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final repo = Repository();

  final eventsController = PublishSubject<Events>();
  final categorisedEventsController = PublishSubject<Events>();
  final _searchProjectsList = BehaviorSubject<dynamic>();

  Stream<Events> get getEventsStream => eventsController.stream;
  Stream<Events> get getCategorisedEventsStream =>
      categorisedEventsController.stream;
  Stream<dynamic> get getSearchedEventsStream => _searchProjectsList.stream;

  Future<bool> postEvents(List events) async {
    final bool response = await repo.postEventsRepo(events);
    return response;
  }

  Future getEvents() async {
    final Events response = await repo.getEventsRepo();
    eventsFromAPI = response.events;
    eventsController.sink.add(response);
  }

  List<EventModel> eventsFromAPI = [];
  dynamic searchedEventList = [];

  Future searchEvents(String searchText) async {
    searchedEventList = [];
    if (searchText.isEmpty) {
      _searchProjectsList.sink.add(eventsFromAPI);
    } else {
      eventsFromAPI.forEach((event) {
        if (event.eventName.toLowerCase().contains(searchText.toLowerCase()) ||
            event.location.toLowerCase().contains(searchText.toLowerCase()) ||
            event.organization
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          searchedEventList.add(event);
        }
      });
      _searchProjectsList.sink.add(searchedEventList);
    }
  }

  Future getCategorisedEvents(int categoryId) async {
    final Events response = await repo.getCategorisedEventsRepo(categoryId);
    categorisedEventsController.sink.add(response);
  }

  void dispose() {
    eventsController.close();
    categorisedEventsController.close();
    _searchProjectsList.close();
  }
}
