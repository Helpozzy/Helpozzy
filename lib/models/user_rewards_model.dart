class Volunteers {
  Volunteers({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      peoples.add(PeopleModel.fromjson(json: element));
    });
  }
  late List<PeopleModel> peoples = [];
}

class PeopleModel {
  PeopleModel.fromjson({required Map<String, dynamic> json}) {
    imageUrl = json['image_url'];
    name = json['user_name'];
    address = json['address'];
    mail = json['mail'];
    favorite = json['fav'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    reviewsByPersons = json['review_by_persons'];
    pointGifted = json['point_gifted'];
  }

  late String imageUrl;
  late String name;
  late String mail;
  late String address;
  late bool favorite;
  late int pointGifted;
  late double rating;
  late int reviewsByPersons;
}
