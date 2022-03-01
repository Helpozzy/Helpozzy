import 'package:cloud_firestore/cloud_firestore.dart';

class Schools {
  Schools.fromJson({required List<QueryDocumentSnapshot<Object?>> list}) {
    for (int i = 0; i < list.length; i++) {
      final project = list[i].data() as Map<String, dynamic>;
      if (list[i]['city'] != null) {
        schools.add(SchoolDetailsModel.fromjson(json: project));
      }
    }
  }
  late List<SchoolDetailsModel> schools = [];
}

class SchoolDetailsModel {
  SchoolDetailsModel.fromjson({required Map<String, dynamic> json}) {
    if (json.isNotEmpty) {
      lowGrade = json['low_grade'] ?? '';
      highGrade = json['high_grade'] ?? '';
      schoolName = json['school_name'] ?? '';
      district = json['district'];
      countyName = json['county_name'] ?? '';
      streetAddress = json['street_address'] ?? '';
      city = json['city'] ?? '';
      state = json['state'];
      zip = json['zip'];
      phone = json['phone'] ?? '';
      students = json['students'] ?? '';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'low_grade': lowGrade,
      'high_grade': highGrade,
      'school_name': schoolName,
      'district': district,
      'county_name': countyName,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'zip': zip,
      'phone': phone,
      'students': students,
    };
  }

  late String lowGrade;
  late String highGrade;
  late String schoolName;
  late String district;
  late String countyName;
  late String streetAddress;
  late String city;
  late String state;
  late String zip;
  late String phone;
  late String students;
}
