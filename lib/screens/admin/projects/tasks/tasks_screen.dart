import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/admin/projects/tasks/create_task.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();
  late double width;
  late ThemeData _themeData;

  @override
  void initState() {
    _projectTaskBloc.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SCREEN_BACKGROUND,
      appBar: CommonAppBar(context).show(
        title: 'Tasks',
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
                    CupertinoPageRoute(builder: (context) => CreateTask()),
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
          padding: EdgeInsets.symmetric(vertical: 10.0),
          itemCount: snapshot.data!.tasks.length,
          itemBuilder: (context, index) {
            final TaskModel task = snapshot.data!.tasks[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                title: Text(
                  task.taskName,
                  style: _themeData.textTheme.headline6!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  task.description,
                  style: _themeData.textTheme.bodyText2!
                      .copyWith(color: DARK_GRAY),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {},
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      child: Icon(Icons.delete),
                      onTap: () async {
                        CircularLoader().show(context);
                        final bool deleted =
                            await _projectTaskBloc.deleteTask(task.id);
                        if (deleted) {
                          CircularLoader().hide(context);
                          showSnakeBar(context, msg: 'Task deleted!');
                        } else {
                          CircularLoader().hide(context);
                          showSnakeBar(context, msg: 'Something went wrong!');
                        }
                        _projectTaskBloc.getTasks();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}