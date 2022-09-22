import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectCard extends StatelessWidget {
  ProjectCard({
    this.onTapCard,
    required this.project,
    this.onPressedSignUpButton,
  });
  final GestureTapCallback? onTapCard;
  final void Function()? onPressedSignUpButton;
  final ProjectModel project;
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final _theme = Theme.of(context);
    return GestureDetector(
      onTap: onTapCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  project.imageUrl!,
                  fit: BoxFit.fill,
                  height: width / 2,
                  width: double.infinity,
                ),
              ),
              Container(
                height: width / 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                height: width / 2,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormatFromTimeStamp().dateFormatToEEEDDMMMYYYY(
                          timeStamp: project.startDate!),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 11,
                        color: LIGHT_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      project.projectName!,
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
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                size: 15,
                                color: WHITE,
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  project.location!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: _theme.textTheme.bodyText2!.copyWith(
                                    fontSize: 12,
                                    color: MATE_WHITE,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        project.ownerId ==
                                prefsObject.getString(CURRENT_USER_ID)
                            ? SizedBox()
                            : DateFormatFromTimeStamp()
                                        .dateTime(
                                            timeStamp:
                                                currentTimeStamp.toString())
                                        .difference(DateFormatFromTimeStamp()
                                            .dateTime(
                                                timeStamp: project.endDate!))
                                        .inDays >=
                                    1
                                ? SizedBox()
                                : project.isSignedUp!
                                    ? SizedBox()
                                    : project.status == TOGGLE_COMPLETE
                                        ? SizedBox()
                                        : onPressedSignUpButton != null
                                            ? SmallCommonButton(
                                                fontSize: 12,
                                                text: SIGN_UP,
                                                buttonColor: DARK_PINK_COLOR,
                                                onPressed:
                                                    onPressedSignUpButton!,
                                              )
                                            : SizedBox(),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
