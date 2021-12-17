import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users.fromJson({required List<QueryDocumentSnapshot> list}) {
    list.forEach((element) {
      final userJson = element.data() as Map<String, dynamic>;
      peoples.add(SignUpAndUserModel.fromJson(json: userJson));
    });
  }
  late List<SignUpAndUserModel> peoples = [];
}

class SignUpAndUserModel {
  SignUpAndUserModel({
    this.volunteerType,
    this.profileUrl,
    this.name,
    this.email,
    this.about,
    this.dateOfBirth,
    this.gender,
    this.countryCode,
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
    this.currentYearTargetHours,
    this.favorite,
    this.pointGifted,
    this.rating,
    this.reviewsByPersons,
    this.joiningDate,
  });

  SignUpAndUserModel.fromJson({required Map<String, dynamic> json}) {
    volunteerType = json['volunteer_type'];
    profileUrl = json['profile_url'];
    name = json['name'];
    email = json['email'];
    about = json['about'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    countryCode = json['country_code'];
    personalPhnNo = json['personal_phn_no'];
    parentEmail = json['parents_email'];
    relationshipWithParent = json['relationship_with_parent'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    schoolName = json['school_name'];
    gradeLevel = json['grade_level'];
    userType = json['user_type'];
    if (json['area_of_interests'] != null &&
        json['area_of_interests'].isNotEmpty) {
      List<int> areaOfInterestids = [];
      json['area_of_interests'].forEach((element) {
        areaOfInterestids.add(element);
      });
      areaOfInterests = areaOfInterestids;
    }
    currentYearTargetHours = json['current_year_target_hours'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    reviewsByPersons = json['review_by_persons'];
    pointGifted = json['point_gifted'];
    joiningDate = json['date_of_joining'];
  }

  Map<String, dynamic> toJson() {
    return {
      'volunteer_type': volunteerType,
      'profile_url': profileUrl,
      'name': name,
      'email': email,
      'about': about,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'country_code': countryCode,
      'personal_phn_no': personalPhnNo,
      'parents_email': parentEmail,
      'relationship_with_parent': relationshipWithParent,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'school_name': schoolName,
      'grade_level': gradeLevel,
      'user_type': userType,
      'area_of_interests': areaOfInterests,
      'current_year_target_hours': currentYearTargetHours,
      'date_of_joining': joiningDate,
      'rating': rating,
      'review_by_persons': reviewsByPersons,
      'point_gifted': pointGifted,
    };
  }

  late int? volunteerType;
  late String? profileUrl;
  late String? name;
  late String? email;
  late String? about;
  late String? dateOfBirth;
  late String? gender;
  late String? countryCode;
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
  late int? currentYearTargetHours;
  late bool? favorite = false;
  late int? pointGifted;
  late double? rating;
  late int? reviewsByPersons;
  late String? joiningDate;
}
