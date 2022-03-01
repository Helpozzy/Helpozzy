import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/school_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsInfoBloc {
  final repo = Repository();

  final statesController = PublishSubject<List<StateModel>>();
  final citiesController = PublishSubject<List<String>>();
  final _searchSchoolController = PublishSubject<List<SchoolDetailsModel>>();

  Stream<List<StateModel>> get statesStream => statesController.stream;
  Stream<List<String>> get citiesStream => citiesController.stream;
  Stream<List<SchoolDetailsModel>> get searchedSchoolsStream =>
      _searchSchoolController.stream;

  List<StateModel> statesFromAPI = [];

  Future getStates() async {
    final States statesList = await repo.getStateRepo();
    statesFromAPI = statesList.states;
    statesController.sink.add(statesFromAPI);
  }

  List<String> citiesOfStateFromAPI = [];

  Future getCities({String? state}) async {
    final Schools response = await repo.getSchoolsRepo(state: state);
    final List<String> cities =
        await SchoolHelper().schoolCitiesByState(response);
    citiesOfStateFromAPI = cities;
    citiesController.sink.add(citiesOfStateFromAPI);
  }

  List<SchoolDetailsModel> schoolsFromAPI = [];

  Future getSchools({String? state, String? city}) async {
    final Schools response =
        await repo.getSchoolsRepo(state: state, city: city);
    schoolsFromAPI = response.schools;
    schoolsFromAPI.sort((a, b) =>
        a.schoolName.toLowerCase().compareTo(b.schoolName.toLowerCase()));
    _searchSchoolController.sink.add(schoolsFromAPI);
  }

  List<StateModel> searchedStateList = [];
  List<String> searchedCityList = [];
  List<SchoolDetailsModel> searchedSchoolsList = [];

  Future searchItem({
    required SearchBottomSheetType searchBottomSheetType,
    required String searchText,
  }) async {
    if (searchBottomSheetType == SearchBottomSheetType.STATE_BOTTOMSHEET) {
      searchedStateList = [];
      if (searchText.isEmpty) {
        statesController.sink.add(statesFromAPI);
      } else {
        statesFromAPI.forEach((state) {
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
      searchedCityList = [];
      if (searchText.isEmpty) {
        citiesController.sink.add(citiesOfStateFromAPI);
      } else {
        citiesOfStateFromAPI.forEach((city) {
          if (city.toLowerCase().contains(searchText.toLowerCase())) {
            searchedCityList.add(city);
          }
        });
        citiesController.sink.add(searchedCityList);
      }
    } else {
      searchedSchoolsList = [];
      if (searchText.isEmpty) {
        _searchSchoolController.sink.add(schoolsFromAPI);
      } else {
        schoolsFromAPI.forEach((school) {
          if (school.countyName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              school.schoolName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              school.zip.toLowerCase().contains(searchText.toLowerCase())) {
            searchedSchoolsList.add(school);
          }
        });
        _searchSchoolController.sink.add(searchedSchoolsList);
      }
    }
  }

  void dispose() {
    statesController.close();
    citiesController.close();
    _searchSchoolController.close();
  }
}
