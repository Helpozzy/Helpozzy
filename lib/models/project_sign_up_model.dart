import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectSignedUpUsers {
  ProjectSignedUpUsers.fromJson({required List<QueryDocumentSnapshot> list}) {
    list.forEach((element) {
      final userJson = element.data() as Map<String, dynamic>;
      peoples.add(ProjectSignUpModel.fromJson(json: userJson));
    });
  }
  late List<ProjectSignUpModel> peoples = [];
}

class ProjectSignUpModel {
  ProjectSignUpModel({
    this.signUpUserId,
    this.projectId,
    this.name,
    this.email,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.personalPhnNo,
    this.isApprovedFromAdmin = false,
  });

  ProjectSignUpModel.fromJson({required Map<String, dynamic> json}) {
    signUpUserId = json['signup_uid'];
    ownerId = json['owner_id'];
    projectId = json['project_id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    personalPhnNo = json['personal_phn_no'];
    isApprovedFromAdmin = json['is_approved_from_admin'];
  }

  Map<String, dynamic> toJson() {
    return {
      'signup_uid': signUpUserId,
      'owner_id': ownerId,
      'project_id': projectId,
      'name': name,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'personal_phn_no': personalPhnNo,
      'is_approved_from_admin': isApprovedFromAdmin,
    };
  }

  late String? signUpUserId;
  late String? ownerId;
  late String? projectId;
  late String? name;
  late String? email;
  late String? address;
  late String? city;
  late String? state;
  late String? zipCode;
  late String? personalPhnNo;
  late bool? isApprovedFromAdmin;
}
