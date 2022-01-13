import 'package:helpozzy/firebase_repository/repository.dart';
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

  Future<States> getStates() async {
    final States states = await repo.getStateRepo();
    return states;
  }

  Future<Cities> getCities(String stateName) async {
    final Cities citiesList = await repo.getCitiesByStateNameRepo(stateName);
    return citiesList;
  }

  List<CityModel> searchedCityList = [];

  Future searchItem(
      {required List<CityModel> cities, required String searchText}) async {
    searchedCityList = [];
    if (searchText.isEmpty) {
      _searchCitiesController.sink.add(cities);
    } else {
      cities.forEach((city) {
        if (city.cityName!.toLowerCase().contains(searchText.toLowerCase())) {
          searchedCityList.add(city);
        }
      });
      _searchCitiesController.sink.add(searchedCityList);
    }
  }

  void dispose() {
    _searchCitiesController.close();
  }
}
