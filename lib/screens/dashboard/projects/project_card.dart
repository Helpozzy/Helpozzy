import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    this.onTapCard,
    required this.project,
    required this.onPressedSignUpButton,
  });
  final GestureTapCallback? onTapCard;
  final void Function()? onPressedSignUpButton;
  final ProjectModel project;

  @override
  _ProjectCardState createState() => _ProjectCardState(
      onTapCard: onTapCard,
      onPressedSignUpButton: onPressedSignUpButton,
      project: project);
}

class _ProjectCardState extends State<ProjectCard> {
  _ProjectCardState({
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  project.imageUrl,
                  fit: BoxFit.cover,
                  height: height / 4,
                  width: double.infinity,
                ),
              ),
              Container(
                height: height / 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              Container(
                height: height / 4,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                          timeStamp: project.startDate),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 11,
                        color: LIGHT_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      project.projectName,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 20,
                        color: SILVER_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.location,
                                style: _theme.textTheme.bodyText2!.copyWith(
                                  fontSize: 11,
                                  color: MATE_WHITE,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: project.rating,
                                    minRating: 1,
                                    itemSize: 12,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    unratedColor: GRAY,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: AMBER_COLOR,
                                    ),
                                    onRatingUpdate: (rating) => print(rating),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '(${project.reviewCount} Reviews)',
                                    style: _theme.textTheme.bodyText2!.copyWith(
                                      fontSize: 10,
                                      color: GRAY,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        project.projectOwner ==
                                prefsObject.getString(CURRENT_USER_ID)
                            ? SizedBox()
                            : project.status == PROJECT_COMPLETED
                                ? SizedBox()
                                : SmallCommonButton(
                                    fontSize: 12,
                                    text: SIGN_UP,
                                    buttonColor: DARK_PINK_COLOR,
                                    onPressed: onPressedSignUpButton!,
                                  ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() => project.isLiked = !project.isLiked);
                  },
                  icon: Icon(
                    project.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: project.isLiked ? Colors.red : WHITE,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
