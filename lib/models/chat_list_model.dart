class ChatListItem {
  String badge;
  String profileUrl;
  String name;
  int type;
  String email;
  String content;
  String timestamp;
  String id;

  ChatListItem(
      {required this.badge,
      required this.name,
      required this.profileUrl,
      required this.type,
      required this.email,
      required this.content,
      required this.id,
      required this.timestamp});

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      badge: json['badge'] ?? '',
      name: json['name'] ?? '',
      profileUrl: json['profile_image'] ?? '',
      type: json['type'] ?? 0,
      email: json['email'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
      id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'type': type,
      'timestamp': timestamp,
      'content': content,
      'badge': badge,
      'profile_image': profileUrl,
    };
  }
}
