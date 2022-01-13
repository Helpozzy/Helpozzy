class Cities {
  Cities.fromJson({required List<Map<String, dynamic>> items}) {
    items.forEach((element) {
      cities.add(CityModel.fromJson(json: element));
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
  States.fromJson({required List<Map<String, dynamic>> items}) {
    items.forEach((element) {
      states.add(StateModel.fromJson(json: element));
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
