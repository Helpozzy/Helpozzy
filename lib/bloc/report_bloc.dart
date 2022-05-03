import 'package:helpozzy/firebase_repository/repository.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/report_data_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class ReportBloc {
  final repo = Repository();

  final signedUpProjectsController = PublishSubject<List<ProjectModel>>();
  final projectDetailsExpandController = PublishSubject<bool>();
  final signedUpProjectCompletedTasks = PublishSubject<Tasks>();
  final filteredReportProjects = PublishSubject<List<ReportsDataModel>>();

  Stream<List<ProjectModel>> get getSignedUpProjectsStream =>
      signedUpProjectsController.stream;
  Stream<bool> get getProjectExpandStream =>
      projectDetailsExpandController.stream;
  Stream<Tasks> get getSignedUpProjectCompletedTaskStream =>
      signedUpProjectCompletedTasks.stream;
  Stream<List<ReportsDataModel>> get getFilteredReportProjectsTaskStream =>
      filteredReportProjects.stream;

  Future<List<ProjectModel>> getSignedUpProjects() async {
    final Projects response = await repo.getEnrolledProjectRepo();
    signedUpProjectsController.sink.add(response.projectList);
    return response.projectList;
  }

  Future getFilteredReportProjects(List<ReportsDataModel> projects) async {
    filteredReportProjects.sink.add(projects);
  }

  Future isExpanded(bool isExpanded) async {
    projectDetailsExpandController.sink.add(isExpanded);
  }

  Future getSignedUpProjectCompletedTasks(String projectId) async {
    final Tasks tasks =
        await repo.getSignedUpProjectCompletedTasksRepo(projectId);
    signedUpProjectCompletedTasks.sink.add(tasks);
  }

  void dispose() {
    signedUpProjectsController.close();
    projectDetailsExpandController.close();
    signedUpProjectCompletedTasks.close();
    filteredReportProjects.close();
  }
}
