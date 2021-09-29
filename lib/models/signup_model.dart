class SignUpModel {
  SignUpModel.fromJson({required Map<String, dynamic> json}) {
    volunteerType = json['volunteer_type'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    dateOfBirth = json['date_of_birth'] ?? '';
    personalPhnNo = json['personal_phn_no'] ?? '';
    parentPhnNo = json['parent_phn_no'] ?? '';
    relationshipWithParent = json['relationship_with_parent'] ?? '';
    address = json['address'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    zipCode = json['zip_code'] ?? '';
    schoolName = json['school_name'] ?? '';
    gradeLevel = json['grade_level'] ?? '';
  }

  Map<String, dynamic> fromModelToMap() {
    var json = Map<String, dynamic>();
    json['volunteer_type'] = volunteerType;
    json['name'] = name;
    json['email'] = email;
    json['date_of_birth'] = dateOfBirth;
    json['personal_phn_no'] = personalPhnNo;
    json['parent_phn_no'] = parentPhnNo;
    json['relationship_with_parent'] = relationshipWithParent;
    json['address'] = address;
    json['city'] = city;
    json['state'] = state;
    json['zip_code'] = zipCode;
    json['school_name'] = schoolName;
    json['grade_level'] = gradeLevel;
    return json;
  }

  late int volunteerType;
  late String name;
  late String email;
  late String dateOfBirth;
  late String personalPhnNo;
  late String parentPhnNo;
  late String relationshipWithParent;
  late String address;
  late String city;
  late String state;
  late String zipCode;
  late String schoolName;
  late String gradeLevel;
}
