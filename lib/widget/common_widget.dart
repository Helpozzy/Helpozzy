import 'package:cached_network_image/cached_network_image.dart';
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
        margin: EdgeInsets.only(top: height * 0.05, left: width * 0.03),
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

  Widget showBackForwardButton({required VoidCallback? onPressedForward}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          top: height * 0.05, left: width * 0.03, right: width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: CLOSE_ICON,
            ),
          ),
          IconButton(
            onPressed: onPressedForward,
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: CLOSE_ICON,
            ),
          ),
        ],
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
      margin: EdgeInsets.symmetric(vertical: height * 0.03),
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
    this.fillColor,
    this.inputFormatters,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.maxLines = 1,
    this.borderEnable = true,
    this.textAlignCenter = true,
    this.textCapitalization = TextCapitalization.none,
  });
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final int? maxLength;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? textAlignCenter;
  final TextCapitalization textCapitalization;
  final bool? borderEnable;
  final TextInputAction? textInputAction;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: textAlignCenter! ? TextAlign.center : TextAlign.left,
      style: _theme.textTheme.bodyText1,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction ?? TextInputAction.next,
      textCapitalization: textCapitalization,
      decoration: inputRoundedDecoration(
        fillColor: fillColor,
        getHint: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        borderEnable: borderEnable,
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
      alignment: Alignment.centerLeft,
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
        TopInfoLabel(label: label),
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
            .bodyText2!
            .copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class CommonSimpleTextfield extends StatelessWidget {
  const CommonSimpleTextfield({
    required this.controller,
    required this.hintText,
    required this.validator,
    this.textCapitalization,
    this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.textInputAction,
  });
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextCapitalization? textCapitalization;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: _theme.textTheme.bodyText2,
      textCapitalization: textCapitalization != null
          ? textCapitalization!
          : TextCapitalization.none,
      keyboardType: keyboardType,
      textInputAction:
          textInputAction != null ? textInputAction : TextInputAction.next,
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
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
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
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextfieldLabelSmall(label: label),
        CommonSimpleTextfield(
          controller: controller,
          hintText: hintText,
          validator: validator,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          maxLength: maxLength,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onTap: onTap,
          textInputAction: textInputAction,
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

//Badge
class CommonBadge extends StatelessWidget {
  const CommonBadge({
    required this.color,
    required this.size,
  });
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
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

InputDecoration inputRoundedDecoration({
  required String getHint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Color? fillColor,
  bool? borderEnable = true,
  bool isDropDown = false,
}) {
  return InputDecoration(
    hintText: getHint,
    hintStyle: TextStyle(color: DARK_GRAY),
    filled: true,
    fillColor: fillColor == null ? Colors.white : fillColor,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.only(
      top: 20,
      left: 20, right: 20,
      // right: isDropDown ? 15 : 30,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide:
          borderEnable! ? BorderSide(color: WHITE, width: 1) : BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: borderEnable
          ? BorderSide(color: RED_COLOR, width: 1)
          : BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide:
          borderEnable ? BorderSide(color: WHITE, width: 1) : BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide:
          borderEnable ? BorderSide(color: WHITE, width: 1) : BorderSide.none,
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
    contentPadding: EdgeInsets.only(top: 15, bottom: 8),
    fillColor: Colors.transparent,
    focusedErrorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: DARK_GRAY)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: RED_COLOR)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: DARK_GRAY)),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: DARK_GRAY)),
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

EdgeInsets buildEdgeInsetsCustom(
    {required double width, left, top, right, bottom}) {
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

class ScaffoldSnakBar {
  Future show(BuildContext context, {required String msg}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: WHITE.withOpacity(0.8),
              ),
        ),
        backgroundColor: PRIMARY_COLOR.withOpacity(0.9),
      ),
    );
  }
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

//Radio tile
class RadioTile extends StatelessWidget {
  const RadioTile({
    Key? key,
    required this.label,
    required this.widget,
  }) : super(key: key);
  final String label;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget,
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: DARK_GRAY,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

//Top Icon on Intro
class TopAppLogo extends StatelessWidget {
  TopAppLogo({required this.size, this.color});
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/helpozzy_logo.png',
            color: color != null ? color : DARK_BLACK,
          ),
          SizedBox(width: 5),
          Text(
            HELPOZZY_REMAINING_TEXT,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color != null ? color : DARK_BLACK,
                  fontSize: size / 3,
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
    this.fontColor = WHITE,
    this.elevation = 3,
  });
  final String text;
  final Color color;
  final Color fontColor;
  final double fontSize;
  final void Function() onPressed;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
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
        backgroundColor: buttonColor,
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

class SmallCommonButtonWithIcon extends StatelessWidget {
  SmallCommonButtonWithIcon({
    required this.text,
    required this.icon,
    this.buttonColor = PRIMARY_COLOR,
    this.fontSize = 18,
    this.onPressed,
    this.fontColor = WHITE,
    this.iconColor = WHITE,
    this.iconSize,
  });
  final IconData icon;
  final String text;
  final Color buttonColor;
  final double fontSize;
  final void Function()? onPressed;
  final Color fontColor;
  final Color iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0, left: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(width: 3),
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
      onTap: onPressed,
    );
  }
}

class SmallCommonButton extends StatelessWidget {
  SmallCommonButton({
    required this.text,
    this.buttonColor = PRIMARY_COLOR,
    this.fontSize = 18,
    required this.onPressed,
    this.fontColor = WHITE,
  });
  final String text;
  final Color buttonColor;
  final double fontSize;
  final void Function()? onPressed;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: QUICKSAND,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: fontColor,
          ),
        ),
      ),
      onTap: onPressed,
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
      height: 0.5,
    );
  }
}

class CommonDividerWithVal extends StatelessWidget {
  CommonDividerWithVal({this.height, this.color});
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
class CommonUserProfileOrPlaceholder extends StatelessWidget {
  CommonUserProfileOrPlaceholder({
    this.imgUrl,
    required this.size,
    this.borderColor,
  });
  final String? imgUrl;
  final Color? borderColor;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          size > 50
              ? 25
              : size < 35
                  ? 13
                  : 18,
        ),
        border: Border.all(
          width: 2,
          color: borderColor ?? PRIMARY_COLOR,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          size > 50
              ? 23
              : size < 35
                  ? 11
                  : 16,
        ),
        child: CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: PRIMARY_COLOR,
              strokeWidth: 0.7,
            ),
          ),
          errorWidget: (context, url, error) =>
              Icon(Icons.error_outline_rounded),
          imageUrl: imgUrl != null ? imgUrl! : APP_ICON_URL,
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      ),
    );
  }
}

class CommonAppBar {
  CommonAppBar(this.context);
  final BuildContext context;

  AppBar show({
    required String title,
    Function()? onBack,
    List<Widget>? actions,
    double? fontSize,
    double elevation = 0.0,
    PreferredSizeWidget? bottom,
    Color? backgroundColor,
    bool backButton = true,
  }) {
    return AppBar(
      centerTitle: true,
      elevation: elevation,
      backgroundColor: backgroundColor ?? WHITE,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: DARK_PINK_COLOR,
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: backButton
          ? IconButton(
              onPressed: onBack ??
                  () {
                    Navigator.of(context).pop();
                  },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: DARK_PINK_COLOR,
              ),
            )
          : SizedBox(),
      actions: actions,
      bottom: bottom,
    );
  }
}

double timeConvertToDouble(TimeOfDay myTime) =>
    myTime.hour + myTime.minute / 60.0;

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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 2.5,
      child: LinearProgressIndicator(
        color: GRAY,
        minHeight: 12,
      ),
    );
  }
}

class ListDividerLabel extends StatelessWidget {
  ListDividerLabel({
    required this.label,
    this.suffixIcon,
  });
  final String label;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.04),
      color: GRAY,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: DARK_GRAY_FONT_COLOR,
                  ),
            ),
          ),
          suffixIcon != null ? suffixIcon! : SizedBox(),
        ],
      ),
    );
  }
}

//Status Indicator
class StatusWidget extends StatelessWidget {
  const StatusWidget({this.label});
  final String? label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(width: 0.7, color: PRIMARY_COLOR.withOpacity(0.2))),
      child: Text(
        label!.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 8,
              color: BLUE_COLOR,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class CounterBadge extends StatelessWidget {
  const CounterBadge({Key? key, required this.counter}) : super(key: key);
  final String counter;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: PRIMARY_COLOR,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        counter,
        style: Theme.of(context).textTheme.caption!.copyWith(
              color: WHITE,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class NotifyBadge extends StatelessWidget {
  const NotifyBadge({Key? key, this.size}) : super(key: key);
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 8,
      width: size ?? 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: RED_COLOR,
      ),
    );
  }
}
