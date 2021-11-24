import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/state_city_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:rxdart/rxdart.dart';

class CityInfoBloc {
  final repo = Repository();
  final _searchCitiesController = PublishSubject<List<CityModel>>();

  Stream<List<CityModel>> get searchedCitiesStream =>
      _searchCitiesController.stream;

  Future<bool> postCities(List citiesList) async {
    final bool posted = await repo.postCitiesRepo(citiesList);
    return posted;
  }

  Future<StatesHelper> getStates() async {
    final Cities citiesList = await repo.getCitiesByStateRepo();
    final StatesHelper states = StatesHelper.fromCities(citiesList);
    return states;
  }

  Future<Cities> getCities(String stateName) async {
    final Cities citiesList = await repo.getCitiesByStateNameRepo(stateName);
    return citiesList;
  }

  List<CityModel> searchedSchoolList = [];

  Future searchCities(String searchText) async {
    final Cities response = await repo.getCitiesByStateRepo();
    searchedSchoolList = [];
    if (searchText.isEmpty) {
      _searchCitiesController.sink.add(response.cities);
    } else {
      response.cities.forEach((city) {
        if (city.city!.toLowerCase().contains(searchText.toLowerCase()) ||
            city.countyName!.toLowerCase().contains(searchText.toLowerCase()) ||
            city.stateName!.toLowerCase().contains(searchText.toLowerCase()) ||
            city.stateId!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedSchoolList.add(city);
        }
      });
      _searchCitiesController.sink.add(searchedSchoolList);
    }
  }

  void dispose() {
    _searchCitiesController.close();
  }
}
