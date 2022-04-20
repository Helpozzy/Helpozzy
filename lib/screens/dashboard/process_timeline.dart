import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:timelines/timelines.dart';

class ProcessTimelinePage extends StatelessWidget {
  ProcessTimelinePage({required this.items, required this.processIndex});
  final List<int> items;
  final int processIndex;

  Color getColor(int index) {
    if (items[index] < processIndex) {
      return PRIMARY_COLOR;
    } else {
      return Color(0xffd1d2d7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      shrinkWrap: true,
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: ConnectorThemeData(thickness: 3.0),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / (items.length + 1),
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              index == items.length - 1
                  ? '${items[index]}\nMy Goal'
                  : '${items[index]}',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: index == items.length - 1
                        ? FontWeight.bold
                        : FontWeight.w600,
                    fontSize: 12,
                    color: DARK_GRAY,
                  ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          var color;
          var child;
          if (items[index] < processIndex) {
            color = PRIMARY_COLOR;
            child = Icon(
              Icons.check_rounded,
              color: WHITE,
              size: 10.0,
            );
          } else {
            color = Color(0xffd1d2d7);
          }

          if (items[index] <= processIndex) {
            return DotIndicator(
              size: 15.0,
              color: color,
              child: child,
            );
          } else {
            return DotIndicator(
              size: 12.0,
              color: color,
            );
          }
        },
        connectorBuilder: (_, index, type) {
          if (items[index] > 0) {
            if (items[index] == processIndex) {
              return DecoratedLineConnector(
                decoration: BoxDecoration(color: SILVER_GRAY),
              );
            } else {
              return SolidLineConnector(
                color: getColor(index),
              );
            }
          } else {
            return null;
          }
        },
        itemCount: items.length,
      ),
    );
  }
}
