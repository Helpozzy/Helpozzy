import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SearchCityBottomSheet {
  Future<dynamic> showBottomSheet(BuildContext context,
      {required List<CityModel> cities}) async {
    dynamic response = await showModalBottomSheet<dynamic>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) => SearchCityBottomSheetWidget(cities: cities),
    );
    return response;
  }
}

class SearchCityBottomSheetWidget extends StatefulWidget {
  SearchCityBottomSheetWidget({required this.cities});
  final List<CityModel> cities;
  @override
  _SearchCityBottomSheetWidgetState createState() =>
      _SearchCityBottomSheetWidgetState(cities: cities);
}

class _SearchCityBottomSheetWidgetState
    extends State<SearchCityBottomSheetWidget> {
  _SearchCityBottomSheetWidgetState({required this.cities});
  final List<CityModel> cities;
  final TextEditingController _searchController = TextEditingController();
  final CityBloc _cityBloc = CityBloc();
  late ThemeData _theme;
  late double width;

  @override
  void initState() {
    _cityBloc.citiesListFromList(cities: cities);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
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
      onChanged: (val) => _cityBloc.searchItem(searchText: val),
      decoration: InputDecoration(
        hintText: SEARCH_CITY_NAME_HINT,
        hintStyle: _theme.textTheme.headline6!.copyWith(
          color: DARK_GRAY,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
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
            onPressed: () async {
              _searchController.clear();
              await _cityBloc.searchItem(searchText: '');
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
      stream: _cityBloc.searchedCitiesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return snapshot.data.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final CityModel cityModel = snapshot.data[index];
                  return textItem(cityModel);
                },
              )
            : Center(
                child: Text(
                  'Search City..',
                  style: _theme.textTheme.headline6,
                ),
              );
      },
    );
  }

  Widget textItem(CityModel cityModel) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(cityModel.cityName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 14),
            child: Text(
              cityModel.cityName!,
              style: _theme.textTheme.bodyText2!.copyWith(
                fontSize: 16,
                color: DARK_GRAY_FONT_COLOR,
              ),
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
