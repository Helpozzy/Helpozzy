import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/admin/admin_project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/tasks/task_widget.dart';
import 'package:helpozzy/screens/user/explore/user_project/project_task/task_details.dart';
import 'package:helpozzy/widget/common_widget.dart';

class TaskTab extends StatefulWidget {
  TaskTab({required this.project});
  final ProjectModel project;
  @override
  _TaskTabState createState() => _TaskTabState(project: project);
}

class _TaskTabState extends State<TaskTab> {
  _TaskTabState({required this.project});
  final ProjectModel project;
  late double height;
  late double width;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  @override
  void initState() {
    _projectTaskBloc.getProjectTasks(project.projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return tasksOfProject();
  }

  Widget tasksOfProject() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: StreamBuilder<Tasks>(
        stream: _projectTaskBloc.getProjectTasksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: width * 0.04),
              child: LinearLoader(minheight: 12),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 5),
            itemCount: snapshot.data!.tasks.length,
            itemBuilder: (context, index) {
              final TaskModel task = snapshot.data!.tasks[index];
              return TaskCard(
                task: task,
                optionEnable: false,
                onTapItem: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetails(task: task),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
