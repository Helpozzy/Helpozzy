class ChatListItem {
  String idTo;
  String idFrom;
  int type;
  String content;
  String timestamp;

  ChatListItem({
    required this.idTo,
    required this.idFrom,
    required this.type,
    required this.content,
    required this.timestamp,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      idTo: json['id_to'],
      idFrom: json['id_from'],
      type: json['type'] ?? 0,
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_to': idTo,
      'id_from': idFrom,
      'type': type,
      'timestamp': timestamp,
      'content': content,
    };
  }
}
