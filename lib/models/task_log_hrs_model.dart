class TaskLogHrsModel {
  TaskLogHrsModel({
    this.hrs,
    this.mins,
    this.comment,
    this.timeStamp,
    this.isApprovedFromAdmin,
    this.data,
  });

  TaskLogHrsModel.fromjson({required Map<String, dynamic> json}) {
    hrs = json['hrs'];
    mins = json['mins'];
    timeStamp = json['time_stamp'];
    comment = json['comment'];
    isApprovedFromAdmin = json['is_approve_from_admin'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    return {
      'hrs': hrs,
      'mins': mins,
      'time_stamp': timeStamp,
      'comment': comment,
      'is_approve_from_admin': isApprovedFromAdmin,
      'data': data,
    };
  }

  late int? hrs;
  late int? mins;
  late String? comment;
  late int? timeStamp;
  late bool? isApprovedFromAdmin;
  late Map<String, dynamic>? data;
}
