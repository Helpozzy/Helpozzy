import 'package:helpozzy/models/school_model.dart';

class SchoolHelper {
  Future<List<String>> schoolStates(Schools schoolsList) async {
    List<String> states = <String>[];
    for (int i = 0; i < schoolsList.schools.length; i++) {
      if (!states.contains(schoolsList.schools[i].state)) {
        states.add(schoolsList.schools[i].state);
      }
    }
    states.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return states;
  }

  Future schoolCitiesByState(Schools schoolsList) async {
    List<String> cities = <String>[];
    for (int i = 0; i < schoolsList.schools.length; i++) {
      if (!cities.contains(schoolsList.schools[i].city)) {
        cities.add(schoolsList.schools[i].city);
      }
    }
    cities.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return cities;
  }
}
