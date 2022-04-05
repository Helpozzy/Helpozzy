class TaskLogHrsModel {
  TaskLogHrsModel({
    this.hrs,
    this.comment,
    this.timeStamp,
    this.isApprovedFromAdmin,
    this.data,
  });

  TaskLogHrsModel.fromjson({required Map<String, dynamic> json}) {
    hrs = json['hrs'];
    timeStamp = json['time_stamp'];
    comment = json['comment'];
    isApprovedFromAdmin = json['is_approve_from_admin'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    return {
      'hrs': hrs,
      'time_stamp': timeStamp,
      'comment': comment,
      'is_approve_from_admin': isApprovedFromAdmin,
      'data': data,
    };
  }

  late int? hrs;
  late String? comment;
  late int? timeStamp;
  late bool? isApprovedFromAdmin;
  late Map<String, dynamic>? data;
}
