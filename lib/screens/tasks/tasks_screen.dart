import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/tasks/create_edit_task.dart';
import 'package:helpozzy/screens/tasks/task_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  late double width;
  late List<TaskModel> selectedItems = [];

  @override
  void initState() {
    _projectTaskBloc.getProjectTasks('9pAPDbwbmKhrORI1RXWb');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CommonAppBar(context).show(
        elevation: 0,
        title: TASKS_APPBAR,
        onBackPressed: () {
          Navigator.pop(context);
        },
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, _projectTaskBloc);
              _projectTaskBloc.getSelectedTasks(tasks: selectedItems);
            },
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
          return Center(
            child: LinearLoader(minheight: 13),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              vertical: width * 0.04, horizontal: width * 0.05),
          itemCount: snapshot.data!.tasks.length,
          itemBuilder: (context, index) {
            final TaskModel task = snapshot.data!.tasks[index];
            return TaskCard(
              task: task,
              selected: task.isSelected! ? true : false,
              optionEnable: true,
              onTapItem: () {
                setState(() {
                  task.isSelected = !task.isSelected!;
                });
                if (task.isSelected!) {
                  selectedItems.add(task);
                }
              },
              onTapDelete: () async => await onDelete(task),
            );
          },
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
    await _projectTaskBloc.getProjectTasks('');
  }

  Future onDelete(TaskModel task) async {
    CircularLoader().show(context);
    final bool deleted = await _projectTaskBloc.deleteTask(task.id);
    if (deleted) {
      CircularLoader().hide(context);
      showSnakeBar(context, msg: 'Task deleted!');
    } else {
      CircularLoader().hide(context);
      showSnakeBar(context, msg: 'Something went wrong!');
    }
    await _projectTaskBloc.getProjectTasks('');
  }
}
