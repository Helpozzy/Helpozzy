import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final repo = Repository();

  final eventsController = PublishSubject<Events>();
  final categorisedEventsController = PublishSubject<Events>();

  Stream<Events> get getEventsStream => eventsController.stream;
  Stream<Events> get getCategorisedEventsStream =>
      categorisedEventsController.stream;

  Future<bool> postEvents(List events) async {
    final bool response = await repo.postEventsRepo(events);
    return response;
  }

  Future getEvents() async {
    final Events response = await repo.getEventsRepo();
    eventsController.sink.add(response);
  }

  Future getCategorisedEvents(int categoryId) async {
    final Events response = await repo.getCategorisedEventsRepo(categoryId);
    categorisedEventsController.sink.add(response);
  }

  void dispose() {
    eventsController.close();
    categorisedEventsController.close();
  }
}
