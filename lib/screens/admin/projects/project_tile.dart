import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';
import 'package:intl/intl.dart';

class ProjectTile extends StatefulWidget {
  ProjectTile(
      {required this.event,
      required this.isExpanded,
      required this.adminProjectsBloc});
  final EventModel event;
  final bool isExpanded;
  final AdminProjectsBloc adminProjectsBloc;
  @override
  _ProjectTileState createState() => _ProjectTileState(
      event: event,
      isExpanded: isExpanded,
      adminProjectsBloc: adminProjectsBloc);
}

class _ProjectTileState extends State<ProjectTile> {
  _ProjectTileState(
      {required this.event,
      required this.isExpanded,
      required this.adminProjectsBloc});
  final EventModel event;
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
                  event.eventName,
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
                          int.parse(event.dateTime),
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
                          event.isExpanded = !event.isExpanded;
                          adminProjectsBloc.isExpanded(isExpanded);
                        },
                        icon: event.isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        borderColor: event.isExpanded ? WHITE : PRIMARY_COLOR,
                        fontSize: 15,
                        iconSize: 18,
                        text:
                            event.isExpanded ? 'Hide Details ' : 'Show Details',
                        buttonColor: event.isExpanded ? PRIMARY_COLOR : GRAY,
                        iconColor: event.isExpanded ? WHITE : PRIMARY_COLOR,
                        fontColor: event.isExpanded ? WHITE : PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
                event.isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: CommonDivider(),
                      )
                    : SizedBox(),
                event.isExpanded ? projectDetails(event) : SizedBox(),
              ],
            ),
          ),
          CommonDivider(),
        ],
      ),
    );
  }

  Widget projectDetails(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          discription(
            title: LOCATION,
            detail: event.location,
            hasIcon: true,
            icon: Icons.directions,
            iconOnPressed: () {
              CommonUrlLauncher().launchMap(event.location);
            },
          ),
          discription(
            title: CONTACT,
            detail: event.contactName + '\n' + event.contactNumber,
            hasIcon: true,
            icon: Icons.call_rounded,
            iconOnPressed: () {
              CommonUrlLauncher().launchCall(event.contactNumber);
            },
          ),
          discription(
            title: ENROLLMENT_STATUS,
            detail: '27 Member signed up',
            hasIcon: false,
          ),
        ],
      ),
    );
  }

  Widget discription(
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
                  .copyWith(fontWeight: FontWeight.w600, color: BLACK),
            ),
          ),
          Text(
            ': ',
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w600, color: BLACK),
          ),
          Expanded(
            child: Text(
              detail,
              style: _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
            ),
          ),
          // hasIcon
          //     ? IconButton(
          //         icon: Icon(icon, color: DARK_GRAY_FONT_COLOR),
          //         onPressed: iconOnPressed,
          //       )
          //     : SizedBox(width: width * 0.12),
          SizedBox(width: 10)
        ],
      ),
    );
  }
}
