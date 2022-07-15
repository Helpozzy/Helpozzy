import 'package:email_auth/email_auth.dart';
import 'package:helpozzy/utils/constants.dart';

class EmailVerificationProvider {
  final EmailAuth emailAuth = EmailAuth(sessionName: EMAIL_OTP_TEXT);

  Future<bool> sendOtp(String email) async {
    final bool configIsSet = await emailAuth.config({
      "server": "https://email-otp-auth.herokuapp.com",
      "serverKey": "aW0VPV"
    });
    if (configIsSet) {
      final bool result = await emailAuth.sendOtp(recipientMail: email);
      if (result)
        return true;
      else
        return false;
    } else {
      return false;
    }
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
