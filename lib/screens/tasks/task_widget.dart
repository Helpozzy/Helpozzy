import 'package:flutter/material.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    required this.task,
    this.optionEnable = false,
    this.selected = false,
    this.onTapDelete,
    this.onTapItem,
  });
  final TaskModel task;
  final bool optionEnable;
  final bool selected;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapDelete;

  String timeStampConvertToDate(String date) {
    return DateFormat('EEE, dd MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
    );
  }

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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTapItem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskName,
                      style: _themeData.textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      timeStampConvertToDate(task.startDate) +
                          ' ' +
                          task.startTime +
                          ' - ' +
                          task.endTime,
                      style: _themeData.textTheme.bodyText2!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      task.description,
                      style: _themeData.textTheme.bodyText2!.copyWith(
                          color: DARK_GRAY,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            optionEnable
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: DARK_GRAY,
                    ),
                    onPressed: onTapDelete,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
