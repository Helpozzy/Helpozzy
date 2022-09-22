import 'package:cloud_firestore/cloud_firestore.dart';

class Projects {
  Projects.fromJson({required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final project = element.data() as Map<String, dynamic>;
      projectList.add(ProjectModel.fromjson(json: project));
    });
    projectList.sort((a, b) => a.projectName!.compareTo(b.projectName!));
  }
  late List<ProjectModel> projectList = [];
}

class ProjectModel {
  ProjectModel({
    this.enrolledId,
    this.projectId,
    this.ownerId,
    this.signedUpDate,
    this.signUpUserId,
    this.categoryId,
    this.projectName,
    this.description,
    this.startDate,
    this.endDate,
    this.collaboratorsCoadmin,
    this.imageUrl,
    this.contactName,
    this.contactNumber,
    this.organization,
    this.location,
    this.projectLocationLati,
    this.projectLocationLongi,
    this.enrollmentCount,
    this.isPrivate,
    this.aboutOrganizer,
    this.status,
    this.isApprovedFromAdmin,
    this.isSignedUp,
    this.totalTaskshrs,
  });

  ProjectModel.fromjson({required Map<String, dynamic> json}) {
    enrolledId = json['enrolled_id'];
    projectId = json['project_id'];
    signUpUserId = json['signup_uid'];
    signedUpDate = json['signup_date'];
    ownerId = json['owner_id'];
    categoryId = json['category_id'];
    projectName = json['project_name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isPrivate = json['is_private'] ?? false;
    collaboratorsCoadmin = json['collaborators_or_co_admin'] != null
        ? json['collaborators_or_co_admin']
        : [];
    imageUrl = json['image_url'];
    organization = json['oraganization'];
    location = json['location'];
    projectLocationLati = json['location_latitude'];
    projectLocationLongi = json['location_longitude'];
    contactName = json['contact_person_name'];
    contactNumber = json['contact_number'];
    enrollmentCount = json['enrollment_count'];
    aboutOrganizer = json['about_organizer'];
    status = json['status'];
    isApprovedFromAdmin = json['is_approved_from_admin'];
    totalTaskshrs = json['total_tasks_hrs'];
  }

  Map<String, Object?> toJson() {
    return {
      'enrolled_id': enrolledId,
      'project_id': projectId,
      'signup_uid': signUpUserId,
      'signup_date': signedUpDate,
      'owner_id': ownerId,
      'category_id': categoryId,
      'project_name': projectName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'is_private': isPrivate ?? false,
      'collaborators_or_co_admin': collaboratorsCoadmin,
      'image_url': imageUrl,
      'oraganization': organization,
      'location': location,
      'location_latitude': projectLocationLati,
      'location_longitude': projectLocationLongi,
      'contact_person_name': contactName,
      'contact_number': contactNumber,
      'enrollment_count': enrollmentCount,
      'about_organizer': aboutOrganizer,
      'status': status,
      'is_approved_from_admin': isApprovedFromAdmin,
      'total_tasks_hrs': totalTaskshrs,
    };
  }

  late String? enrolledId;
  late String? projectId;
  late String? signUpUserId;
  late String? signedUpDate;
  late String? ownerId;
  late int? categoryId;
  late String? projectName;
  late String? description;
  late String? startDate;
  late String? endDate;
  late List? collaboratorsCoadmin = [];
  late bool? isPrivate;
  late String? imageUrl;
  late String? contactName;
  late String? contactNumber;
  late String? organization;
  late String? location;
  late double? projectLocationLati;
  late double? projectLocationLongi;
  late String? aboutOrganizer;
  late String? status;
  late int? enrollmentCount;
  late bool? isApprovedFromAdmin;
  late int? totalTaskshrs = 0;
  late bool? isDetailsExpanded = false;
  late bool? isSignedUp = false;
  late bool? isTaskDetailsExpanded = false;
}
