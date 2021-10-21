import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectTaskBloc {
  final repo = Repository();

  final tasksController = PublishSubject<Tasks>();
  final selectedTasksController = BehaviorSubject<List<TaskModel>>();

  Stream<Tasks> get getTasksStream => tasksController.stream;
  Stream<List<TaskModel>> get getSelectedTaskStream =>
      selectedTasksController.stream;

  Future<bool> postTasks(TaskModel task) async {
    final bool response = await repo.postTaskRepo(task);
    return response;
  }

  Future getTasks() async {
    final Tasks response = await repo.getTasksRepo();
    tasksController.sink.add(response);
  }

  Future getSelectedTasks({required List<TaskModel> tasks}) async {
    selectedTasksController.sink.add(tasks);
  }

  Future<bool> updateTasks(TaskModel task) async {
    final bool response = await repo.updateTaskRepo(task);
    return response;
  }

  Future<bool> deleteTask(String taskId) async {
    final bool response = await repo.deleteTaskRepo(taskId);
    return response;
  }

  void dispose() {
    tasksController.close();
    selectedTasksController.close();
  }
}
