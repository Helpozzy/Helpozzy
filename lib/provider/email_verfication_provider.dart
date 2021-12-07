import 'package:email_auth/email_auth.dart';

class EmailVerificationProvider {
  EmailAuth emailAuth = EmailAuth(sessionName: "Helpozzy email verification!");

  Future<bool> sendOtp(String email) async {
    final bool result = await emailAuth.sendOtp(recipientMail: email);
    if (result)
      return true;
    else
      return false;
  }

  Future<bool> validateOTP({required String email, required String otp}) async {
    final bool result =
        emailAuth.validateOtp(recipientMail: email, userOtp: otp);
    if (result)
      return true;
    else
      return false;
  }
}
