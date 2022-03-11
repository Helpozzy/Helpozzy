import 'dart:convert';

import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class UserInfoBloc {
  final repo = Repository();

  final userController = PublishSubject<SignUpAndUserModel>();

  Stream<SignUpAndUserModel> get userStream => userController.stream;

  Future<SignUpAndUserModel> getUser(String uId) async {
    final SignUpAndUserModel response = await repo.userInfoRepo(uId);
    prefsObject.setString(CURRENT_USER_PROFILE_URL, response.profileUrl!);
    final String userData = jsonEncode(response.toJson());
    prefsObject.setString(CURRENT_USER_DATA, userData);
    userController.sink.add(response);
    return response;
  }

  void dispose() {
    userController.close();
  }
}
