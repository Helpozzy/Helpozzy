import 'package:helpozzy/firebase_api_provider/api_provider.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<VolunteerTypes> volunteerListRepo() =>
      apiProvider.volunteerListAPIProvider();

  Future<bool> postSignUpDetailsRepo(String uId, Map<String, dynamic> json) =>
      apiProvider.postSignUpAPIProvider(uId, json);

  Future<bool> postCategoriesRepo(List categories) =>
      apiProvider.postCategoriesAPIProvider(categories);

  Future<Categories> getCategoriesRepo() =>
      apiProvider.getCategoriesAPIProvider();

  Future<bool> postEventsRepo(List events) =>
      apiProvider.postEventAPIProvider(events);

  Future<Events> getEventsRepo() => apiProvider.getEventsAPIProvider();

  Future<Events> getCategorisedEventsRepo(int categoryId) =>
      apiProvider.getCategorisedEventsAPIProvider(categoryId);

  Future<UserModel> userInfoRepo(String uId) =>
      apiProvider.userInfoAPIProvider(uId);

  //Admin Repo
  Future<AdminTypes> getAdminTypesRepo() =>
      apiProvider.getAdminTypesAPIProvider();
}
