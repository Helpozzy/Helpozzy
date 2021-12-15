import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class IntroWidget extends StatelessWidget {
  List<PageItem> arrPageItems = [];
  Color pageIndicatorColor;
  Color pageIndicatorSelectedColor;
  Color buttonsColor;
  Color buttonsTextColor;
  Function(BuildContext) loginScreenCallback;
  Function(BuildContext) signupScreenCallback;
  PageController controller = PageController(initialPage: 0);
  late ThemeData _theme;
  late double height;
  IntroWidget(
      {required this.arrPageItems,
      required this.pageIndicatorColor,
      required this.pageIndicatorSelectedColor,
      required this.buttonsColor,
      required this.buttonsTextColor,
      required this.signupScreenCallback,
      required this.loginScreenCallback});

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          _createPageBuilder(context),
          Padding(
            padding: EdgeInsets.only(top: height * 0.05),
            child: TopAppLogo(height: height / 6),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _textContainer(context),
              _createPageIndicator(context),
              _createButtonsContainer(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _textContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<IntroWidgetNavigationProvider>(
        builder: (ctx, item, child) {
          return Text(
            arrPageItems[item.pageSelectedIndex].text,
            textAlign: TextAlign.center,
            style: _theme.textTheme.headline6!.copyWith(color: WHITE),
          );
        },
      ),
    );
  }

  Widget _createButtonsContainer(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: EdgeInsets.only(bottom: height * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(left: width * 0.10, right: width * 0.10),
              width: double.infinity,
              child: CommonButton(
                  borderColor: WHITE,
                  text: MSG_SIGN_UP.toUpperCase(),
                  onPressed: () {
                    signupScreenCallback(context);
                  }),
            ),
            TextButton(
              child: Text(
                MSG_LOGIN,
                style: _theme.textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: WHITE,
                ),
              ),
              onPressed: () {
                loginScreenCallback(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  PageView _createPageBuilder(BuildContext context) {
    final IntroWidgetNavigationProvider provider =
        Provider.of<IntroWidgetNavigationProvider>(context, listen: false);
    return PageView.builder(
      physics: const ClampingScrollPhysics(),
      controller: controller,
      itemBuilder: (ctx, index) => _pageBuilder(ctx, arrPageItems[index]),
      itemCount: arrPageItems.length,
      onPageChanged: (pageIndex) {
        provider.setPageSelectedIndex(pageIndex);
      },
    );
  }

  Widget _createPageIndicator(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Consumer<IntroWidgetNavigationProvider>(
      builder: (ctx, item, child) {
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: height * 0.03),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.42),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < arrPageItems.length; i++)
                    if (i == item.pageSelectedIndex)
                      _circleIndicator(true)
                    else
                      _circleIndicator(false),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _circleIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 7,
      width: 7,
      decoration: BoxDecoration(
          color: isActive ? pageIndicatorSelectedColor : pageIndicatorColor,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  Widget _pageBuilder(BuildContext context, PageItem page) {
    return Container(
        child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          page.imgPath,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black38,
        )
      ],
    ));
  }
}

class PageItem {
  String imgPath;
  String text;
  PageItem({required this.imgPath, required this.text});
}

class IntroWidgetNavigationProvider extends ChangeNotifier {
  int pageSelectedIndex = 0;
  void setPageSelectedIndex(int sIndex) {
    pageSelectedIndex = sIndex;
    notifyListeners();
  }
}
