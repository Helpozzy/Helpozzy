import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpozzy/utils/constants.dart';

class CommonWidget {
  CommonWidget(this.context);
  final BuildContext context;

  Widget showBackButton() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(top: height * 0.05, left: width * 0.05),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: CLOSE_ICON,
          ),
        ),
      ),
    );
  }

  Widget showCloseButton() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(top: height * 0.05, right: width * 0.05),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: CLOSE_ICON,
          ),
        ),
      ),
    );
  }
}

class TopInfoLabel extends StatelessWidget {
  const TopInfoLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: height * 0.05, bottom: height * 0.04),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style:
            _theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CommonRoundedTextfield extends StatelessWidget {
  const CommonRoundedTextfield({
    required this.controller,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.maxLength,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      textAlign: TextAlign.center,
      style: _theme.textTheme.bodyText1,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: inputRoundedDecoration(
        getHint: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}

class TextfieldLabelSmall extends StatelessWidget {
  const TextfieldLabelSmall({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: _theme.textTheme.headline6!
            .copyWith(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  const TextFieldWithLabel({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.onTap,
    this.maxLength,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController controller;
  final String label;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TextInputType keyboardType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        TextfieldLabelSmall(label: label),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: CommonRoundedTextfield(
            controller: controller,
            hintText: hintText,
            validator: validator,
            maxLength: maxLength,
            keyboardType: keyboardType,
            onTap: onTap,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}

class SmallInfoLabel extends StatelessWidget {
  const SmallInfoLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CommonSimpleTextfield extends StatelessWidget {
  const CommonSimpleTextfield({
    required this.controller,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.maxLength,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      style: _theme.textTheme.bodyText1,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: inputSimpleDecoration(
        getHint: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}

class SimpleFieldWithLabel extends StatelessWidget {
  const SimpleFieldWithLabel({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.onTap,
    this.maxLength,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController controller;
  final String label;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TextInputType keyboardType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: width * 0.05),
        SmallInfoLabel(label: label),
        CommonSimpleTextfield(
          controller: controller,
          hintText: hintText,
          validator: validator,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

Widget topBarBackArrowWithTitleWidget(context, title) {
  final _theme = Theme.of(context);
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(top: height * 0.05, right: width * 0.05),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: CLOSE_ICON,
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: height * 0.05),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style:
              _theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

Widget labelText(context, title) {
  final _theme = Theme.of(context);
  return Align(
    alignment: Alignment.center,
    child: Container(
      margin: EdgeInsets.all(5),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: _theme.textTheme.headline6!
            .copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: MARUN),
      ),
    ),
  );
}

Widget topBarTitleWidget(context, title) {
  final _theme = Theme.of(context);
  final height = MediaQuery.of(context).size.height;
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: height * 0.01),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style:
              _theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

InputDecoration inputRoundedDecoration(
    {required String getHint, Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
    hintText: getHint,
    hintStyle: TextStyle(color: DARK_GRAY),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.only(left: 30, right: 30),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
  );
}

InputDecoration inputSimpleDecoration(
    {required String getHint, Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
    hintText: getHint,
    hintStyle: TextStyle(color: DARK_GRAY),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.zero,
    fillColor: Colors.transparent,
    focusedErrorBorder: UnderlineInputBorder(),
    errorBorder: UnderlineInputBorder(),
    enabledBorder: UnderlineInputBorder(),
    focusedBorder: UnderlineInputBorder(),
  );
}

BoxDecoration boxDecorationContainer() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 2),
      ),
    ],
  );
}

TextStyle appBarTextStyle() => TextStyle(
    fontFamily: QUICKSAND,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: DARK_PINK_COLOR);

EdgeInsets buildEdgeInsets(double width) {
  return EdgeInsets.only(top: 80, left: width * 0.15, right: width * 0.15);
}

EdgeInsets buildEdgeInsetsCustom(double width, left, top, right, bottom) {
  return EdgeInsets.only(
      left: width * left, top: top, right: width * right, bottom: bottom);
}

EdgeInsets bottomContinueBtnEdgeInsets(double width, double height) {
  return EdgeInsets.only(
      top: height * 0.03,
      left: width * 0.15,
      right: width * 0.15,
      bottom: height * 0.03);
}

Future showSnakeBar(BuildContext context, {required String msg}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

Future<void> showLoadingDialog(
    BuildContext context, GlobalKey _key, String message) async {
  return Future.delayed(
    Duration.zero,
    () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            key: _key,
            contentPadding: EdgeInsets.all(15),
            backgroundColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

//Top Icon on Intro
class TopAppLogo extends StatelessWidget {
  TopAppLogo({required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/helpozzy_logo.png'),
          Text(
            HELPOZZY_REMAINING_TEXT,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: DARK_BLACK,
                  fontSize: height / 3,
                ),
          )
        ],
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  CommonButton({
    required this.text,
    this.color = PRIMARY_COLOR,
    this.fontSize = 18,
    required this.onPressed,
    this.borderColor = BLACK,
    this.fontColor = WHITE,
    this.elevation = 3,
  });
  final String text;
  final Color color;
  final Color fontColor;
  final double fontSize;
  final void Function() onPressed;
  final Color borderColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 0.3),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: QUICKSAND,
            color: fontColor,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class CommonButtonWithIcon extends StatelessWidget {
  CommonButtonWithIcon({
    required this.text,
    required this.icon,
    this.buttonColor = PRIMARY_COLOR,
    this.fontSize = 18,
    this.onPressed,
    this.borderColor = BLACK,
    this.fontColor = WHITE,
    this.iconColor = WHITE,
    this.iconSize,
  });
  final IconData icon;
  final String text;
  final Color buttonColor;
  final double fontSize;
  final void Function()? onPressed;
  final Color borderColor;
  final Color fontColor;
  final Color iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1.0,
        primary: buttonColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 0.6),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: QUICKSAND,
                color: fontColor,
              ),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class CustomSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const CustomSeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

//Divider
class CommonDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: DIVIDER_COLOR,
      height: 0.3,
    );
  }
}

class CommonDividerWith extends StatelessWidget {
  CommonDividerWith({this.height, this.color});
  final double? height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: height,
      height: height,
    );
  }
}

//Placer Holder
class CommonUserPlaceholder extends StatelessWidget {
  CommonUserPlaceholder({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/user_placeholder.png',
      height: size,
      width: size,
    );
  }
}

class CommonAppBar {
  CommonAppBar(this.context);
  final BuildContext context;

  show({
    required String title,
    double? elevation,
    Color? color,
    Color? textColor,
    Function()? onBackPressed,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      centerTitle: true,
      elevation: elevation,
      backgroundColor: color ?? PRIMARY_COLOR,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: textColor ?? WHITE,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: IconButton(
        onPressed: onBackPressed ??
            () {
              Navigator.of(context).pop();
            },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: textColor ?? WHITE,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}

showAlertDialog(BuildContext context,
    {required String title, required String content}) {
  Widget okButton = TextButton(
    child: Text(OK_BUTTON),
    onPressed: () {},
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(fontWeight: FontWeight.bold),
    ),
    content: Text(
      content,
      style: Theme.of(context).textTheme.bodyText2,
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class CircularLoader {
  void show(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height,
          width: width,
          color: SHADOW_GRAY,
          child: Center(
            child: CircularProgressIndicator(color: LIGHT_ACCENT_GRAY),
          ),
        );
      },
    );
  }

  void hide(BuildContext context) {
    return Navigator.of(context).pop();
  }
}

class LinearLoader extends StatelessWidget {
  LinearLoader({this.minheight});
  final double? minheight;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 2.5,
      child: LinearProgressIndicator(
        color: LIGHT_ACCENT_GRAY,
        minHeight: minheight,
      ),
    );
  }
}
