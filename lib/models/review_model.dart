import 'package:cloud_firestore/cloud_firestore.dart';

class Reviews {
  Reviews.fromSnapshot({required List<QueryDocumentSnapshot<Object?>> list}) {
    list.forEach((element) {
      final review = element.data() as Map<String, dynamic>;
      reviews.add(ReviewModel.fromjson(json: review));
    });
  }
  late List<ReviewModel> reviews = [];
}

class ReviewModel {
  ReviewModel({
    this.reviewId,
    this.projectId,
    this.reviewerId,
    this.imageUrl,
    this.name,
    this.address,
    this.rating,
    this.reviewText,
    this.timeStamp,
  });

  ReviewModel.fromjson({required Map<String, dynamic> json}) {
    reviewId = json['review_id'];
    projectId = json['project_id'];
    reviewerId = json['reviewer_id'];
    imageUrl = json['image_url'];
    name = json['name'];
    address = json['address'];
    rating = json['rating'] is double
        ? json['rating']
        : double.parse(json['rating'].toString());
    timeStamp = json['time_stamp'];
    reviewText = json['review_text'];
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'project_id': projectId,
      'reviewer_id': reviewerId,
      'image_url': imageUrl,
      'name': name,
      'address': address,
      'rating': rating,
      'time_stamp': timeStamp,
      'review_text': reviewText,
    };
  }

  late String? reviewId;
  late String? projectId;
  late String? reviewerId;
  late String? imageUrl;
  late String? name;
  late String? address;
  late double? rating;
  late String? timeStamp;
  late String? reviewText;
}
