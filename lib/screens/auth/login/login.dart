import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_bloc.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_event.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_state.dart';
import 'package:helpozzy/screens/auth/reset_pass/reset_pass.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

final GlobalKey<State> _dialogKey = GlobalKey<State>();

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SCREEN_BACKGROUND,
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => LoginBloc(
              loginBloc: context.read<LoginBloc>(),
              authRepository: AuthRepository()),
          child: LoginPage(),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (_dialogKey.currentContext != null) {
          Navigator.pop(_dialogKey.currentContext!);
        } else if (state is LoginInitial) {
        } else if (state is LoginLoading) {
        } else if (state is LoginSucceed) {
          CircularLoader().hide(context);
          showSnakeBar(context, msg: LOGIN_SUCEED_POPUP_MSG);
          if (state.loginResponse.type == LOGIN_ADMIN) {
            Navigator.pushNamedAndRemoveUntil(
                context, ADMIN_SELECTION, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, HOME_SCREEN, (route) => false);
          }
        } else if (state is LoginFailed) {
          CircularLoader().hide(context);
          showSnakeBar(context, msg: state.loginResponse.error!.split('] ')[1]);
        }
      },
      child: GestureDetector(
        onPanDown: (_) {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: height * 0.15, bottom: height * 0.10),
              child: TopAppLogo(height: height / 6),
            ),
            LoginInput(),
          ],
        ),
      ),
    );
  }
}

class LoginInput extends StatefulWidget {
  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _modeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonRoundedTextfield(
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
                    SizedBox(height: 15),
                    CommonRoundedTextfield(
                      controller: _passController,
                      obscureText: true,
                      hintText: ENTER_PASSWORD_HINT,
                      validator: (password) {
                        if (password!.isEmpty) {
                          return 'Please enter password';
                        } else if (password.isNotEmpty && password.length < 8) {
                          return 'Password must be at least 8 characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    selectloginTypeDropdown(),
                  ],
                ),
              ),
              Container(
                margin: buildEdgeInsetsCustom(width, 0.20, 20.0, 0.20, 15.0),
                width: double.infinity,
                child: CommonButton(
                  text: MSG_LOGIN.toUpperCase(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      CircularLoader().show(context);
                      context
                          .read<LoginBloc>()
                          .add(LoginEmailChanged(_emailController.text));
                      context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(_passController.text));
                      context
                          .read<LoginBloc>()
                          .add(LoginTypeChanged(_modeController.text));
                      context.read<LoginBloc>().add(const LoginSubmitted());
                    }
                  },
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: MSG_FORGOT_PASSWORD,
                      style: _theme.textTheme.bodyText2!
                          .copyWith(fontSize: 16, color: DARK_GRAY),
                    ),
                    TextSpan(
                      text: MSG_RESET_IT,
                      style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w700),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => ResetPasswordDialog().show(context),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: MSG_NEW_USER,
                      style: _theme.textTheme.bodyText2!
                          .copyWith(fontSize: 16, color: DARK_GRAY),
                    ),
                    TextSpan(
                      text: MSG_SIGN_UP,
                      style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w700),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, USER_SLECTION),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget selectloginTypeDropdown() {
    return DropdownButtonFormField<String>(
        decoration:
            inputRoundedDecoration(getHint: SELECT_TYPE_HINT, isDropDown: true),
        icon: Icon(Icons.expand_more_outlined),
        isExpanded: true,
        validator: (val) {
          if (_modeController.text.isEmpty) {
            return 'Choose user wnat to login';
          }
          return null;
        },
        onChanged: (String? newValue) {
          setState(() {
            _modeController.text = newValue!;
          });
        },
        items: loginModes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList());
  }
}
