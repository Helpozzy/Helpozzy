import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:helpozzy/models/login_response_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final repo = Repository();
  final auth = AuthRepository();

  final PublishSubject<bool> signUpController = PublishSubject<bool>();
  final PublishSubject<bool> otpSentController = PublishSubject<bool>();
  final PublishSubject<bool> emailVerifiedController = PublishSubject<bool>();
  final PublishSubject<bool> showPasswordController = PublishSubject<bool>();
  final PublishSubject<bool> showConfirmPassController = PublishSubject<bool>();
  final PublishSubject<bool> checkTermsConditionController =
      PublishSubject<bool>();

  Stream<bool> get signUpDetailsStream => signUpController.stream;
  Stream<bool> get otpSentStream => otpSentController.stream;
  Stream<bool> get emailVerifiedStream => emailVerifiedController.stream;
  Stream<bool> get showPassStream => showPasswordController.stream;
  Stream<bool> get showConfirmPassStream => showConfirmPassController.stream;
  Stream<bool> get termsConditionStream => checkTermsConditionController.stream;

  Future<ResponseModel> registerUser(
      SignUpAndUserModel signupAndUserModel, String password) async {
    final AuthResponseModel? result =
        await auth.signUp(signupAndUserModel.email!, password);
    try {
      signupAndUserModel.userId = result!.user!.uid;
      prefsObject.setString(CURRENT_USER_ID, signupAndUserModel.userId!);
      final ResponseModel response =
          await repo.postSignUpDetailsRepo(signupAndUserModel);
      return ResponseModel(
        status: response.status,
        message: result.message,
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        error: result!.error,
      );
    }
  }

  Future<AuthResponseModel> signUpTempEmail(
      String email, String password) async {
    return await auth.signUp(email, password);
  }

  Future<ResponseModel> sendEmailToVerify() async {
    final ResponseModel response = await auth.verifyEmail();
    return response;
  }

  Future changeShowPass(bool show) async {
    showPasswordController.sink.add(show);
  }

  Future changeShowConfirmPass(bool show) async {
    showConfirmPassController.sink.add(show);
  }

  Future changeTermsConditionPrivacyPolicy(bool show) async {
    checkTermsConditionController.sink.add(show);
  }

  void dispose() {
    signUpController.close();
    emailVerifiedController.close();
    otpSentController.close();
    showPasswordController.close();
    showConfirmPassController.close();
    checkTermsConditionController.close();
  }
}
