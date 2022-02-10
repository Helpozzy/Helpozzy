import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  final repo = Repository();

  final enrolledTasksController = PublishSubject<Tasks>();
  final tasksDetailsController = PublishSubject<TaskHelper>();
  final taskInfoController = PublishSubject<TaskModel>();

  Stream<Tasks> get getEnrolledTasksStream => enrolledTasksController.stream;
  Stream<TaskHelper> get getTaskDetailsStream => tasksDetailsController.stream;
  Stream<TaskModel> get getTaskInfoStream => taskInfoController.stream;

  Future getEnrolledTasks() async {
    final Tasks response = await repo.getEnrolledTasksRepo();
    enrolledTasksController.sink.add(response);
  }

  Future<bool> postEnrolledTask(TaskModel enrolledTaskModel) async {
    final bool response = await repo.postEnrolledTaskRepo(enrolledTaskModel);
    return response;
  }

  Future getTask(String taskId) async {
    final TaskModel response = await repo.getTaskInfoRepo(taskId);
    taskInfoController.sink.add(response);
  }

  Future<bool> updateEnrollTasks(TaskModel task) async {
    final bool response = await repo.updateEnrollTaskRepo(task);
    return response;
  }

  void dispose() {
    enrolledTasksController.close();
    tasksDetailsController.close();
    taskInfoController.close();
  }
}
