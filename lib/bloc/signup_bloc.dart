import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final repo = Repository();
  final auth = AuthRepository();

  final signUpController = PublishSubject<bool>();

  Stream<bool> get signUpDetailsStream => signUpController.stream;

  Future<bool> registerUser(
      SignUpAndUserModel signUpModel, String password) async {
    final User? result = await auth.signUp(signUpModel.email!, password);

    final bool response =
        await repo.postSignUpDetailsRepo(result!.uid, signUpModel.toJson());

    return response;
  }

  void dispose() {
    signUpController.close();
  }
}
