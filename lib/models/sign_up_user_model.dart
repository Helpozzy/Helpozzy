import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';

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
    this.userId,
    this.volunteerType,
    this.profileUrl,
    this.firstName,
    this.lastName,
    this.email,
    this.about,
    this.dateOfBirth,
    this.gender,
    this.countryCode,
    this.personalPhnNo,
    this.parentEmail,
    this.relationshipWithParent,
    this.address,
    this.schoolName,
    this.gradeLevel,
    this.areaOfInterests,
    this.currentYearTargetHours,
    this.favorite,
    this.pointGifted,
    this.totalSpentHrs,
    this.rating,
    this.reviewsByPersons,
    this.joiningDate,
    this.isOrganization,
    this.organizationDetails,
    this.lastSeen,
    this.presence,
    this.isSelected,
    // this.biometricEnable,
  });

  SignUpAndUserModel.fromJson({required Map<String, dynamic> json}) {
    userId = json['user_id'];
    volunteerType = json['volunteer_type'];
    profileUrl = json['profile_url'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    about = json['about'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    countryCode = json['country_code'];
    personalPhnNo = json['personal_phn_no'];
    parentEmail = json['parents_email'];
    relationshipWithParent = json['relationship_with_parent'];
    address = json['address'];
    schoolName = json['school_name'];
    gradeLevel = json['grade_level'];
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
        : double.parse(
            json['rating'] != null ? json['rating'].toString() : '0',
          );
    reviewsByPersons = json['review_by_persons'];
    pointGifted = json['point_gifted'];
    totalSpentHrs = json['total_spent_hrs'];
    joiningDate = json['date_of_joining'];
    isOrganization = json['is_organization'];
    organizationDetails = json['organization_details'] != null
        ? OrganizationSignUpModel.fromJson(json: json['organization_details'])
        : json['organization_details'];
    presence = json['presence'];
    lastSeen = json['last_seen'];
    // biometricEnable = json['biometric_enable'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'volunteer_type': volunteerType,
      'profile_url': profileUrl,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'about': about,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'country_code': countryCode,
      'personal_phn_no': personalPhnNo,
      'parents_email': parentEmail,
      'relationship_with_parent': relationshipWithParent,
      'address': address,
      'school_name': schoolName,
      'grade_level': gradeLevel,
      'area_of_interests': areaOfInterests,
      'current_year_target_hours': currentYearTargetHours,
      'date_of_joining': joiningDate,
      'rating': rating,
      'review_by_persons': reviewsByPersons,
      'total_spent_hrs': totalSpentHrs,
      'point_gifted': pointGifted,
      'is_organization': isOrganization,
      'organization_details': organizationDetails != null
          ? organizationDetails!.toJson()
          : organizationDetails,
      'last_seen': lastSeen,
      'presence': presence,
      // 'biometric_enable': biometricEnable,
    };
  }

  late String? userId;
  late int? volunteerType;
  late String? profileUrl;
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? about;
  late String? dateOfBirth;
  late String? gender;
  late String? countryCode;
  late String? personalPhnNo;
  late String? parentEmail;
  late String? relationshipWithParent;
  late String? address;
  late String? schoolName;
  late String? gradeLevel;
  late List<int>? areaOfInterests = [];
  late int? currentYearTargetHours;
  late bool? favorite = false;
  late int? totalSpentHrs;
  late int? pointGifted;
  late double? rating;
  late int? reviewsByPersons;
  late String? joiningDate;
  late OrganizationSignUpModel? organizationDetails;
  late bool? isOrganization = false;
  late String? lastSeen;
  late bool? presence = false;
  late bool? isSelected = false;
  // late bool? biometricEnable = false;
}
