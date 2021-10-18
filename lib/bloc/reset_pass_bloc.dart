import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordBloc {
  final auth = AuthRepository();

  final resetPassLinkController = PublishSubject<bool>();

  Stream<bool> get sentResetPassStream => resetPassLinkController.stream;

  Future<bool> sentResetPassLink(String email) async {
    final bool response = await auth.sentResetPassLink(email);
    return response;
  }

  void dispose() {
    resetPassLinkController.close();
  }
}
