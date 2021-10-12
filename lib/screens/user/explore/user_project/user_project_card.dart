import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class UserProjectCard extends StatefulWidget {
  const UserProjectCard({
    this.onTapCard,
    required this.project,
    required this.onPressedSignUpButton,
  });
  final GestureTapCallback? onTapCard;
  final void Function()? onPressedSignUpButton;
  final ProjectModel project;

  @override
  _UserProjectCardState createState() => _UserProjectCardState(
      onTapCard: onTapCard,
      onPressedSignUpButton: onPressedSignUpButton,
      project: project);
}

class _UserProjectCardState extends State<UserProjectCard> {
  _UserProjectCardState({
    this.onTapCard,
    required this.project,
    required this.onPressedSignUpButton,
  });
  final GestureTapCallback? onTapCard;
  final void Function()? onPressedSignUpButton;
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final _theme = Theme.of(context);
    return GestureDetector(
      onTap: onTapCard,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                child: Image.asset(
                  project.imageUrl,
                  fit: BoxFit.cover,
                  height: height / 5,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('EEE, dd MMM - yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(project.startDate),
                            ),
                          ),
                          style: _theme.textTheme.bodyText2!.copyWith(
                            fontSize: 16,
                            color: PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              project.isLiked = !project.isLiked;
                            });
                          },
                          child: Icon(
                            project.isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: project.isLiked ? Colors.red : DARK_GRAY,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      project.projectName,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 22,
                        fontFamily: QUICKSAND,
                        color: BLUE_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      project.organization,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 14,
                        fontFamily: QUICKSAND,
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.location,
                              style: _theme.textTheme.bodyText2!.copyWith(
                                fontSize: 14,
                                fontFamily: QUICKSAND,
                                color: BLACK,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  itemSize: 18,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  unratedColor: GRAY,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AMBER_COLOR,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Text(
                                  '(${project.reviewCount} Reviews)',
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    fontSize: 12,
                                    fontFamily: QUICKSAND,
                                    color: DARK_GRAY,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        CommonButton(
                          fontSize: 11,
                          text: SIGN_UP,
                          onPressed: onPressedSignUpButton!,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
