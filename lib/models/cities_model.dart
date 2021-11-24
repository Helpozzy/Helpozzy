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
