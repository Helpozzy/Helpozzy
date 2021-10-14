import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_projects_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/screens/user/explore/user_project/project_details.dart';
import 'package:helpozzy/utils/constants.dart';

class SearchProject {
  Future<void> modalBottomSheetMenu(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return SearchBarWidget();
      },
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final UserProjectsBloc _userProjectsBloc = UserProjectsBloc();
  final TextEditingController _searchController = TextEditingController();
  late ThemeData _theme;

  @override
  void initState() {
    _userProjectsBloc.getProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.965,
        padding: const EdgeInsets.symmetric(
          vertical: 23,
          horizontal: 10.0,
        ),
        child: Column(
          children: [
            bottomSheetSearchbar(context),
            // currentLocationCard(),
            Expanded(child: searchList()),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetSearchbar(context) {
    return TextField(
      controller: _searchController,
      onChanged: (val) {
        _userProjectsBloc.searchProjects(val);
      },
      decoration: InputDecoration(
        hintText: SEARCH_HINT,
        hintStyle: _theme.textTheme.headline6!.copyWith(
          color: DARK_GRAY,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 3, left: 12),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: BLACK,
            ),
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 3, right: 10),
          child: IconButton(
            onPressed: () {
              _searchController.clear();
              _userProjectsBloc.searchProjects('');
            },
            icon: Icon(
              Icons.close_rounded,
              color: BLACK,
              size: 25,
            ),
          ),
        ),
        enabledBorder: bottomSheetSearchBarDecoration(),
        disabledBorder: bottomSheetSearchBarDecoration(),
        focusedBorder: bottomSheetSearchBarDecoration(),
        border: bottomSheetSearchBarDecoration(),
      ),
    );
  }

  Widget currentLocationCard() {
    final BorderSide border = BorderSide(color: DIVIDER_COLOR, width: 0.3);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: WHITE,
          border: Border(left: border, right: border, bottom: border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: SHADOW_GRAY,
              offset: Offset(0.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: 0.5,
            ), //Bo//BoxShado
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 21.0, right: 8.0),
              child: Icon(Icons.pin_drop_outlined),
            ),
            Text(
              CURRENT_LOCATION,
              style: _theme.textTheme.headline6!.copyWith(
                fontSize: 16,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputBorder bottomSheetSearchBarDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(31.0),
        topRight: const Radius.circular(31.0),
      ),
      borderSide: BorderSide(
        color: DIVIDER_COLOR,
        width: 0.3,
      ),
    );
  }

  Widget searchList() {
    return StreamBuilder<dynamic>(
      stream: _userProjectsBloc.getSearchedProjectsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Search for project',
              style: _theme.textTheme.headline6,
            ),
          );
        }
        return snapshot.data.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final ProjectModel project = snapshot.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailsScreen(project: project),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Icon(
                                  Icons.search,
                                  color: PRIMARY_COLOR,
                                  size: 25,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.projectName,
                                    style: _theme.textTheme.bodyText2!.copyWith(
                                      fontSize: 16,
                                      color: DARK_GRAY,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    project.organization,
                                    style: _theme.textTheme.bodyText2!.copyWith(
                                      fontSize: 12,
                                      color: GRAY,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    project.location,
                                    style: _theme.textTheme.bodyText2!.copyWith(
                                      fontSize: 10,
                                      color: BLUE_GRAY,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: DIVIDER_COLOR,
                          height: 0.3,
                          endIndent: 5,
                          indent: 5,
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'Search Project..',
                  style: _theme.textTheme.headline6,
                ),
              );
      },
    );
  }
}
