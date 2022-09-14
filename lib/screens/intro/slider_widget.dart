import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/page_item.dart';
import 'package:helpozzy/utils/constants.dart';

class SliderWidget extends StatelessWidget {
  final List<PageItem> arrItems = [
    PageItem(
      imgPath: 'assets/images/slide_one.png',
      text: 'EXPRESS EMPATHY \nTO OTHERS',
    ),
    PageItem(
      imgPath: 'assets/images/slide_two.png',
      text: 'BE MORE \nCOMPASSIONATE',
    ),
    PageItem(
      imgPath: 'assets/images/slide_three.png',
      text: 'GET TOGETHER \nTO SERVE BETTER',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
            items: arrItems
                .map((e) => Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              e.imgPath,
                              fit: BoxFit.cover,
                            ),
                            Container(color: Colors.black26),
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: height * 0.175),
                              child: Text(
                                e.text,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: WHITE,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    ))
                .toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
            ),
          ),
        ],
      ),
    );
  }
}
