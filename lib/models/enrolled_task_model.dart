class EnrolledTasks {
  EnrolledTasks.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      enrolledTasks.add(EnrolledTaskModel.fromjson(json: element));
    });
  }

  late List<EnrolledTaskModel> enrolledTasks = [];
}

class EnrolledTaskModel {
  EnrolledTaskModel({
    required this.id,
    required this.projectId,
    required this.ownerId,
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.memberRequirement,
    required this.ageRestriction,
    required this.qualification,
    required this.startDate,
    required this.endDate,
    required this.estimatedHrs,
    required this.totalVolunteerHrs,
    required this.status,
  });

  EnrolledTaskModel.fromjson({required Map<String, dynamic> json}) {
    id = json['id'];
    projectId = json['project_id'];
    ownerId = json['owner_id'];
    taskId = json['task_id'];
    taskName = json['task_name'];
    description = json['description'];
    memberRequirement = json['member_requirement'];
    ageRestriction = json['age_restriction'];
    qualification = json['qualification'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    estimatedHrs = json['estimated_hrs'];
    totalVolunteerHrs = json['total_volunteer_hours'];
    status = json['status'];
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'owner_id': ownerId,
      'task_id': taskId,
      'task_name': taskName,
      'description': description,
      'member_requirement': memberRequirement,
      'age_restriction': ageRestriction,
      'qualification': qualification,
      'start_date': startDate,
      'end_date': endDate,
      'estimated_hrs': estimatedHrs,
      'total_volunteer_hours': totalVolunteerHrs,
      'status': status,
    };
  }

  late String id;
  late String projectId;
  late String ownerId;
  late String taskId;
  late String taskName;
  late String description;
  late int memberRequirement;
  late int ageRestriction;
  late String qualification;
  late String startDate;
  late String endDate;
  late int estimatedHrs;
  late int totalVolunteerHrs;
  late String status;
}
