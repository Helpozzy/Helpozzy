import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_tabs/member_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

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
  late double width;
  late double height;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _membersBloc.searchProjectMembers(searchText: '', projectId: projectId);
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
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            height: 34,
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.03,
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
                searchText: val,
                projectId: projectId,
              ),
            ),
          ),
          Expanded(child: membersList()),
        ],
      ),
    );
  }

  Widget membersList() {
    return StreamBuilder<List<SignUpAndUserModel>>(
      stream: _membersBloc.getSearchedProjectMembersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return snapshot.data!.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) => CommonDivider(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final SignUpAndUserModel volunteer = snapshot.data![index];
                  return MemberTabCard(volunteer: volunteer);
                },
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: width * 0.15),
                child: Text(
                  NO_MEMBERS_AVAILABLE,
                  style: _theme.textTheme.bodyText2!.copyWith(
                    color: DARK_GRAY,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
      },
    );
  }
}
