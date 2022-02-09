import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/enrolled_task_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  final repo = Repository();

  final enrolledTasksController = PublishSubject<EnrolledTasks>();
  final tasksDetailsController = PublishSubject<ProjectTaskHelper>();
  final taskInfoController = PublishSubject<TaskModel>();

  Stream<EnrolledTasks> get getEnrolledTasksStream =>
      enrolledTasksController.stream;
  Stream<ProjectTaskHelper> get getTaskDetailsStream =>
      tasksDetailsController.stream;
  Stream<TaskModel> get getTaskInfoStream => taskInfoController.stream;

  Future getEnrolledTasks() async {
    final EnrolledTasks response = await repo.getEnrolledTasksRepo();
    enrolledTasksController.sink.add(response);
  }

  Future getProjectTaskDetails(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, false);
    final ProjectTaskHelper projectHelper =
        ProjectTaskHelper.fromProject(response.tasks);
    tasksDetailsController.sink.add(projectHelper);
  }

  Future<bool> postEnrolledTask(EnrolledTaskModel enrolledTaskModel) async {
    final bool response = await repo.postEnrolledTaskRepo(enrolledTaskModel);
    return response;
  }

  Future getTask(String taskId) async {
    final TaskModel response = await repo.getTaskInfoRepo(taskId);
    taskInfoController.sink.add(response);
  }

  Future<bool> updateEnrollTasks(EnrolledTaskModel task) async {
    final bool response = await repo.updateEnrollTaskRepo(task);
    return response;
  }

  void dispose() {
    enrolledTasksController.close();
    tasksDetailsController.close();
    taskInfoController.close();
  }
}
