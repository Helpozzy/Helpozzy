import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/members_bloc.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/dashboard/members/memebers_card.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MembersScreen extends StatefulWidget {
  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MembersBloc _membersBloc = MembersBloc();
  late double width;
  late double height;
  late ThemeData _theme;
  late bool favVolunteers = false;
  late List<SignUpAndUserModel> selectedItems = [];

  @override
  void initState() {
    _membersBloc.searchMembers(searchText: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
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
                popupButton(),
                SizedBox(width: 5),
                Expanded(
                  child: CommonRoundedTextfield(
                    fillColor: GRAY,
                    controller: _searchController,
                    hintText: SEARCH_MEMBERS_HINT,
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
              ],
            ),
          ),
          Expanded(child: membersList()),
        ],
      ),
    );
  }

  Widget popupButton() {
    return PopupMenuButton<int>(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Icon(
        Icons.sort_rounded,
        size: 30,
        color: PRIMARY_COLOR,
      ),
      onSelected: (item) async => await handleClick(item),
      itemBuilder: (context) => [
        popupMenuItem(text: NAME_TEXT, value: 0),
        PopupMenuDivider(height: 0.1),
        popupMenuItem(text: RATING_TEXT, value: 1),
      ],
    );
  }

  PopupMenuItem<int> popupMenuItem(
          {required String text, required int value}) =>
      PopupMenuItem<int>(
        value: value,
        child: Text(
          text,
          style: _theme.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
        ),
      );

  Future handleClick(int item) async {
    switch (item) {
      case 0:
        _membersBloc.sortMembersByName();
        break;
      case 1:
        _membersBloc.sortMembersByRating();
        break;
    }
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
              selected: volunteer.isSelected!,
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
