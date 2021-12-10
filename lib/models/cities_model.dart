class Cities {
  Cities.fromJson({required List<Map<String, dynamic>> items}) {
    items.forEach((element) {
      cities.add(CityModel.fromJson(json: element));
    });
    cities
        .sort((a, b) => a.city!.toLowerCase().compareTo(b.city!.toLowerCase()));
  }
  late List<CityModel> cities = [];
}

class CityModel {
  String? city;
  String? stateId;
  String? stateName;
  String? countyName;

  CityModel({
    this.city,
    this.stateId,
    this.stateName,
    this.countyName,
  });

  CityModel.fromJson({required Map<String, dynamic> json}) {
    city = json["city"];
    stateId = json["state_id"];
    stateName = json["state_name"];
    countyName = json["county_name"];
  }

  Map<String, dynamic> toJson() {
    return {
      "city": city,
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
