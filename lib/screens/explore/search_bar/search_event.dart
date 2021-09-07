import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class SearchEvent {
  Future<void> modalBottomSheetMenu(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(11.0),
          topRight: const Radius.circular(11.0),
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      builder: (builder) {
        return SearchBarWidget();
      },
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 23,
        horizontal: 10.0,
      ),
      child: Column(
        children: [
          bottomSheetSearchbar(context),
          currentLocationCard(),
          searchList(),
        ],
      ),
    );
  }

  Widget bottomSheetSearchbar(context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: SEARCH_HINT,
        hintStyle: TextStyle(
          fontSize: 17,
          color: DARK_GRAY,
          fontFamily: QUICKSAND,
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
              style: TextStyle(
                fontSize: 17,
                color: BLUE,
                fontFamily: QUICKSAND,
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventStrings.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Icon(Icons.search),
                    ),
                    Text(
                      eventStrings[index],
                      style: TextStyle(
                        fontSize: 17,
                        color: DARK_GRAY,
                        fontFamily: QUICKSAND,
                        fontWeight: FontWeight.w500,
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
      },
    );
  }
}
