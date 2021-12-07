import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/school_helper.dart';
import 'package:helpozzy/helper/state_city_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsInfoBloc {
  final repo = Repository();

  final schoolsController = BehaviorSubject<Schools>();
  final statesController = BehaviorSubject<List<CityModel>>();
  final citiesController = BehaviorSubject<List<String>>();
  final _searchSchoolController = BehaviorSubject<List<SchoolDetailsModel>>();

  Stream<Schools> get schoolsStream => schoolsController.stream;
  Stream<List<CityModel>> get statesStream => statesController.stream;
  Stream<List<String>> get citiesStream => citiesController.stream;
  Stream<List<SchoolDetailsModel>> get searchedSchoolsStream =>
      _searchSchoolController.stream;

  Future<bool> postSchools(List schoolsList) async {
    final bool posted = await repo.postSchoolsRepo(schoolsList);
    return posted;
  }

  List<CityModel> searchedStateList = [];
  List<String> searchedCityList = [];
  List<SchoolDetailsModel> searchedSchoolsList = [];

  Future searchItem({
    required SearchBottomSheetType searchBottomSheetType,
    required String searchText,
    String? state,
    String? city,
  }) async {
    if (searchBottomSheetType == SearchBottomSheetType.STATE_BOTTOMSHEET) {
      final Cities citiesList = await repo.getCitiesByStateRepo();
      final StatesHelper statesList = StatesHelper.fromCities(citiesList);
      searchedStateList = [];
      if (searchText.isEmpty) {
        statesController.sink.add(statesList.states);
      } else {
        statesList.states.forEach((state) {
          if (state.stateName!
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
            searchedStateList.add(state);
          }
        });
        statesController.sink.add(searchedStateList);
      }
    } else if (searchBottomSheetType ==
        SearchBottomSheetType.CITY_BOTTOMSHEET) {
      final Schools response =
          await repo.getSchoolsRepo(state: state, city: city);
      final List<String> cities =
          await SchoolHelper().schoolCitiesByState(response);
      searchedCityList = [];
      if (searchText.isEmpty) {
        citiesController.sink.add(cities);
      } else {
        cities.forEach((city) {
          if (city.toLowerCase().contains(searchText.toLowerCase())) {
            searchedCityList.add(city);
          }
        });
        citiesController.sink.add(searchedCityList);
      }
    } else {
      final Schools response =
          await repo.getSchoolsRepo(state: state, city: city);
      searchedSchoolsList = [];
      if (searchText.isEmpty) {
        _searchSchoolController.sink.add(response.schools);
      } else {
        response.schools.forEach((school) {
          if (school.zip.toLowerCase().contains(searchText.toLowerCase())) {
            searchedSchoolsList.add(school);
          }
        });
        _searchSchoolController.sink.add(searchedSchoolsList);
      }
    }
  }

  void dispose() {
    schoolsController.close();
    statesController.close();
    citiesController.close();
    _searchSchoolController.close();
  }
}
