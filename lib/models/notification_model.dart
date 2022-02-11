class Notifications {
  Notifications.fromSnapshot({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      notifications.add(NotificationModel.fromjson(json: element));
    });
  }
  late List<NotificationModel> notifications = [];
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.type,
    this.title,
    this.subTitle,
    this.payload,
    this.timeStamp,
  });

  NotificationModel.fromjson({required Map<String, dynamic> json}) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    subTitle = json['sub_title'];
    payload = json['payload'];
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'sub_title': subTitle,
      'payload': payload,
      'time_stamp': timeStamp,
    };
  }

  late String? id;
  late int? type;
  late String? title;
  late String? subTitle;
  late dynamic payload;
  late String? timeStamp;
}
