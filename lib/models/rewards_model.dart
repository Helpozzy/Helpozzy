class Rewards {
  Rewards.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      keys.addAll(json.keys.toList());
      for (int i = 0; i < keys.length; i++) {
        if (json[keys[i]] != null) {
          rewardTypes.add(RewardsDetailsModel.fromJson(json[keys[i]]));
        }
      }
    }
  }

  late List<String> keys = <String>[];
  late List<RewardsDetailsModel> rewardTypes = [];
}

class RewardsDetailsModel {
  RewardsDetailsModel.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    if (json['points'] != null) {
      for (int i = 0; i < json['points'].length; i++) {
        points.add(PointsModel.fromJson(json['points'][i]));
      }
    }
  }

  late String asset;
  late List<PointsModel> points = [];
}

class PointsModel {
  PointsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    rating = json['rating'];
    points = json['points'];
    to = json['to'];
    from = json['from'];
  }
  late String? title;
  late int rating;
  late int points;
  late int to;
  late int from;
}
