import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/task_bloc.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/task_details.dart';
import 'package:helpozzy/screens/dashboard/projects/project_task/task_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class MyEnrolledTask extends StatefulWidget {
  @override
  _MyEnrolledTaskState createState() => _MyEnrolledTaskState();
}

class _MyEnrolledTaskState extends State<MyEnrolledTask> {
  late ThemeData _theme;
  late double height;
  late double width;
  late bool myTaskExpanded = false;
  late bool allTasksExpanded = false;
  final TaskBloc _taskBloc = TaskBloc();

  @override
  void initState() {
    _taskBloc.getEnrolledTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        title: MY_TAKS_APPBAR,
        elevation: 0,
      ),
      body: tasks(),
    );
  }

  Widget tasks() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: StreamBuilder<Tasks>(
        stream: _taskBloc.getEnrolledTasksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LinearLoader(),
            );
          }
          return snapshot.data!.tasks.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
                  itemCount: snapshot.data!.tasks.length,
                  itemBuilder: (context, index) {
                    final TaskModel task = snapshot.data!.tasks[index];
                    return Row(
                      children: [
                        CommonBadge(
                          color: task.status == TOGGLE_NOT_STARTED
                              ? LIGHT_GRAY
                              : task.status == TOGGLE_INPROGRESS
                                  ? AMBER_COLOR
                                  : ACCENT_GREEN,
                          size: 15,
                          border: true,
                        ),
                        Expanded(
                          child: TaskCard(
                            task: task,
                            optionEnable: false,
                            onTapItem: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetails(task: task),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    TASK_NOT_AVAILABLE,
                    style: _theme.textTheme.headline6!.copyWith(color: GRAY),
                  ),
                );
        },
      ),
    );
  }
}
