import 'package:helpozzy/models/cities_model.dart';

class StatesHelper {
  StatesHelper.fromCities(Cities citiesList) {
    citiesList.cities.forEach((city) {
      if (!states.contains(city.stateName)) {
        states.add(city.stateName!);
      }
    });
    states.sort((a, b) => a.compareTo(b));
  }

  List<String> states = <String>[];
}
