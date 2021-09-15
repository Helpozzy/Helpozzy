import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      peoples.add(UserModel.fromjson(json: element));
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
    email = json['email'];
    gradeLevel = json['grade_level'];
    name = json['name'];
    parentPhnNo = json['parent_phn_no'];
    personalPhnNo = json['personal_phn_no'];
    relationshipWithParent = json['relationship_with_parent'];
    schoolName = json['school_name'];
    state = json['state'];
    volunteerType = json['volunteer_type'];
    zipCode = json['zip_code'];
  }

  late String uId;
  late String address;
  late String city;
  late Timestamp? dateOfBirth;
  late String email;
  late String gradeLevel;
  late String name;
  late String parentPhnNo;
  late String personalPhnNo;
  late String relationshipWithParent;
  late String schoolName;
  late String state;
  late int volunteerType;
  late String zipCode;
}
