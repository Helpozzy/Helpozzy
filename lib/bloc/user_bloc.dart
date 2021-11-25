import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class UserInfoBloc {
  final repo = Repository();

  final userController = PublishSubject<SignUpAndUserModel>();

  Stream<SignUpAndUserModel> get userStream => userController.stream;

  Future<SignUpAndUserModel> getUser(String uId) async {
    final SignUpAndUserModel response = await repo.userInfoRepo(uId);
    userController.sink.add(response);
    return response;
  }

  void dispose() {
    userController.close();
  }
}
