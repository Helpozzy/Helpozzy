import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  final repo = Repository();

  final enrolledTasksController = PublishSubject<Tasks>();
  final tasksDetailsController = PublishSubject<ProjectTaskHelper>();
  final taskInfoController = PublishSubject<TaskModel>();

  Stream<Tasks> get getEnrolledTasksStream => enrolledTasksController.stream;
  Stream<ProjectTaskHelper> get getTaskDetailsStream =>
      tasksDetailsController.stream;
  Stream<TaskModel> get getTaskInfoStream => taskInfoController.stream;

  Future getEnrolledTasks() async {
    final Tasks response = await repo.getEnrolledTasksRepo();
    enrolledTasksController.sink.add(response);
  }

  Future getProjectTaskDetails(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, false);
    final ProjectTaskHelper projectHelper =
        ProjectTaskHelper.fromProject(response.tasks);
    tasksDetailsController.sink.add(projectHelper);
  }

  Future getTask(String taskId) async {
    final TaskModel response = await repo.getTaskInfoRepo(taskId);
    taskInfoController.sink.add(response);
  }

  Future<bool> updateTasks(TaskModel task) async {
    final bool response = await repo.updateTaskRepo(task);
    return response;
  }

  void dispose() {
    enrolledTasksController.close();
    tasksDetailsController.close();
    taskInfoController.close();
  }
}
