import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/school_info_bloc.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SearchSchool {
  Future<SchoolDetailsModel> modalBottomSheetMenu(BuildContext context) async {
    SchoolDetailsModel? school = await showModalBottomSheet<SchoolDetailsModel>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return SearchSchoolWidget();
      },
    );
    return school!;
  }
}

class SearchSchoolWidget extends StatefulWidget {
  @override
  _SearchSchoolWidgetState createState() => _SearchSchoolWidgetState();
}

class _SearchSchoolWidgetState extends State<SearchSchoolWidget> {
  final TextEditingController _searchController = TextEditingController();
  SchoolsInfoBloc _schoolsInfoBloc = SchoolsInfoBloc();
  late ThemeData _theme;
  late double width;

  @override
  void initState() {
    _schoolsInfoBloc.searchSchool('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: GestureDetector(
        onPanDown: (_) {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.965,
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            children: [
              bottomSheetSearchbar(context),
              Expanded(child: searchList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetSearchbar(context) {
    return TextField(
      controller: _searchController,
      onChanged: (val) {
        _schoolsInfoBloc.searchSchool(val);
      },
      decoration: InputDecoration(
        hintText: SEARCH_HINT,
        hintStyle: _theme.textTheme.headline6!.copyWith(
          color: DARK_GRAY,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: BLACK,
              size: 18,
            ),
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              _searchController.clear();
              _schoolsInfoBloc.searchSchool('');
            },
            icon: Icon(
              Icons.close_rounded,
              color: BLACK,
              size: 22,
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

  InputBorder bottomSheetSearchBarDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(15.0),
        topRight: const Radius.circular(15.0),
      ),
      borderSide: BorderSide(
        color: DARK_GRAY,
        width: 0.3,
      ),
    );
  }

  Widget searchList() {
    return StreamBuilder<dynamic>(
      stream: _schoolsInfoBloc.searchedSchoolsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader(minheight: 12));
        }
        return snapshot.data.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final SchoolDetailsModel school = snapshot.data[index];
                  return schoolItem(school);
                },
              )
            : Center(
                child: Text(
                  'Search School..',
                  style: _theme.textTheme.headline6,
                ),
              );
      },
    );
  }

  Widget schoolItem(SchoolDetailsModel school) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(school);
      },
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        school.schoolName,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                          color: DARK_GRAY_FONT_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        school.streetAddress +
                            ', ' +
                            school.city +
                            ', ' +
                            school.state +
                            ', ' +
                            school.district +
                            '. ' +
                            school.zip,
                        style: _theme.textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                          color: BLUE_GRAY,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Phone No. : ' + school.phone,
                        style: _theme.textTheme.bodyText2!
                            .copyWith(fontSize: 10, color: DARK_GRAY),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(
                    Icons.search,
                    color: PRIMARY_COLOR,
                    size: 25,
                  ),
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
  }
}
