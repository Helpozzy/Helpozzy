class Reviews {
  Reviews({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      reviews.add(ReviewModel.fromjson(json: element));
    });
  }
  late List<ReviewModel> reviews = [];
}

class ReviewModel {
  ReviewModel.fromjson({required Map<String, dynamic> json}) {
    imageUrl = json['image_url'];
    name = json['name'];
    address = json['address'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    dateTime = json['date_time'];
    reviewText = json['review_text'];
  }
  late String imageUrl;
  late String name;
  late String address;
  late double rating;
  late String dateTime;
  late String reviewText;
}
