class TaskLogHrsModel {
  TaskLogHrsModel({
    this.hrs,
    this.comment,
    this.timeStamp,
    this.data,
  });

  TaskLogHrsModel.fromjson({required Map<String, dynamic> json}) {
    hrs = json['hrs'];
    timeStamp = json['time_stamp'];
    comment = json['comment'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    return {
      'hrs': hrs,
      'time_stamp': timeStamp,
      'comment': comment,
      'data': data,
    };
  }

  late int? hrs;
  late String? comment;
  late int? timeStamp;
  late Map<String, dynamic>? data;
}
