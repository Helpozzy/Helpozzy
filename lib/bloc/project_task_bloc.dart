import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_Helper.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectTaskBloc {
  final repo = Repository();

  final myTaskExpandController = PublishSubject<bool>();
  final projectTasksController = PublishSubject<Tasks>();
  final projectTasksDetailsController = PublishSubject<ProjectTaskHelper>();
  final selectedTasksController = BehaviorSubject<List<TaskModel>>();

  Stream<bool> get getMyTaskExpandedStream => myTaskExpandController.stream;
  Stream<Tasks> get getProjectTasksStream => projectTasksController.stream;
  Stream<ProjectTaskHelper> get getProjectTaskDetailsStream =>
      projectTasksDetailsController.stream;
  Stream<List<TaskModel>> get getSelectedTaskStream =>
      selectedTasksController.stream;

  Future isExpanded(bool expand) async {
    myTaskExpandController.sink.add(expand);
  }

  Future<bool> postTasks(TaskModel task) async {
    final bool response = await repo.postTaskRepo(task);
    return response;
  }

  Future getProjectTasks(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId);
    projectTasksController.sink.add(response);
  }

  Future getProjectTaskDetails(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId);
    final ProjectTaskHelper projectHelper =
        ProjectTaskHelper.fromProject(response.tasks);
    projectTasksDetailsController.sink.add(projectHelper);
  }

  Future getSelectedTasks({required List<TaskModel> tasks}) async {
    selectedTasksController.sink.add(tasks);
  }

  Future<bool> updateTasks(TaskModel task) async {
    final bool response = await repo.updateTaskRepo(task);
    return response;
  }

  Future<bool> updateTaskKeyValue({
    required String taskId,
    required String key,
    required String val,
  }) async {
    final bool response = await repo.updateTaskKeyValueRepo(taskId, key, val);
    return response;
  }

  Future<bool> deleteTask(String taskId) async {
    final bool response = await repo.deleteTaskRepo(taskId);
    return response;
  }

  void dispose() {
    myTaskExpandController.close();
    selectedTasksController.close();
    projectTasksController.close();
    projectTasksDetailsController.close();
  }
}