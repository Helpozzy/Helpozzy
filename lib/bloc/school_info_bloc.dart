import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsInfoBloc {
  final repo = Repository();

  final schoolsController = PublishSubject<Schools>();
  final _searchSchoolsController = PublishSubject<List<SchoolDetailsModel>>();

  Stream<Schools> get schoolsStream => schoolsController.stream;
  Stream<List<SchoolDetailsModel>> get searchedSchoolsStream =>
      _searchSchoolsController.stream;

  Future<bool> postSchools(List schoolsList) async {
    final bool posted = await repo.postSchoolsRepo(schoolsList);
    return posted;
  }

  Future getSchools() async {
    final Schools schools = await repo.getSchoolsRepo();
    schoolsController.sink.add(schools);
  }

  List<SchoolDetailsModel> searchedSchoolList = [];

  Future searchSchool(String searchText) async {
    final Schools response = await repo.getSchoolsRepo();
    searchedSchoolList = [];
    if (searchText.isEmpty) {
      _searchSchoolsController.sink.add(response.schools);
    } else {
      response.schools.forEach((school) {
        if (school.schoolName
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            school.countyName
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            school.city.toLowerCase().contains(searchText.toLowerCase()) ||
            school.state.toLowerCase().contains(searchText.toLowerCase()) ||
            school.district.toLowerCase().contains(searchText.toLowerCase())) {
          searchedSchoolList.add(school);
        }
      });
      _searchSchoolsController.sink.add(searchedSchoolList);
    }
  }

  void dispose() {
    schoolsController.close();
    _searchSchoolsController.close();
  }
}
