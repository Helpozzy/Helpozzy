import 'package:helpozzy/firebase_api_provider/api_provider.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/message_model.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
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

  Future<ResponseModel> postSignUpDetailsRepo(
          SignUpAndUserModel signupAndUserModel) =>
      apiProvider.postSignUpAPIProvider(signupAndUserModel);

  Future<ResponseModel> postEditProfileDetailsRepo(Map<String, dynamic> json) =>
      apiProvider.editProfileAPIProvider(json);

  Future<ResponseModel> updateTotalSpentHrsRepo(String signUpUserId, int hrs) =>
      apiProvider.updateTotalSpentHrsAPIProvider(signUpUserId, hrs);

  Future<Projects> getuserCompletedProjectsRepo() =>
      apiProvider.getUserCompltedProjectsAPIProvider();

  Future<Projects> getCategorisedProjectsRepo(int categoryId) =>
      apiProvider.getCategorisedProjectsAPIProvider(categoryId);

  Future<Projects> getCategorisedSignUpProjectsRepo(int categoryId) =>
      apiProvider.getCategorisedSignedUpProjectsAPIProvider(categoryId);

  Future<SignUpAndUserModel> userInfoRepo(String uId) =>
      apiProvider.userInfoAPIProvider(uId);

  Future<ResponseModel> updateUserPresenceRepo(
          String timeStamp, bool presence) =>
      apiProvider.updateUserPresenceAPIProvider(timeStamp, presence);

  Future<Users> usersRepo(String uId) => apiProvider.usersAPIProvider(uId);

  Future<ResponseModel> postProjectSignupRepo(ProjectModel projectSignUpVal) =>
      apiProvider.postProjectSignupAPIProvider(projectSignUpVal);

  Future<ResponseModel> postProjectRepo(ProjectModel project) =>
      apiProvider.postProjectAPIProvider(project);

  Future<ResponseModel> updateProjectRepo(ProjectModel project) =>
      apiProvider.updateProjectAPIProvider(project);

  Future<ResponseModel> updateEnrolledProjectHrsRepo(
          String signupUserId, String projectId, int hrs) =>
      apiProvider.updateEnrolledProjectHrsAPIProvider(
          signupUserId, projectId, hrs);

  Future<ResponseModel> deleteProjectRepo(String projectId) =>
      apiProvider.deleteProjectAPIProvider(projectId);

  Future<ResponseModel> removeNoLongerAvailProjectRepo() =>
      apiProvider.removeNoLongerAvailProjectAPIProvider();

  Future<Projects> getprojectsRepo({ProjectTabType? projectTabType}) =>
      apiProvider.getProjectsAPIProvider(projectTabType: projectTabType);

  Future<ProjectModel> getSignedUpProjectByProjectIdRepo(
          String projectId, String signUpUserId) =>
      apiProvider.getSignedUpProjectByProjectIdAPIProvider(
          projectId, signUpUserId);

  Future<ProjectModel> getProjectByProjectIdRepo(String projectId) =>
      apiProvider.getProjectByProjectIdAPIProvider(projectId);

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

  Future<Tasks> getSignedUpProjectCompletedTasksRepo(String projectId) =>
      apiProvider.getSignedUpProjectCompletedTasksAPIProvider(projectId);

  Future<ResponseModel> updateEnrolledProjectRepo(ProjectModel project) =>
      apiProvider.updateEnrolledProjectAPIProvider(project);

  Future<ResponseModel> removeEnrolledProjectRepo(String enrolledProjectId) =>
      apiProvider.removeEnrolledProjectAPIProvider(enrolledProjectId);

  Future<ResponseModel> removeEnrolledTaskRepo(String enrolledTaskId) =>
      apiProvider.removeEnrolledTaskAPIProvider(enrolledTaskId);

  Future<Projects> getEnrolledProjectRepo() =>
      apiProvider.getEnrolledProjectsAPIProvider();

  Future<Tasks> getProjectEnrolledTasksRepo(String projectId, bool isOwn) =>
      apiProvider.getProjectEnrolledTasksAPIProvider(projectId, isOwn);

  Future<Tasks> getEnrolledTasksRepo() =>
      apiProvider.getEnrolledTasksAPIProvider();

  Future<ResponseModel> updateEnrollTaskRepo(TaskModel task) =>
      apiProvider.updateEnrollTaskAPIProvider(task);

  Future<ResponseModel> removeEnrollTaskRepo(String enrollTaskId) =>
      apiProvider.removeEnrollTaskAPIProvider(enrollTaskId);

  Future<ResponseModel> postEnrolledTaskRepo(TaskModel enrolledTaskModel) =>
      apiProvider.postEnrolledTasksAPIProvider(enrolledTaskModel);

  Future<TaskModel> getTaskInfoRepo(String taskId) =>
      apiProvider.getTaskInfoAPIProvider(taskId);

  Future<Tasks> getSelectedTasksRepo(List<String> taskIds) =>
      apiProvider.getSelectedTasksAPIProvider(taskIds);

  Future<ResponseModel> postReviewRepo(ReviewModel review) =>
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

  //Chat API provider
  Future<ChatList> getProjectChatHistoryRepo(String projectId) =>
      apiProvider.getProjectChatHistory(projectId);

  Future<Chats> getProjectMessagesRepo(
          String projectId, String groupChatId, int limit) =>
      apiProvider.getProjectMessages(projectId, groupChatId, limit);

  //OneToOne Chat
  Future<ChatList> getOneToOneChatHistoryRepo(String groupChatId) =>
      apiProvider.getOneToOneChatHistory(groupChatId);

  Future<Chats> getOneToOneMessagesRepo(String groupChatId, int limit) =>
      apiProvider.getOneToOneMessages(groupChatId, limit);

  Future<Chats> getGroupMessagesRepo(String projectId, int limit) =>
      apiProvider.getGroupMessages(projectId, limit);
}
