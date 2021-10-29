import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    required this.title,
    required this.description,
    this.optionEnable = false,
    this.selected = false,
    this.onTapEdit,
    this.onTapDelete,
    this.onTapItem,
    this.onLongPressItem,
  });
  final String title;
  final String description;
  final bool optionEnable;
  final bool selected;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onLongPressItem;
  final GestureTapCallback? onTapEdit;
  final GestureTapCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData _themeData = Theme.of(context);
    return Card(
      elevation: 2,
      color: !optionEnable
          ? WHITE
          : selected
              ? GRAY
              : WHITE,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        title: Text(
          title,
          style: _themeData.textTheme.headline6!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          description,
          style: _themeData.textTheme.bodyText2!.copyWith(color: DARK_GRAY),
        ),
        trailing: optionEnable
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Icon(Icons.edit),
                    onTap: onTapEdit,
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    child: Icon(Icons.delete),
                    onTap: onTapDelete,
                  ),
                ],
              )
            : SizedBox(),
        onTap: onTapItem,
        onLongPress: onLongPressItem,
      ),
    );
  }
}
