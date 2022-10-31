import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc {
  final repo = Repository();

  final PublishSubject<bool> organizationDetailsExpand = PublishSubject<bool>();
  final PublishSubject<bool> parentsOtpSentController = PublishSubject<bool>();
  final PublishSubject<bool> parentsEmailVerifiedController =
      PublishSubject<bool>();

  Stream<bool> get getOrganizationDetailsExpandedStream =>
      organizationDetailsExpand.stream;
  Stream<bool> get parentOtpSentStream => parentsOtpSentController.stream;
  Stream<bool> get parentEmailVerifiedStream =>
      parentsEmailVerifiedController.stream;

  Future organizationDetailsIsExpanded(bool expand) async {
    organizationDetailsExpand.sink.add(expand);
  }

  Future<ResponseModel> editProfile(
      SignUpAndUserModel signupAndUserModel) async {
    final ResponseModel response =
        await repo.postEditProfileDetailsRepo(signupAndUserModel.toJson());
    return response;
  }

  Future<ResponseModel> updateTotalSpentHrs(
      String signUpUserId, int hrs) async {
    final ResponseModel response =
        await repo.updateTotalSpentHrsRepo(signUpUserId, hrs);
    return response;
  }

  // Future sentOtpOfParentEmail(String email) async {
  //   final bool result = await _emailVerificationProvider.sendOtp(email);
  //   parentsOtpSentController.sink.add(result);
  // }

  // Future verifyParentEmail(String email, String otp) async {
  //   final bool result =
  //       await _emailVerificationProvider.validateOTP(email: email, otp: otp);
  //   parentsEmailVerifiedController.sink.add(result);
  // }

  void dispose() {
    organizationDetailsExpand.close();
    parentsOtpSentController.close();
    parentsEmailVerifiedController.close();
  }
}
