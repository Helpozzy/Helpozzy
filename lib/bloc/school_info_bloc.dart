import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsInfoBloc {
  final repo = Repository();

  final schoolsController = PublishSubject<Schools>();

  Stream<Schools> get schoolsStream => schoolsController.stream;

  Future getSchools() async {
    final Schools schools = await repo.getSchoolsRepo();
    schoolsController.sink.add(schools);
  }

  Future<bool> postSchools(List schoolsList) async {
    final bool posted = await repo.postSchoolsRepo(schoolsList);
    return posted;
  }

  void dispose() {
    schoolsController.close();
  }
}
