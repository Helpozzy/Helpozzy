import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum NavBarItem { SEARCH, BOOKMARK, NOTIFICATION, SETTINGS }

enum SelectedType { TODAY, THISWEEK, THISMONTH, CUSTOMDAY }

class BottomNavBarBloc {
  final BehaviorSubject<dynamic> _searchProjectsList =
      BehaviorSubject<dynamic>();

  Stream<dynamic> get eventListStream => _searchProjectsList.stream;

  dynamic equipmentList = [];

  dynamic equipmentSearchList = [];

  Future searchEquipment(String searchText) async {
    equipmentSearchList = [];
    if (searchText.isEmpty) {
      _searchProjectsList.sink.add(equipmentList);
    } else {
      for (int i = 0; i < equipmentList.length; i++) {
        if (equipmentList[i]
                .assetType
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            equipmentList[i]
                .assetID
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            equipmentList[i]
                .rego
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          equipmentSearchList.add(equipmentList[i]);
        }
      }
      _searchProjectsList.sink.add(equipmentSearchList);
    }
  }

  void dispose() {
    _searchProjectsList.close();
  }
}
