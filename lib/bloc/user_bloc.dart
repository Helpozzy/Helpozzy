import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class UserInfoBloc {
  final repo = Repository();

  final userController = PublishSubject<UserModel>();

  Stream<UserModel> get userStream => userController.stream;

  Future getUser(String uId) async {
    final UserModel response = await repo.userInfoRepo(uId);
    userController.sink.add(response);
  }

  void dispose() {
    userController.close();
  }
}
