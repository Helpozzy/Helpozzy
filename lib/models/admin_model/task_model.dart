class Tasks {
  Tasks.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      tasks.add(TaskModel.fromjson(json: element));
    });
  }

  late List<TaskModel> tasks = [];
}

class TaskModel {
  TaskModel({
    required this.projectId,
    required this.id,
    required this.taskName,
    required this.description,
    required this.memberRequirement,
    required this.ageRestriction,
    required this.qualification,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.members,
    required this.status,
    this.isSelected,
  });

  TaskModel.fromjson({required Map<String, dynamic> json}) {
    projectId = json['project_id'];
    id = json['task_id'];
    taskName = json['task_name'];
    description = json['description'];
    memberRequirement = json['member_requirement'];
    ageRestriction = json['age_restriction'];
    qualification = json['qualification'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    members = json['members'];
    status = json['status'];
  }

  Map<String, Object?> toJson() {
    return {
      'project_id': projectId,
      'task_id': id,
      'task_name': taskName,
      'description': description,
      'member_requirement': memberRequirement,
      'age_restriction': ageRestriction,
      'qualification': qualification,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'members': members,
      'status': status,
    };
  }

  late String projectId;
  late String id;
  late String taskName;
  late String description;
  late String memberRequirement;
  late String ageRestriction;
  late String qualification;
  late String startDate;
  late String endDate;
  late String startTime;
  late String endTime;
  late String members;
  late String status;
  late bool? isSelected = false;
}
