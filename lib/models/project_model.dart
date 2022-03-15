import 'package:cloud_firestore/cloud_firestore.dart';

class Projects {
  Projects.fromJson(
      {List<QueryDocumentSnapshot<Object?>>? signedUpList,
      required List<QueryDocumentSnapshot<Object?>> list}) {
    // list.forEach((element) {
    //   final project = element.data() as Map<String, dynamic>;
    //   projectList.add(ProjectModel.fromjson(json: project));
    // });

    list.forEach((dbProject) {
      final project = dbProject.data() as Map<String, dynamic>;
      if (signedUpList != null && signedUpList.isNotEmpty) {
        signedUpList.forEach((dbSignedUpProject) {
          final signedUpProject =
              dbSignedUpProject.data() as Map<String, dynamic>;
          if (project['project_id'] == signedUpProject['project_id']) {
            projectList.add(
              ProjectModel(
                enrolledId: project['enrolled_id'],
                projectId: project['project_id'],
                signUpUserId: project['signup_uid'],
                ownerId: project['owner_id'],
                categoryId: project['category_id'],
                projectName: project['project_name'],
                description: project['description'],
                startDate: project['start_date'],
                endDate: project['end_date'],
                collaboratorsCoadmin: project['collaborators_or_co_admin'],
                imageUrl: project['image_url'],
                organization: project['oraganization'],
                location: project['location'],
                projectLocationLati: project['location_latitude'],
                projectLocationLongi: project['location_longitude'],
                contactName: project['contact_person_name'],
                contactNumber: project['contact_number'],
                reviewCount: project['review_count'],
                enrollmentCount: project['enrollment_count'],
                rating: project['rating'] is double
                    ? project['rating']
                    : double.parse(project['rating'].toString()),
                aboutOrganizer: project['about_organizer'],
                status: project['status'],
                isApprovedFromAdmin: project['is_approved_from_admin'],
                isSignedUp: true,
              ),
            );
          } else {
            projectList.add(
              ProjectModel(
                enrolledId: project['enrolled_id'],
                projectId: project['project_id'],
                signUpUserId: project['signup_uid'],
                ownerId: project['owner_id'],
                categoryId: project['category_id'],
                projectName: project['project_name'],
                description: project['description'],
                startDate: project['start_date'],
                endDate: project['end_date'],
                collaboratorsCoadmin: project['collaborators_or_co_admin'],
                imageUrl: project['image_url'],
                organization: project['oraganization'],
                location: project['location'],
                projectLocationLati: project['location_latitude'],
                projectLocationLongi: project['location_longitude'],
                contactName: project['contact_person_name'],
                contactNumber: project['contact_number'],
                reviewCount: project['review_count'],
                enrollmentCount: project['enrollment_count'],
                rating: project['rating'] is double
                    ? project['rating']
                    : double.parse(project['rating'].toString()),
                aboutOrganizer: project['about_organizer'],
                status: project['status'],
                isApprovedFromAdmin: project['is_approved_from_admin'],
                isSignedUp: false,
              ),
            );
          }
        });
      } else {
        projectList.add(
          ProjectModel(
            enrolledId: project['enrolled_id'],
            projectId: project['project_id'],
            signUpUserId: project['signup_uid'],
            ownerId: project['owner_id'],
            categoryId: project['category_id'],
            projectName: project['project_name'],
            description: project['description'],
            startDate: project['start_date'],
            endDate: project['end_date'],
            collaboratorsCoadmin: project['collaborators_or_co_admin'],
            imageUrl: project['image_url'],
            organization: project['oraganization'],
            location: project['location'],
            projectLocationLati: project['location_latitude'],
            projectLocationLongi: project['location_longitude'],
            contactName: project['contact_person_name'],
            contactNumber: project['contact_number'],
            reviewCount: project['review_count'],
            enrollmentCount: project['enrollment_count'],
            rating: project['rating'] is double
                ? project['rating']
                : double.parse(project['rating'].toString()),
            aboutOrganizer: project['about_organizer'],
            status: project['status'],
            isApprovedFromAdmin: project['is_approved_from_admin'],
            isSignedUp: false,
          ),
        );
      }
    });
  }

  late List<ProjectModel> projectList = [];
}

class ProjectModel {
  ProjectModel({
    this.enrolledId,
    this.projectId,
    this.ownerId,
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
    this.reviewCount,
    this.enrollmentCount,
    this.rating,
    this.aboutOrganizer,
    this.status,
    this.isApprovedFromAdmin = false,
    this.isSignedUp = false,
  });

  ProjectModel.fromjson({required Map<String, dynamic> json}) {
    enrolledId = json['enrolled_id'];
    projectId = json['project_id'];
    signUpUserId = json['signup_uid'];
    ownerId = json['owner_id'];
    categoryId = json['category_id'];
    projectName = json['project_name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    collaboratorsCoadmin = json['collaborators_or_co_admin'];
    imageUrl = json['image_url'];
    organization = json['oraganization'];
    location = json['location'];
    projectLocationLati = json['location_latitude'];
    projectLocationLongi = json['location_longitude'];
    contactName = json['contact_person_name'];
    contactNumber = json['contact_number'];
    reviewCount = json['review_count'];
    enrollmentCount = json['enrollment_count'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    aboutOrganizer = json['about_organizer'];
    status = json['status'];
    isApprovedFromAdmin = json['is_approved_from_admin'];
  }

  Map<String, Object?> toJson() {
    return {
      'enrolled_id': enrolledId,
      'project_id': projectId,
      'signup_uid': signUpUserId,
      'owner_id': ownerId,
      'category_id': categoryId,
      'project_name': projectName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'collaborators_or_co_admin': collaboratorsCoadmin,
      'image_url': imageUrl,
      'oraganization': organization,
      'location': location,
      'location_latitude': projectLocationLati,
      'location_longitude': projectLocationLongi,
      'contact_person_name': contactName,
      'contact_number': contactNumber,
      'review_count': reviewCount,
      'enrollment_count': enrollmentCount,
      'rating': rating,
      'about_organizer': aboutOrganizer,
      'status': status,
      'is_approved_from_admin': isApprovedFromAdmin,
    };
  }

  late String? enrolledId;
  late String? projectId;
  late String? signUpUserId;
  late String? ownerId;
  late int? categoryId;
  late String? projectName;
  late String? description;
  late String? startDate;
  late String? endDate;
  late String? collaboratorsCoadmin;
  late String? imageUrl;
  late String? contactName;
  late String? contactNumber;
  late String? organization;
  late String? location;
  late double? projectLocationLati;
  late double? projectLocationLongi;
  late int? reviewCount;
  late double? rating;
  late String? aboutOrganizer;
  late String? status;
  late int? enrollmentCount;
  late bool? isApprovedFromAdmin;
  late bool? isLiked = false;
  late bool? isProjectDetailsExpanded = false;
  late bool? isSignedUp = false;
  late bool? isTaskDetailsExpanded = false;
}
