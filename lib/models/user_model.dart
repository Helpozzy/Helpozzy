import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users.fromJson({required List<QueryDocumentSnapshot> list}) {
    list.forEach((element) {
      final userJson = element.data() as Map<String, dynamic>;
      peoples.add(UserModel.fromjson(json: userJson));
    });
  }
  late List<UserModel> peoples = [];
}

class UserModel {
  UserModel.fromjson({required Map<String, dynamic> json}) {
    uId = json['user_id'];
    address = json['address'];
    city = json['city'];
    dateOfBirth = json['date_of_birth'];
    joiningDate = json['date_of_joining'];
    email = json['email'];
    about = json['about'];
    gradeLevel = json['grade_level'];
    name = json['name'];
    parentPhnNo = json['parent_phn_no'];
    personalPhnNo = json['personal_phn_no'];
    relationshipWithParent = json['relationship_with_parent'];
    schoolName = json['school_name'];
    state = json['state'];
    volunteerType = json['volunteer_type'];
    zipCode = json['zip_code'];
    rofileUrl = json['profile_url'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    reviewsByPersons = json['review_by_persons'];
    pointGifted = json['point_gifted'];
  }

  late String uId;
  late String name;
  late String email;
  late String about;
  late String address;
  late String city;
  late String state;
  late String zipCode;
  late String dateOfBirth;
  late String joiningDate;
  late String gradeLevel;
  late String parentPhnNo;
  late String personalPhnNo;
  late String relationshipWithParent;
  late String schoolName;
  late int volunteerType;
  late String rofileUrl;
  late bool favorite = false;
  late int pointGifted;
  late double rating;
  late int reviewsByPersons;
}
