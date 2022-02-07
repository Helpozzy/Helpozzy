import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  final repo = Repository();

  final enrolledTasksController = PublishSubject<Tasks>();
  final tasksDetailsController = PublishSubject<ProjectTaskHelper>();

  Stream<Tasks> get getEnrolledTasksStream => enrolledTasksController.stream;

  Stream<ProjectTaskHelper> get getTaskDetailsStream =>
      tasksDetailsController.stream;

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

  Future<bool> updateTasks(TaskModel task) async {
    final bool response = await repo.updateTaskRepo(task);
    return response;
  }

  void dispose() {
    enrolledTasksController.close();
    tasksDetailsController.close();
  }
}
