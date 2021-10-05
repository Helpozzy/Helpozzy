import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/reset_pass_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ResetPasswordDialog {
  void show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: SCREEN_BACKGROUND,
            child: ResetPassword(),
          );
        });
  }
}

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final ResetPasswordBloc _resetPasswordBloc = ResetPasswordBloc();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopInfoLabel(label: RESET_PASSWORD),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.12),
            child: Text(
              RESER_PASS_MSG,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 14,
                    color: DARK_GRAY,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 5),
            child: CommonRoundedTextfield(
              controller: _emailController,
              hintText: ENTER_EMAIL_HINT,
              validator: (email) {
                if (email!.isEmpty) {
                  return 'Please enter email';
                } else if (email.isNotEmpty &&
                    !EmailValidator.validate(email)) {
                  return 'Please enter valid email';
                } else {
                  return null;
                }
              },
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              margin: buildEdgeInsetsCustom(width, 0.15, 20.0, 0.15, 20.0),
              width: double.infinity,
              child: CommonButton(
                text: SEND_MAIL_BUTTON,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    CircularLoader().show(context);
                    _resetPasswordBloc
                        .sentResetPassLink(_emailController.text)
                        .then((result) async {
                      CircularLoader().hide(context);
                      Navigator.of(context).pop();
                      await showSnakeBar(
                        context,
                        msg: result
                            ? 'Mail sent successfully\nPlease check your E-mail!'
                            : 'Delivery failed!',
                      );
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
