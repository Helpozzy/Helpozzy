import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:rxdart/rxdart.dart';

class AirportDetailBloc {
  final repo = Repository();

  final volunteersController = PublishSubject<VolunteerTypes>();

  Stream<VolunteerTypes> get volunteersListStream =>
      volunteersController.stream;

  Future getVolunteerList() async {
    final VolunteerTypes response = await repo.volunteerListRepo();
    volunteersController.sink.add(response);
  }

  void dispose() {
    volunteersController.close();
  }
}
