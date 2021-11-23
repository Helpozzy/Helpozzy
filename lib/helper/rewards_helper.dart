import 'package:helpozzy/models/user_model.dart';

class UserRewardsDetailsHelper {
  UserRewardsDetailsHelper.fromUsers(Users users) {
    users.peoples.forEach((user) {
      totalPoint += user.pointGifted!;
    });
  }
  late int totalPoint = 0;
}
