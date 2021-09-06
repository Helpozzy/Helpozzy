class UserRewards {
  UserRewards({required List<Map<String, dynamic>> list}) {
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
    mail = json['mail'];
    favorite = json['fav'];
    pointGifted = json['point_gifted'];
  }
  late String imageUrl;
  late String name;
  late String mail;
  late bool favorite;
  late int pointGifted;
}
