import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/user_model.dart';

class EditProfileBloc {
  final repo = Repository();

  Future<bool> editProfile(SignUpAndUserModel signupAndUserModel) async {
    final bool response =
        await repo.postEditProfileDetailsRepo(signupAndUserModel.toJson());
    return response;
  }
}
