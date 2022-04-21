import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final repo = Repository();

  final PublishSubject<Projects> prefsProjectsController =
      PublishSubject<Projects>();

  Stream<Projects> get getPrefsProjectStream => prefsProjectsController.stream;

  Future getPrefsProjects() async {
    final Projects response = await repo.getPrefsProjectRepo();
    prefsProjectsController.sink.add(response);
  }

  void dispose() {
    prefsProjectsController.close();
  }
}
