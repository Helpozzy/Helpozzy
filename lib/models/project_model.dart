class Projects {
  Projects.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      projectList.add(ProjectModel.fromjson(json: element));
    });
  }

  late List<ProjectModel> projectList = [];
}

class ProjectModel {
  ProjectModel({
    required this.projectId,
    required this.categoryId,
    required this.projectName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectOwner,
    required this.collaboratorsCoadmin,
    required this.imageUrl,
    required this.contactName,
    required this.contactNumber,
    required this.organization,
    required this.location,
    required this.reviewCount,
    required this.enrollmentCount,
    required this.rating,
    required this.aboutOrganizer,
    required this.status,
  });

  ProjectModel.fromjson({required Map<String, dynamic> json}) {
    projectId = json['project_id'];
    categoryId = json['category_id'];
    projectName = json['project_name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    projectOwner = json['project_owner'];
    collaboratorsCoadmin = json['collaborators_or_co_admin'];
    imageUrl = json['image_url'];
    organization = json['oraganization'];
    location = json['location'];
    contactName = json['contact_person_name'];
    contactNumber = json['contact_number'];
    reviewCount = json['review_count'];
    enrollmentCount = json['enrollment_count'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    aboutOrganizer = json['about_organizer'];
    status = json['status'];
  }

  Map<String, Object?> toJson() {
    return {
      'project_id': projectId,
      'category_id': categoryId,
      'project_name': projectName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'project_owner': projectOwner,
      'collaborators_or_co_admin': collaboratorsCoadmin,
      'image_url': imageUrl,
      'oraganization': organization,
      'location': location,
      'contact_person_name': contactName,
      'contact_number': contactNumber,
      'review_count': reviewCount,
      'enrollment_count': enrollmentCount,
      'rating': rating,
      'about_organizer': aboutOrganizer,
      'status': status,
    };
  }

  late String projectId;
  late int categoryId;
  late String projectName;
  late String description;
  late String startDate;
  late String endDate;
  late String projectOwner;
  late String collaboratorsCoadmin;
  late String imageUrl;
  late String contactName;
  late String contactNumber;
  late String organization;
  late String location;
  late int reviewCount;
  late double rating;
  late String aboutOrganizer;
  late String status;
  late int enrollmentCount;
  late bool isLiked = false;
  late bool isProjectDetailsExpanded = false;
  late bool isTaskDetailsExpanded = false;
}
