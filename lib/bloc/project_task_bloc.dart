import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_Helper.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectTaskBloc {
  final repo = Repository();

  final myTaskExpandController = PublishSubject<bool>();
  final allTaskExpandController = PublishSubject<bool>();
  final projectOwnTasksController = PublishSubject<Tasks>();
  final projectAllTasksController = PublishSubject<Tasks>();
  final projectTasksDetailsController = PublishSubject<ProjectTaskHelper>();
  final selectedTasksController = BehaviorSubject<List<TaskModel>>();

  Stream<bool> get getMyTaskExpandedStream => myTaskExpandController.stream;
  Stream<bool> get geAllTaskExpandedStream => allTaskExpandController.stream;
  Stream<Tasks> get getProjectOwnTasksStream =>
      projectOwnTasksController.stream;
  Stream<Tasks> get getProjectAllTasksStream =>
      projectAllTasksController.stream;
  Stream<ProjectTaskHelper> get getProjectTaskDetailsStream =>
      projectTasksDetailsController.stream;
  Stream<List<TaskModel>> get getSelectedTaskStream =>
      selectedTasksController.stream;

  Future myTaskIsExpanded(bool expand) async {
    myTaskExpandController.sink.add(expand);
  }

  Future allTaskIsExpanded(bool expand) async {
    allTaskExpandController.sink.add(expand);
  }

  Future<bool> postTasks(TaskModel task) async {
    final bool response = await repo.postTaskRepo(task);
    return response;
  }

  Future getProjectOwnTasks(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, true);
    projectOwnTasksController.sink.add(response);
  }

  Future getProjectAllTasks(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, false);
    projectAllTasksController.sink.add(response);
  }

  Future getProjectTaskDetails(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, false);
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
    allTaskExpandController.close();
    selectedTasksController.close();
    projectOwnTasksController.close();
    projectAllTasksController.close();
    projectTasksDetailsController.close();
  }
}
