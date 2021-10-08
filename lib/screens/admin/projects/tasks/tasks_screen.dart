import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/admin/projects/tasks/create_edit_task.dart';
import 'package:helpozzy/screens/admin/projects/tasks/task_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  late double width;
  late List<String> selectedItems = [];

  @override
  void initState() {
    _projectTaskBloc.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(context).show(
        title: 'Tasks',
        onBackPressed: () {
          Navigator.pop(context, selectedItems);
        },
        actions: [
          Transform.scale(
            scale: 0.6,
            child: Container(
              width: width / 4,
              child: CommonButton(
                text: 'Create',
                color: WHITE,
                elevation: 0,
                fontColor: PRIMARY_COLOR,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => CreateEditTask(fromEdit: false)),
                  );
                  await _projectTaskBloc.getTasks();
                },
              ),
            ),
          ),
        ],
      ),
      body: taskList(),
    );
  }

  Widget taskList() {
    return StreamBuilder<Tasks>(
      stream: _projectTaskBloc.getTasksStream,
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
              title: task.taskName,
              description: task.description,
              selected: task.isSelected! ? true : false,
              optionEnable: true,
              onLongPressItem: () {},
              onTapItem: () {
                setState(() {
                  task.isSelected = !task.isSelected!;
                });
                if (task.isSelected!) {
                  selectedItems.add(task.id);
                }
              },
              onTapEdit: () async => await onEdit(task),
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
    await _projectTaskBloc.getTasks();
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
    await _projectTaskBloc.getTasks();
  }
}
