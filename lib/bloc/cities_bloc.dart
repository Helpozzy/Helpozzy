import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:rxdart/rxdart.dart';

class CityInfoBloc {
  final repo = Repository();

  final citiesController = PublishSubject<Cities>();
  final _searchCitiesController = PublishSubject<List<CityModel>>();

  Stream<Cities> get citiesStream => citiesController.stream;
  Stream<List<CityModel>> get searchedCitiesStream =>
      _searchCitiesController.stream;

  Future<bool> postSchools(List citiesList) async {
    final bool posted = await repo.postCitiesRepo(citiesList);
    return posted;
  }

  Future getSchools() async {
    final Cities schools = await repo.getCitiesRepo();
    citiesController.sink.add(schools);
  }

  List<CityModel> searchedSchoolList = [];

  Future searchSchool(String searchText) async {
    final Cities response = await repo.getCitiesRepo();
    searchedSchoolList = [];
    if (searchText.isEmpty) {
      _searchCitiesController.sink.add(response.cities);
    } else {
      response.cities.forEach((school) {
        if (school.city!.toLowerCase().contains(searchText.toLowerCase()) ||
            school.countyName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            school.stateName!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            school.stateId!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedSchoolList.add(school);
        }
      });
      _searchCitiesController.sink.add(searchedSchoolList);
    }
  }

  void dispose() {
    citiesController.close();
    _searchCitiesController.close();
  }
}
