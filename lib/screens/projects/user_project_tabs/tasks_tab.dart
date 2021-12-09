import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/project_task_bloc.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/screens/tasks/task_widget.dart';
import 'package:helpozzy/screens/user/explore/user_project/project_task/task_details.dart';
import 'package:helpozzy/utils/constants.dart';
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
  late ThemeData _theme;
  late double height;
  late double width;
  late bool myTaskIsExpanded = false;
  final ProjectTaskBloc _projectTaskBloc = ProjectTaskBloc();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(body: taskDivisions());
  }

  Widget taskDivisions() {
    return SingleChildScrollView(
      child: Column(
        children: [
          tasksCategoriesCard(
            prefixWidget: CommonUserPlaceholder(size: width / 10),
            label: 'My Tasks',
            counter: '3',
            isMyTask: true,
          ),
          tasksCategoriesCard(
            prefixWidget: Icon(
              CupertinoIcons.square_list,
              size: width / 12,
              color: BLUE_GRAY,
            ),
            label: 'View all Tasks',
            counter: '6',
            isMyTask: false,
          ),
        ],
      ),
    );
  }

  Widget tasksCategoriesCard(
      {required Widget prefixWidget,
      required String label,
      required String counter,
      required bool isMyTask}) {
    return StreamBuilder<bool>(
        initialData: isMyTask ? myTaskIsExpanded : false,
        stream: _projectTaskBloc.getMyTaskExpandedStream,
        builder: (context, myTaskExpandedSnapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
            child: InkWell(
              onTap: () {
                if (isMyTask) {
                  setState(() => myTaskIsExpanded = !myTaskIsExpanded);
                  _projectTaskBloc.isExpanded(myTaskIsExpanded);
                  _projectTaskBloc.getProjectTasks(project.projectId);
                } else {}
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              prefixWidget,
                              SizedBox(width: 8),
                              Text(
                                label,
                                style: _theme.textTheme.bodyText2!.copyWith(
                                  color: DARK_PINK_COLOR,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                counter,
                                style: _theme.textTheme.bodyText2!.copyWith(
                                  color: DARK_PINK_COLOR,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                isMyTask
                                    ? myTaskExpandedSnapshot.data!
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                      isMyTask
                          ? myTaskExpandedSnapshot.data!
                              ? tasksOfProject()
                              : SizedBox()
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget tasksOfProject() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
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
