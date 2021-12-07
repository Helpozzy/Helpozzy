import 'package:helpozzy/models/cities_model.dart';

class StatesHelper {
  StatesHelper.fromCities(Cities citiesList) {
    for (int i = 0; i < citiesList.cities.length; i++) {
      if (!states.any(
          (element) => element.stateName == citiesList.cities[i].stateName)) {
        states.add(CityModel(
          stateId: citiesList.cities[i].stateId,
          stateName: citiesList.cities[i].stateName,
        ));
      }
    }
    states.sort((a, b) =>
        a.stateName!.toLowerCase().compareTo(b.stateName!.toLowerCase()));
  }
  List<CityModel> states = <CityModel>[];
}
