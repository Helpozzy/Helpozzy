class Schools {
  Schools.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      schools.add(SchoolDetailsModel.fromjson(json: element));
    });
  }
  late List<SchoolDetailsModel> schools = [];
}

class SchoolDetailsModel {
  SchoolDetailsModel.fromjson({required Map<String, dynamic> json}) {
    ncesSchoolId = json['nces_school_id'];
    stateSchoolId = json['state_school_id'];
    stateDistrictId = json['state_district_id'];
    lowGrade = json['low_grade'];
    highGrade = json['high_grade'];
    schoolName = json['school_name'];
    district = json['district'];
    countyName = json['county_name'];
    streetAddress = json['street_address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    phone = json['phone'];
    students = json['students'];
  }

  Map<String, dynamic> toJson() {
    return {
      'nces_school_id': ncesSchoolId,
      'state_school_id': stateSchoolId,
      'state_district_id': stateDistrictId,
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

  late String ncesSchoolId;
  late String stateSchoolId;
  late String stateDistrictId;
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

// 'NCES School ID'
// 'State School ID'
// 'State District ID'
// 'Low Grade'
// 'High Grade'
// 'School Name'
// 'District'
// 'County Name'
// 'Street Address'
// 'City'
// 'State'
// 'Zip'
// 'Phone'
// 'Students'