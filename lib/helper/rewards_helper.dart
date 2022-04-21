import 'package:helpozzy/models/sign_up_user_model.dart';

class UserRewardsDetailsHelper {
  UserRewardsDetailsHelper.fromUsers(Users users) {
    users.peoples.forEach((user) {
      totalPoint += user.pointGifted ?? 0;
    });
  }
  late int totalPoint = 0;
}
