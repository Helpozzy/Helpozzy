import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/members/memebers_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MembersScreen extends StatefulWidget {
  MembersScreen({this.selectedMembers});
  final List<SignUpAndUserModel>? selectedMembers;
  @override
  _MembersScreenState createState() =>
      _MembersScreenState(selectedMembers: selectedMembers);
}

class _MembersScreenState extends State<MembersScreen> {
  _MembersScreenState({this.selectedMembers});
  final List<SignUpAndUserModel>? selectedMembers;
  final TextEditingController _searchController = TextEditingController();
  final MembersBloc _membersBloc = MembersBloc();
  late double width;
  late double height;
  late bool favVolunteers = false;
  late List<SignUpAndUserModel> selectedItems = [];

  @override
  void initState() {
    _membersBloc.searchMembers(searchText: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(context).show(
        title: MEMBERS_APPBAR,
        onBack: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context, selectedItems),
            icon: Icon(
              Icons.check,
              color: DARK_PINK_COLOR,
            ),
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: CommonRoundedTextfield(
                    fillColor: GRAY,
                    controller: _searchController,
                    hintText: SEARCH_MEMBERS_HINT,
                    textInputAction: TextInputAction.done,
                    textAlignCenter: false,
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: DARK_GRAY,
                      size: 24,
                    ),
                    validator: (val) => null,
                    onChanged: (val) =>
                        _membersBloc.searchMembers(searchText: val),
                  ),
                ),
                SizedBox(width: 5),
                IconButton(
                    onPressed: () async =>
                        await _membersBloc.sortMembersByName(),
                    icon: Icon(Icons.sort_by_alpha_rounded))
              ],
            ),
          ),
          Expanded(child: membersList()),
        ],
      ),
    );
  }

  Widget membersList() {
    return StreamBuilder<List<SignUpAndUserModel>>(
      stream: _membersBloc.getSearchedMembersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final SignUpAndUserModel volunteer = snapshot.data![index];
            return MemberCard(
              volunteer: volunteer,
              selected: selectedMembers!.isNotEmpty &&
                      selectedMembers!.contains(volunteer.userId)
                  ? true
                  : volunteer.isSelected!,
              onTapItem: () {
                setState(() => volunteer.isSelected = !volunteer.isSelected!);
                if (volunteer.isSelected!) {
                  if (!selectedItems.contains(volunteer)) {
                    selectedItems.add(volunteer);
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}
