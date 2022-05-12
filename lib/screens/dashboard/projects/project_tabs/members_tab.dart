import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/url_launcher.dart';

class ProjectMembersTab extends StatefulWidget {
  ProjectMembersTab({required this.projectId});
  final String projectId;
  @override
  _ProjectMembersTabState createState() =>
      _ProjectMembersTabState(projectId: projectId);
}

class _ProjectMembersTabState extends State<ProjectMembersTab> {
  _ProjectMembersTabState({required this.projectId});
  final String projectId;
  final TextEditingController _searchController = TextEditingController();
  final MembersBloc _membersBloc = MembersBloc();
  final DateFormatFromTimeStamp _dateFormatFromTimeStamp =
      DateFormatFromTimeStamp();
  late double width;
  late double height;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _membersBloc.searchProjectMembers(searchText: '', projectId: projectId);
  }

  String getLastSeen(String timeStamp) {
    final String lastseen =
        _dateFormatFromTimeStamp.getPastTimeFromCurrent(timeStamp);
    return lastseen;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(body: body());
  }

  Widget body() {
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Container(
            height: 34,
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 5.0,
            ),
            child: CommonRoundedTextfield(
              fillColor: GRAY,
              controller: _searchController,
              textAlignCenter: false,
              hintText: SEARCH_MEMBERS_HINT,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: DARK_GRAY,
                  size: 20,
                ),
              ),
              validator: (val) => null,
              onChanged: (val) => _membersBloc.searchProjectMembers(
                  searchText: val, projectId: projectId),
            ),
          ),
          CommonDivider(),
          Expanded(child: membersList()),
        ],
      ),
    );
  }

  Widget membersList() {
    return StreamBuilder<dynamic>(
      stream: _membersBloc.getSearchedProjectMembersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return snapshot.data.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) => CommonDivider(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final SignUpAndUserModel volunteer = snapshot.data[index];
                  return memberItem(volunteer: volunteer);
                },
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: width * 0.15),
                child: Text(
                  NO_MEMBERS_AVAILABLE,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(color: DARK_GRAY, fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  Widget memberItem({required SignUpAndUserModel volunteer}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: width * 0.035, horizontal: width * 0.04),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: CommonUserProfileOrPlaceholder(
              size: width * 0.11,
              borderColor: volunteer.presence! ? GREEN : PRIMARY_COLOR,
              imgUrl: volunteer.profileUrl,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer.firstName! + ' ' + volunteer.lastName!,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  getLastSeen(volunteer.lastSeen!),
                  style: _theme.textTheme.bodyText2!.copyWith(
                    fontSize: 9,
                    color: UNSELECTED_TAB_COLOR,
                  ),
                ),
                Text(
                  volunteer.address!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyText2!.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async =>
                      CommonUrlLauncher().launchCall(volunteer.personalPhnNo!),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.phone,
                      color: BLACK,
                      size: 20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.chat_bubble_text,
                      color: BLACK,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
