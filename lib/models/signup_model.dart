class SignUpModel {
  SignUpModel({
    this.volunteerType,
    this.name,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.personalPhnNo,
    this.parentEmail,
    this.relationshipWithParent,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.schoolName,
    this.gradeLevel,
    this.userType,
    this.areaOfInterests,
  });

  SignUpModel.fromJson({required Map<String, dynamic> json}) {
    volunteerType = json['volunteer_type'];
    name = json['name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    personalPhnNo = json['personal_phn_no'];
    parentEmail = json['parent_email'];
    relationshipWithParent = json['relationship_with_parent'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    schoolName = json['school_name'];
    gradeLevel = json['grade_level'];
    userType = json['user_type'];
    areaOfInterests = json['area_of_interests'];
  }

  Map<String, dynamic> toJson() {
    return {
      'volunteer_type': volunteerType,
      'name': name,
      'email': email,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'personal_phn_no': personalPhnNo,
      'parent_email': parentEmail,
      'relationship_with_parent': relationshipWithParent,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'school_name': schoolName,
      'grade_level': gradeLevel,
      'user_type': userType,
      'area_of_interests': areaOfInterests,
    };
  }

  late int? volunteerType;
  late String? name;
  late String? email;
  late String? dateOfBirth;
  late String? gender;
  late String? personalPhnNo;
  late String? parentEmail;
  late String? relationshipWithParent;
  late String? address;
  late String? city;
  late String? state;
  late String? zipCode;
  late String? schoolName;
  late String? gradeLevel;
  late String? userType;
  late List<int>? areaOfInterests = [];
}
