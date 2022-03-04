import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  Notifications.fromSnapshot(
      {required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final notification = element.data() as Map<String, dynamic>;
      notifications.add(NotificationModel.fromjson(json: notification));
    });
  }
  late List<NotificationModel> notifications = [];
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.userFrom,
    this.userTo,
    this.type,
    this.title,
    this.subTitle,
    this.payload,
    this.timeStamp,
    this.isUpdated = false,
  });

  NotificationModel.fromjson({required Map<String, dynamic> json}) {
    id = json['id'];
    userFrom = json['user_from'];
    userTo = json['user_to'];
    type = json['type'];
    title = json['title'];
    subTitle = json['sub_title'];
    payload = json['payload'];
    timeStamp = json['time_stamp'];
    isUpdated = json['is_updated'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_from': userFrom,
      'user_to': userTo,
      'type': type,
      'title': title,
      'sub_title': subTitle,
      'payload': payload,
      'time_stamp': timeStamp,
      'is_updated': isUpdated,
    };
  }

  late String? id;
  late String? userFrom;
  late String? userTo;
  late int? type;
  late String? title;
  late String? subTitle;
  late Map<String, dynamic>? payload;
  late String? timeStamp;
  late bool? isUpdated;
}
