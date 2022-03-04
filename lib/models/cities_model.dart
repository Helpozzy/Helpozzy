import 'package:cloud_firestore/cloud_firestore.dart';

class Cities {
  Cities.fromJson({required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final Map<String, dynamic> city = element.data() as Map<String, dynamic>;
      cities.add(CityModel.fromJson(json: city));
    });
    cities.sort((a, b) =>
        a.cityName!.toLowerCase().compareTo(b.cityName!.toLowerCase()));
  }
  late List<CityModel> cities = [];
}

class CityModel {
  String? cityName;
  String? stateId;
  String? stateName;
  String? countyName;

  CityModel({
    this.cityName,
    this.stateId,
    this.stateName,
    this.countyName,
  });

  CityModel.fromJson({required Map<String, dynamic> json}) {
    cityName = json["city"];
    stateId = json["state_id"];
    stateName = json["state_name"];
    countyName = json["county_name"];
  }

  Map<String, dynamic> toJson() {
    return {
      "city": cityName,
      "state_id": stateId,
      "state_name": stateName,
      "county_name": countyName,
    };
  }
}

class States {
  States.fromJson({required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final Map<String, dynamic> state = element.data() as Map<String, dynamic>;
      states.add(StateModel.fromJson(json: state));
    });
    states.sort((a, b) =>
        a.stateName!.toLowerCase().compareTo(b.stateName!.toLowerCase()));
  }
  late List<StateModel> states = [];
}

class StateModel {
  String? stateId;
  String? stateName;

  StateModel({
    this.stateId,
    this.stateName,
  });

  StateModel.fromJson({required Map<String, dynamic> json}) {
    stateId = json["state_id"];
    stateName = json["state_name"];
  }

  Map<String, dynamic> toJson() {
    return {
      "state_id": stateId,
      "state_name": stateName,
    };
  }
}
