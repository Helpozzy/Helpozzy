import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MemberCard extends StatelessWidget {
  final SignUpAndUserModel volunteer;
  final bool selected;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapLike;
  final GestureTapCallback? onTapChat;
  MemberCard({
    required this.volunteer,
    this.selected = false,
    this.onTapItem,
    this.onTapLike,
    this.onTapChat,
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        elevation: 4,
        color: selected ? ACCENT_GRAY : WHITE,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: width * 0.035,
            horizontal: width * 0.04,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonUserProfileOrPlaceholder(
                size: width * 0.12,
                imgUrl: volunteer.profileUrl,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        volunteer.firstName! + ' ' + volunteer.lastName!,
                        style: _theme.textTheme.bodyText2!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.location,
                          color: DARK_GRAY,
                          size: 13,
                        ),
                        Expanded(
                          child: Text(
                            volunteer.address!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _theme.textTheme.bodyText2!
                                .copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(
                    //         top: 3.0,
                    //         bottom: 3.0,
                    //         right: 5.0,
                    //       ),
                    //       child: RatingBar.builder(
                    //         initialRating: volunteer.rating!,
                    //         ignoreGestures: true,
                    //         minRating: 1,
                    //         itemSize: 15,
                    //         direction: Axis.horizontal,
                    //         allowHalfRating: true,
                    //         itemCount: 5,
                    //         unratedColor: GRAY,
                    //         itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    //         itemBuilder: (context, _) => Icon(
                    //           Icons.star,
                    //           color: AMBER_COLOR,
                    //         ),
                    //         onRatingUpdate: (rating) => print(rating),
                    //       ),
                    //     ),
                    //     Text(
                    //       '(${volunteer.reviewsByPersons} Reviews)',
                    //       style: _theme.textTheme.bodyText2!
                    //           .copyWith(fontSize: 10),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onTapLike,
                    child: Icon(
                      volunteer.favorite!
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: volunteer.favorite! ? PINK_COLOR : BLACK,
                      size: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: onTapChat,
                    child: Icon(
                      CupertinoIcons.chat_bubble_2_fill,
                      color: BLACK,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
