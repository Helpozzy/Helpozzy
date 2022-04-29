import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'create_edit_task.dart';
import 'task_widget.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  late double width;
  late ThemeData _theme;
  late List<TaskModel> tempSelectedTasks = [];

  @override
  void initState() {
    _projectTaskBloc.getProjectAllTasks('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(
        title: TASKS_APPBAR,
        onBack: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context, tempSelectedTasks),
            icon: Icon(
              Icons.check,
              color: DARK_PINK_COLOR,
            ),
          ),
        ],
      ),
      body: taskList(),
    );
  }

  Widget taskList() {
    return StreamBuilder<Tasks>(
      stream: _projectTaskBloc.getProjectTasksStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LinearLoader());
        }
        return snapshot.data!.tasks.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.04,
                  horizontal: width * 0.05,
                ),
                itemCount: snapshot.data!.tasks.length,
                itemBuilder: (context, index) {
                  final TaskModel task = snapshot.data!.tasks[index];
                  return TaskCard(
                    task: task,
                    selected: task.isSelected! ? true : false,
                    optionEnable: true,
                    onTapItem: () {
                      setState(() => task.isSelected = !task.isSelected!);
                      if (task.isSelected!) {
                        if (!tempSelectedTasks.contains(task)) {
                          tempSelectedTasks.add(task);
                        }
                      }
                    },
                    onTapDelete: () async => await onDelete(task),
                  );
                },
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  NO_TASKS_FOUND,
                  style: _theme.textTheme.bodyText2!
                      .copyWith(color: DARK_GRAY, fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  Future onEdit(TaskModel task) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CreateEditTask(
          fromEdit: true,
          task: task,
        ),
      ),
    );
    await _projectTaskBloc.getProjectAllTasks('');
  }

  Future onDelete(TaskModel task) async {
    Navigator.of(context).pop();
    CircularLoader().show(context);
    final ResponseModel response =
        await _projectTaskBloc.deleteTask(task.taskId!);
    if (response.success!) {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: TASK_DELETED_POPUP_MSG);
    } else {
      CircularLoader().hide(context);
      ScaffoldSnakBar().show(context, msg: SOMETHING_WENT_WRONG_POPUP_MSG);
    }
    await _projectTaskBloc.getProjectAllTasks('');
  }
}
