class VolunteerTypes {
  VolunteerTypes.fromJson(List<dynamic> json) {
    json.forEach((element) {
      if (element['id'] != 2) {
        if (element['id'] != 3) {
          volunteers.add(VolunteerModel.fromjson(json: element));
        }
      }
    });
  }
  late List<VolunteerModel> volunteers = [];
}

class VolunteerModel {
  VolunteerModel.fromjson({required Map<String, dynamic> json}) {
    id = json['id'];
    type = json['value'];
  }

  late int id;
  late String type;
}
