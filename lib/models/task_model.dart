import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks {
  Tasks.fromJson({required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final task = element.data() as Map<String, dynamic>;
      tasks.add(TaskModel.fromjson(json: task));
    });
  }

  late List<TaskModel> tasks = [];
}

class TaskModel {
  TaskModel({
    this.enrollTaskId,
    this.projectId,
    this.taskOwnerId,
    this.signUpUserId,
    this.taskId,
    this.taskName,
    this.description,
    this.memberRequirement,
    this.ageRestriction,
    this.qualification,
    this.startDate,
    this.endDate,
    this.estimatedHrs,
    this.totalVolunteerHrs,
    this.members,
    this.status,
    this.isSelected,
    this.isApprovedFromAdmin,
  });

  TaskModel.fromjson({required Map<String, dynamic> json}) {
    enrollTaskId = json['enroll_task_id'];
    projectId = json['project_id'];
    taskOwnerId = json['owner_id'];
    taskId = json['task_id'];
    signUpUserId = json['sign_up_uid'];
    taskName = json['task_name'];
    description = json['description'];
    memberRequirement = json['member_requirement'];
    ageRestriction = json['age_restriction'];
    qualification = json['qualification'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    estimatedHrs = json['estimated_hrs'];
    totalVolunteerHrs = json['total_volunteer_hours'];
    members = json['members'] != null ? json['members'] : [];
    status = json['status'];
    isApprovedFromAdmin = json['is_approved_from_admin'];
  }

  Map<String, Object?> toJson() {
    return {
      'enroll_task_id': enrollTaskId,
      'project_id': projectId,
      'owner_id': taskOwnerId,
      'sign_up_uid': signUpUserId,
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
      'members': members,
      'status': status,
      'is_approved_from_admin': isApprovedFromAdmin,
    };
  }

  late String? enrollTaskId;
  late String? projectId;
  late String? taskOwnerId;
  late String? signUpUserId;
  late String? taskId;
  late String? taskName;
  late String? description;
  late int? memberRequirement;
  late int? ageRestriction;
  late String? qualification;
  late String? startDate;
  late String? endDate;
  late int? estimatedHrs;
  late int? totalVolunteerHrs;
  late List<dynamic>? members = [];
  late String? status;
  late bool? isSelected = false;
  late bool? isApprovedFromAdmin = false;
}
