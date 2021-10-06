class Projects {
  Projects.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      projects.add(ProjectModel.fromjson(json: element));
    });
  }

  late List<ProjectModel> projects = [];
}

class ProjectModel {
  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectOwner,
    required this.collaboratorsCoadmin,
    required this.members,
  });

  ProjectModel.fromjson({required Map<String, dynamic> json}) {
    projectId = json['project_id'];
    projectName = json['project_name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    projectOwner = json['project_owner'];
    collaboratorsCoadmin = json['collaborators_or_co_admin'];
    members = json['members'];
  }

  Map<String, Object?> toJson() {
    return {
      'project_id': projectId,
      'project_name': projectName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'project_owner': projectOwner,
      'collaborators_or_co_admin': collaboratorsCoadmin,
      'members': members,
    };
  }

  late String projectId;
  late String projectName;
  late String description;
  late String startDate;
  late String endDate;
  late String projectOwner;
  late String collaboratorsCoadmin;
  late String members;
}
