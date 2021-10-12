import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:intl/intl.dart';

class ProjectTile extends StatefulWidget {
  ProjectTile(
      {required this.project,
      required this.isExpanded,
      required this.adminProjectsBloc});
  final ProjectModel project;
  final bool isExpanded;
  final AdminProjectsBloc adminProjectsBloc;
  @override
  _ProjectTileState createState() => _ProjectTileState(
      project: project,
      isExpanded: isExpanded,
      adminProjectsBloc: adminProjectsBloc);
}

class _ProjectTileState extends State<ProjectTile> {
  _ProjectTileState(
      {required this.project,
      required this.isExpanded,
      required this.adminProjectsBloc});
  final ProjectModel project;
  final bool isExpanded;
  final AdminProjectsBloc adminProjectsBloc;
  late ThemeData _theme;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Container(
      color: DARK_ACCENT_GRAY,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 21.0, bottom: 5.0, top: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.projectName,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 20,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEE, dd MMM - yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(project.startDate),
                        ),
                      ),
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontSize: 16,
                        color: BLUE_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.6,
                      child: CommonButtonWithIcon(
                        onPressed: () {
                          project.isExpanded = !project.isExpanded;
                          adminProjectsBloc.isExpanded(isExpanded);
                        },
                        icon: project.isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        borderColor: project.isExpanded ? WHITE : PRIMARY_COLOR,
                        fontSize: 15,
                        iconSize: 18,
                        text: project.isExpanded
                            ? 'Hide Details '
                            : 'Show Details',
                        buttonColor: project.isExpanded ? PRIMARY_COLOR : GRAY,
                        iconColor: project.isExpanded ? WHITE : PRIMARY_COLOR,
                        fontColor: project.isExpanded ? WHITE : PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
                project.isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: CommonDivider(),
                      )
                    : SizedBox(),
                project.isExpanded ? projectDetails(project) : SizedBox(),
                project.isExpandStatus
                    ? Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: CommonDivider(),
                      )
                    : SizedBox(),
                project.isExpanded
                    ? project.isExpandStatus
                        ? taskDetails(project)
                        : SizedBox()
                    : SizedBox()
              ],
            ),
          ),
          CommonDivider(),
        ],
      ),
    );
  }

  Widget projectDetails(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          projectExpandDetails(
            title: LOCATION,
            detail: project.location,
            hasIcon: true,
            icon: Icons.directions,
            iconOnPressed: () {
              CommonUrlLauncher().launchMap(project.location);
            },
          ),
          projectExpandDetails(
            title: CONTACT,
            detail: project.contactName + '\n' + project.contactNumber,
            hasIcon: true,
            icon: Icons.call_rounded,
            iconOnPressed: () {
              CommonUrlLauncher().launchCall(project.contactNumber);
            },
          ),
          projectExpandDetails(
            title: ENROLLMENT_STATUS,
            detail: '27 Member signed up',
            hasIcon: false,
          ),
          Transform.scale(
            scale: 0.6,
            child: CommonButtonWithIcon(
              onPressed: () {
                setState(() {
                  project.isExpandStatus = !project.isExpandStatus;
                });
              },
              icon: project.isExpandStatus
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              borderColor: project.isExpandStatus ? WHITE : PRIMARY_COLOR,
              fontSize: 15,
              iconSize: 18,
              text: 'Task Details',
              buttonColor: project.isExpandStatus ? PRIMARY_COLOR : GRAY,
              iconColor: project.isExpandStatus ? WHITE : PRIMARY_COLOR,
              fontColor: project.isExpandStatus ? WHITE : PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget projectExpandDetails(
      {required String title,
      required String detail,
      required bool hasIcon,
      IconData? icon,
      Function()? iconOnPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.w500, color: PRIMARY_COLOR),
            ),
          ),
          Text(
            ': ',
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w500, color: PRIMARY_COLOR),
          ),
          Expanded(
            child: Text(
              detail,
              style: _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
            ),
          ),
          hasIcon
              ? IconButton(
                  icon: Icon(icon, color: DARK_GRAY_FONT_COLOR),
                  onPressed: iconOnPressed,
                )
              : SizedBox(width: width * 0.12),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  Widget taskDetails(ProjectModel project) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, right: width * 0.05),
      child: Column(
        children: [
          taskStatus(
              color: GREEN,
              title: LOCATION,
              icon: Icons.checklist_rtl_outlined,
              count: 3),
          taskStatus(
              color: AMBER_COLOR,
              title: CONTACT,
              icon: Icons.access_time,
              count: 6),
          taskStatus(
              color: Colors.red,
              title: ENROLLMENT_STATUS,
              icon: Icons.warning_amber_rounded,
              count: 2),
        ],
      ),
    );
  }

  Widget taskStatus(
      {required String title, IconData? icon, Color? color, int? count}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: _theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Text(
            count.toString(),
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
