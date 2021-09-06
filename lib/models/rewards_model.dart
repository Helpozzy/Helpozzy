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
    rating = json['rating'];
    points = json['points'];
    hrs = json['hrs'];
  }

  late int rating;
  late int points;
  late String hrs;
}
