import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectTaskBloc {
  final repo = Repository();

  final tasksController = PublishSubject<Tasks>();

  Stream<Tasks> get getTasksStream => tasksController.stream;

  Future<bool> postTasks(TaskModel task) async {
    final bool response = await repo.postTaskRepo(task);
    return response;
  }

  Future getTasks() async {
    final Tasks response = await repo.getTasksRepo();
    tasksController.sink.add(response);
  }

  Future<bool> deleteTask(String taskId) async {
    final bool response = await repo.deleteTaskRepo(taskId);
    return response;
  }

  void dispose() {
    tasksController.close();
  }
}