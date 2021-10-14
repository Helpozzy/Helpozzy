class SignUpModel {
  SignUpModel({
    this.volunteerType,
    this.name,
    this.email,
    this.dateOfBirth,
    this.personalPhnNo,
    this.parentPhnNo,
    this.relationshipWithParent,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.schoolName,
    this.gradeLevel,
    this.userType,
  });
  SignUpModel.fromJson({required Map<String, dynamic> json}) {
    volunteerType = json['volunteer_type'];
    name = json['name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    personalPhnNo = json['personal_phn_no'];
    parentPhnNo = json['parent_phn_no'];
    relationshipWithParent = json['relationship_with_parent'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    schoolName = json['school_name'];
    gradeLevel = json['grade_level'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    return {
      'volunteer_type': volunteerType,
      'name': name,
      'email': email,
      'date_of_birth': dateOfBirth,
      'personal_phn_no': personalPhnNo,
      'parent_phn_no': parentPhnNo,
      'relationship_with_parent': relationshipWithParent,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'school_name': schoolName,
      'grade_level': gradeLevel,
      'user_type': userType
    };
  }

  late int? volunteerType;
  late String? name;
  late String? email;
  late String? dateOfBirth;
  late String? personalPhnNo;
  late String? parentPhnNo;
  late String? relationshipWithParent;
  late String? address;
  late String? city;
  late String? state;
  late String? zipCode;
  late String? schoolName;
  late String? gradeLevel;
  late String? userType;
}
