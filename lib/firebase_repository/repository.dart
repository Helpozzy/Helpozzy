import 'package:helpozzy/firebase_api_provider/api_provider.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/utils/constants.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<Schools> getSchoolsRepo() => apiProvider.getSchoolsAPIProvider();

  Future<bool> postSchoolsRepo(List schools) =>
      apiProvider.postSchoolsAPIProvider(schools);

  Future<VolunteerTypes> volunteerListRepo() =>
      apiProvider.volunteerListAPIProvider();

  Future<bool> postSignUpDetailsRepo(String uId, Map<String, dynamic> json) =>
      apiProvider.postSignUpAPIProvider(uId, json);

  Future<bool> postCategoriesRepo(List categories) =>
      apiProvider.postCategoriesAPIProvider(categories);

  Future<Categories> getCategoriesRepo() =>
      apiProvider.getCategoriesAPIProvider();

  Future<Projects> getuserProjectsRepo() =>
      apiProvider.getUserProjectsAPIProvider();

  Future<Projects> getuserCompletedProjectsRepo() =>
      apiProvider.getUserCompltedProjectsAPIProvider();

  Future<Projects> getCategorisedProjectsRepo(int categoryId) =>
      apiProvider.getCategorisedProjectsAPIProvider(categoryId);

  Future<UserModel> userInfoRepo(String uId) =>
      apiProvider.userInfoAPIProvider(uId);

  Future<Users> usersRepo(String uId) => apiProvider.usersAPIProvider(uId);

  //Admin Repo
  Future<AdminTypes> getAdminCategoriesRepo() =>
      apiProvider.getAdminCategoriesAPIProvider();

  Future<bool> postProjectRepo(ProjectModel project) =>
      apiProvider.postProjectAPIProvider(project);

  Future<Projects> getprojectsRepo({ProjectTabType? projectTabType}) =>
      apiProvider.getProjectsAPIProvider(projectTabType: projectTabType);

  Future<Users> getOtherUserInfoRepo() =>
      apiProvider.otherUserInfoAPIProvider();

  Future<bool> postTaskRepo(TaskModel task) =>
      apiProvider.postTaskAPIProvider(task);

  Future<bool> updateTaskRepo(TaskModel task) =>
      apiProvider.updateTaskAPIProvider(task);

  Future<Tasks> getProjectTasksRepo(String projectId) =>
      apiProvider.getProjectTasksAPIProvider(projectId);

  Future<Tasks> getSelectedTasksRepo(List<String> taskIds) =>
      apiProvider.getSelectedTasksAPIProvider(taskIds);

  Future<bool> deleteTaskRepo(String taskId) =>
      apiProvider.deleteTaskAPIProvider(taskId);
}
