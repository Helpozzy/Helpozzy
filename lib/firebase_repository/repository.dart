import 'package:helpozzy/firebase_api_provider/api_provider.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/utils/constants.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<States> getStateRepo() => apiProvider.getStatesAPIProvider();

  Future<Cities> getCitiesByStateNameRepo(String stateName) =>
      apiProvider.getCitiesByStateNameAPIProvider(stateName);

  Future<Schools> getSchoolsRepo({String? state, String? city}) =>
      apiProvider.getSchoolsAPIProvider(state: state, city: city);

  Future<VolunteerTypes> volunteerListRepo() =>
      apiProvider.volunteerListAPIProvider();

  Future<bool> postSignUpDetailsRepo(String uId, Map<String, dynamic> json) =>
      apiProvider.postSignUpAPIProvider(uId, json);

  Future<bool> postEditProfileDetailsRepo(Map<String, dynamic> json) =>
      apiProvider.editProfileAPIProvider(json);

  Future<Projects> getuserCompletedProjectsRepo() =>
      apiProvider.getUserCompltedProjectsAPIProvider();

  Future<Projects> getCategorisedProjectsRepo(int categoryId) =>
      apiProvider.getCategorisedProjectsAPIProvider(categoryId);

  Future<SignUpAndUserModel> userInfoRepo(String uId) =>
      apiProvider.userInfoAPIProvider(uId);

  Future<Users> usersRepo(String uId) => apiProvider.usersAPIProvider(uId);

  Future<ResponseModel> postProjectSignupRepo(ProjectModel projectSignUpVal) =>
      apiProvider.postProjectSignupAPIProvider(projectSignUpVal);

  Future<ResponseModel> postProjectRepo(ProjectModel project) =>
      apiProvider.postProjectAPIProvider(project);

  Future<Projects> getprojectsRepo({ProjectTabType? projectTabType}) =>
      apiProvider.getProjectsAPIProvider(projectTabType: projectTabType);

  Future<Users> getOtherUserInfoRepo() =>
      apiProvider.otherUserInfoAPIProvider();

  Future<ResponseModel> postTaskRepo(TaskModel task) =>
      apiProvider.postTaskAPIProvider(task);

  Future<ResponseModel> updateTaskRepo(TaskModel task) =>
      apiProvider.updateTaskAPIProvider(task);

  Future<ResponseModel> deleteTaskRepo(String taskId) =>
      apiProvider.deleteTaskAPIProvider(taskId);

  Future<Tasks> getProjectTasksRepo(String projectId, bool isOwn) =>
      apiProvider.getProjectTasksAPIProvider(projectId, isOwn);

  Future<ResponseModel> updateEnrolledProjectRepo(ProjectModel project) =>
      apiProvider.updateEnrolledProjectAPIProvider(project);

  Future<Projects> getEnrolledProjectRepo() =>
      apiProvider.getEnrolledProjectsAPIProvider();

  Future<Tasks> getProjectEnrolledTasksRepo(String projectId, bool isOwn) =>
      apiProvider.getProjectEnrolledTasksAPIProvider(projectId, isOwn);

  Future<Tasks> getEnrolledTasksRepo() =>
      apiProvider.getEnrolledTasksAPIProvider();

  Future<ResponseModel> updateEnrollTaskRepo(TaskModel task) =>
      apiProvider.updateEnrollTaskAPIProvider(task);

  Future<ResponseModel> postEnrolledTaskRepo(TaskModel enrolledTaskModel) =>
      apiProvider.postEnrolledTasksAPIProvider(enrolledTaskModel);

  Future<TaskModel> getTaskInfoRepo(String taskId) =>
      apiProvider.getTaskInfoAPIProvider(taskId);

  Future<Tasks> getSelectedTasksRepo(List<String> taskIds) =>
      apiProvider.getSelectedTasksAPIProvider(taskIds);

  Future<bool> postReviewRepo(ReviewModel review) =>
      apiProvider.postReviewAPIProvider(review);

  Future<Reviews> getProjectReviewsRepo(String projectId) =>
      apiProvider.getProjectReviewsAPIProvider(projectId);

  //Notification API provider
  Future<Notifications> getNotificationsRepo() =>
      apiProvider.getNotificationsAPIProvider();

  Future<ResponseModel> updateNotificationRepo(
          NotificationModel notification) =>
      apiProvider.updateNotificationAPIProvider(notification);

  Future<ResponseModel> postNotificationRepo(NotificationModel notification) =>
      apiProvider.postNotificationAPIProvider(notification);

  Future<ResponseModel> removeNotificationRepo(String id) =>
      apiProvider.removeNotificationAPIProvider(id);
}
