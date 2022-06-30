import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  Chats.fromJson({required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final project = element.data() as Map<String, dynamic>;
      messages.add(MessageModel.fromJson(project));
    });
    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
  late List<MessageModel> messages = [];
}

class MessageModel {
  MessageModel({
    required this.content,
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.type,
  });

  String content;
  String idFrom;
  String idTo;
  String timestamp;
  int type;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        content: json["content"],
        idFrom: json["id_from"],
        idTo: json["id_to"] ?? '',
        timestamp: json["timestamp"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "id_from": idFrom,
        "id_to": idTo,
        "timestamp": timestamp,
        "type": type,
      };
}
