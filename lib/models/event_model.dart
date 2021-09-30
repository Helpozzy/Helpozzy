class Events {
  Events.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      events.add(EventModel.fromjson(json: element));
    });
  }

  late List<EventModel> events = [];
}

class EventModel {
  EventModel.fromjson({required Map<String, dynamic> json}) {
    categoryId = json['category_id'];
    eventId = json['event_id'];
    imageUrl = json['image_url'];
    dateTime = json['date_time'];
    eventName = json['event_name'];
    organization = json['oraganization'];
    location = json['location'];
    reviewCount = json['review_count'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    isLiked = json['is_liked'];
    aboutOrganizer = json['about_organizer'];
    eventDetails = json['details'];
  }

  late int categoryId;
  late int eventId;
  late String imageUrl;
  late String dateTime;
  late String eventName;
  late String organization;
  late String location;
  late int reviewCount;
  late bool isLiked;
  late double rating;
  late String aboutOrganizer;
  late String eventDetails;
  late bool isExpanded = false;
}
