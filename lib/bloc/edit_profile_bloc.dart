import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/provider/email_verfication_provider.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc {
  final repo = Repository();
  final EmailVerificationProvider _emailVerificationProvider =
      EmailVerificationProvider();

  final PublishSubject<bool> parentsOtpSentController = PublishSubject<bool>();
  final PublishSubject<bool> parentsEmailVerifiedController =
      PublishSubject<bool>();

  Stream<bool> get parentOtpSentStream => parentsOtpSentController.stream;
  Stream<bool> get parentEmailVerifiedStream =>
      parentsEmailVerifiedController.stream;

  Future<bool> editProfile(SignUpAndUserModel signupAndUserModel) async {
    final bool response =
        await repo.postEditProfileDetailsRepo(signupAndUserModel.toJson());
    return response;
  }

  Future sentOtpOfParentEmail(String email) async {
    final bool result = await _emailVerificationProvider.sendOtp(email);
    parentsOtpSentController.sink.add(result);
  }

  Future verifyParentEmail(String email, String otp) async {
    final bool result =
        await _emailVerificationProvider.validateOTP(email: email, otp: otp);
    parentsEmailVerifiedController.sink.add(result);
  }

  void dispose() {
    parentsOtpSentController.close();
    parentsEmailVerifiedController.close();
  }
}