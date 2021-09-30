import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_projects_bloc.dart';
import 'package:helpozzy/bloc/event_bloc.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

class UpcomingTab extends StatefulWidget {
  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  final EventsBloc _eventsBloc = EventsBloc();
  AdminProjectsBloc _adminProjectsBloc = AdminProjectsBloc();
  late ThemeData _theme;
  late double height;
  late double width;
  late bool isExpanded = false;

  @override
  void initState() {
    _eventsBloc.getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(child: projectList()),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CommonButtonWithIcon(
            text: ADD_NEW_PROJECT_BUTTON,
            icon: CupertinoIcons.add_circled,
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget projectList() {
    return StreamBuilder<Events>(
      stream: _eventsBloc.getEventsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader(minheight: 12));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: snapshot.data!.events.length,
          itemBuilder: (context, index) {
            final EventModel event = snapshot.data!.events[index];
            return StreamBuilder<bool>(
                initialData: false,
                stream: _adminProjectsBloc.getProjectExpandStream,
                builder: (context, snapshot) {
                  return projectItem(event: event, isExpanded: snapshot.data!);
                });
          },
        );
      },
    );
  }

  Widget projectItem({required EventModel event, required bool isExpanded}) {
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
                    color: BLUE_GRAY,
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
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.6,
                      child: CommonButtonWithIcon(
                        onPressed: () {
                          event.isExpanded = !event.isExpanded;
                          _adminProjectsBloc.isExpanded(isExpanded);
                        },
                        icon: Icons.keyboard_arrow_down_rounded,
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
            iconOnPressed: () {},
          ),
          discription(
            title: CONTACT,
            detail: event.organization,
            hasIcon: true,
            icon: Icons.call_rounded,
            iconOnPressed: () {},
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
                  .copyWith(fontWeight: FontWeight.w600, color: DARK_GRAY),
            ),
          ),
          Text(': ', style: _theme.textTheme.bodyText2!),
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
}
//  DateTime.now().millisecondsSinceEpoch.toString()
