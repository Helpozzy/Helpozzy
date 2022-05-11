import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/helper/task_helper.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectTaskBloc {
  final repo = Repository();

  final myTaskExpandController = PublishSubject<bool>();
  final allTaskExpandController = PublishSubject<bool>();
  final projectEnrolledTasksController = PublishSubject<Tasks>();
  final projectTasksController = PublishSubject<Tasks>();
  final projectTasksDetailsController = PublishSubject<TasksStatusHelper>();
  final selectedTasksController = PublishSubject<List<TaskModel>>();

  Stream<bool> get getMyTaskExpandedStream => myTaskExpandController.stream;
  Stream<bool> get geAllTaskExpandedStream => allTaskExpandController.stream;
  Stream<Tasks> get getProjectEnrolledTasksStream =>
      projectEnrolledTasksController.stream;
  Stream<Tasks> get getProjectTasksStream => projectTasksController.stream;
  Stream<TasksStatusHelper> get getProjectTaskDetailsStream =>
      projectTasksDetailsController.stream;
  Stream<List<TaskModel>> get getSelectedTasksStream =>
      selectedTasksController.stream;

  Future myTaskIsExpanded(bool expand) async {
    myTaskExpandController.sink.add(expand);
  }

  Future allTaskIsExpanded(bool expand) async {
    allTaskExpandController.sink.add(expand);
  }

  Future<ResponseModel> postTask(TaskModel task) async {
    final ResponseModel response = await repo.postTaskRepo(task);
    return response;
  }

  Future getProjectEnrolledTasks(String projectId) async {
    final Tasks response =
        await repo.getProjectEnrolledTasksRepo(projectId, true);
    projectEnrolledTasksController.sink.add(response);
  }

  Future getProjectAllTasks(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, false);
    projectTasksController.sink.add(response);
  }

  Future getProjectTaskDetails(String projectId) async {
    final Tasks response = await repo.getProjectTasksRepo(projectId, false);
    final TasksStatusHelper projectHelper =
        TasksStatusHelper(tasks: response.tasks);
    projectTasksDetailsController.sink.add(projectHelper);
  }

  Future getSelectedTasks({required List<TaskModel> tasks}) async {
    selectedTasksController.sink.add(tasks);
  }

  Future<ResponseModel> updateTask(TaskModel task) async {
    final ResponseModel response = await repo.updateTaskRepo(task);
    return response;
  }

  Future<ResponseModel> removeEnrolledTask(String enrolledTaskId) async {
    final ResponseModel response =
        await repo.removeEnrolledTaskRepo(enrolledTaskId);
    return response;
  }

  Future<ResponseModel> deleteTask(String taskId) async {
    final ResponseModel response = await repo.deleteTaskRepo(taskId);
    return response;
  }

  void dispose() {
    myTaskExpandController.close();
    allTaskExpandController.close();
    selectedTasksController.close();
    projectEnrolledTasksController.close();
    projectTasksController.close();
    projectTasksDetailsController.close();
  }
}
