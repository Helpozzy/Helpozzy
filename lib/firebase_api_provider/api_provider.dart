import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/utils/constants.dart';

class ApiProvider {
  Future<bool> postCitiesAPIProvider(List cities) async {
    for (int i = 0; i <= cities.length; i++) {
      final DocumentReference documentReference =
          firestore.collection('cities_info').doc();
      await documentReference.set(cities[i]);
    }
    return true;
  }

  Future<States> getCitiesAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('states').get();

    List<QueryDocumentSnapshot<Object?>> cityList = querySnapshot.docs;
    List<Map<String, dynamic>> cities = [];
    cityList.forEach((element) {
      final Map<String, dynamic> city = element.data() as Map<String, dynamic>;
      cities.add(city);
    });

    return States.fromJson(items: cities);
  }

  Future<Cities> getCitiesByStateNameAPIProvider(String stateName) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('cities_info')
        .where('state_name', isEqualTo: stateName)
        .get();

    List<QueryDocumentSnapshot<Object?>> cityList = querySnapshot.docs;
    List<Map<String, dynamic>> cities = [];
    cityList.forEach((element) {
      final Map<String, dynamic> city = element.data() as Map<String, dynamic>;
      cities.add(city);
    });

    return Cities.fromJson(items: cities);
  }

  Future<bool> postSchoolsAPIProvider(List schools) async {
    for (int i = 0; i <= schools.length; i++) {
      final DocumentReference documentReference =
          firestore.collection('schools_info').doc();
      await documentReference.set(schools[i]);
    }
    return true;
  }

  Future<Schools> getSchoolsAPIProvider({String? state, String? city}) async {
    firestore.settings.copyWith(persistenceEnabled: false, sslEnabled: true);

    final QuerySnapshot querySnapshot =
        (state != null && state.isNotEmpty) && (city != null && city.isNotEmpty)
            ? await firestore
                .collection('schools_info')
                .where('state', isEqualTo: state)
                .get()
            : (state != null && state.isNotEmpty)
                ? await firestore
                    .collection('schools_info')
                    .where('state', isEqualTo: state)
                    .get()
                : await firestore.collection('schools_info').get();

    List<QueryDocumentSnapshot<Object?>> schoolList = querySnapshot.docs;
    List<Map<String, dynamic>> schools = [];
    schoolList.forEach((element) {
      final project = element.data() as Map<String, dynamic>;
      schools.add(project);
    });
    return Schools.fromJson(list: schools);
  }

  Future<VolunteerTypes> volunteerListAPIProvider() async {
    final DocumentReference documentRefVolunteer =
        firestore.collection('volunteers_types').doc('volunteers_types');

    final DocumentSnapshot volunteersJsonData =
        await documentRefVolunteer.get();

    final Map<String, dynamic> volunteers =
        volunteersJsonData.data() as Map<String, dynamic>;

    return VolunteerTypes.fromJson(volunteers['volunteer']);
  }

  Future<bool> postSignUpAPIProvider(
      String uId, Map<String, dynamic> json) async {
    final DocumentReference documentRef =
        firestore.collection('users').doc(uId);
    await documentRef.set(json).catchError((onError) {
      print(onError.toString());
    });
    return true;
  }

  Future<bool> editProfileAPIProvider(Map<String, dynamic> json) async {
    final DocumentReference documentRef =
        firestore.collection('users').doc(prefsObject.getString('uID'));
    await documentRef.update(json).catchError((onError) {
      print(onError.toString());
    });
    return true;
  }

  Future<bool> postCategoriesAPIProvider(List list) async {
    final DocumentReference documentRef =
        firestore.collection('projects_categories').doc('categories');
    await documentRef.set({'categories': list}).catchError((onError) {
      print(onError.toString());
    });
    return true;
  }

  Future<Categories> getCategoriesAPIProvider() async {
    final DocumentReference documentRef =
        firestore.collection('projects_categories').doc('categories');

    final DocumentSnapshot categoriesDoc = await documentRef.get();

    final Map<String, dynamic> json =
        categoriesDoc.data() as Map<String, dynamic>;

    return Categories.fromJson(items: json['categories']);
  }

  Future<Projects> getUserProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('projects').get();

    List<QueryDocumentSnapshot<Object?>> projectList = querySnapshot.docs;
    List<Map<String, dynamic>> projects = [];
    projectList.forEach((element) {
      final project = element.data() as Map<String, dynamic>;
      projects.add(project);
    });
    return Projects.fromJson(list: projects);
  }

  Future<Projects> getUserCompltedProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('project_owner',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<QueryDocumentSnapshot<Object?>> projectList = querySnapshot.docs;
    List<Map<String, dynamic>> projects = [];
    projectList.forEach((element) {
      final project = element.data() as Map<String, dynamic>;
      projects.add(project);
    });
    return Projects.fromJson(list: projects);
  }

  Future<Projects> getCategorisedProjectsAPIProvider(int categoryId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('category_id', isEqualTo: categoryId)
        .get();

    List<QueryDocumentSnapshot<Object?>> projectList = querySnapshot.docs;
    List<Map<String, dynamic>> projects = [];
    projectList.forEach((element) {
      final project = element.data() as Map<String, dynamic>;
      projects.add(project);
    });
    return Projects.fromJson(list: projects);
  }

  Future<SignUpAndUserModel> userInfoAPIProvider(String uId) async {
    final DocumentReference documentRef =
        firestore.collection('users').doc(uId);
    final DocumentSnapshot doc = await documentRef.get();
    final json = doc.data() as Map<String, dynamic>;
    return SignUpAndUserModel.fromJson(json: json);
  }

  Future<Users> usersAPIProvider(String uId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('user_id', isNotEqualTo: uId)
        .get();
    List<QueryDocumentSnapshot<Object?>> userList = querySnapshot.docs;
    return Users.fromJson(list: userList);
  }

  //Admin API Provider

  Future<AdminTypes> getAdminCategoriesAPIProvider() async {
    final DocumentReference documentRef =
        firestore.collection('admin').doc('adminTypes');

    final DocumentSnapshot categoriesDoc = await documentRef.get();

    final Map<String, dynamic> categories =
        categoriesDoc.data() as Map<String, dynamic>;

    return AdminTypes.fromJson(items: categories['admin_types']);
  }

  Future<bool> postProjectAPIProvider(ProjectModel project) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('projects').doc();
      project.projectId = documentReference.id;
      await documentReference.set(project.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Projects> getProjectsAPIProvider(
      {ProjectTabType? projectTabType}) async {
    final QuerySnapshot querySnapshot =
        projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
            ? await firestore
                .collection('projects')
                .where('status', isEqualTo: PROJECT_NOT_STARTED)
                .get()
            : projectTabType == ProjectTabType.PROJECT_INPROGRESS_TAB
                ? await firestore
                    .collection('projects')
                    .where('status', isEqualTo: PROJECT_IN_PROGRESS)
                    .get()
                : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                    ? await firestore
                        .collection('projects')
                        .where('status', isEqualTo: PROJECT_COMPLTED)
                        .get()
                    : projectTabType ==
                            ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                        ? await firestore.collection('projects').get()
                        : await firestore
                            .collection('projects')
                            // .where('project_owner',
                            //     isNotEqualTo: prefsObject.getString('uID')!)
                            .get();

    List<QueryDocumentSnapshot<Object?>> projectsList = querySnapshot.docs;
    List<Map<String, dynamic>> projects = [];
    projectsList.forEach((element) {
      final task = element.data() as Map<String, dynamic>;
      projects.add(task);
    });
    return Projects.fromJson(list: projects);
  }

  Future<Users> otherUserInfoAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('users').get();
    return Users.fromJson(list: querySnapshot.docs);
  }

  Future<bool> postTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('tasks').doc();
      task.id = documentReference.id;
      await documentReference.set(task.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('tasks').doc(task.id);
      await documentReference.update(task.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Tasks> getProjectTasksAPIProvider(String projectId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('tasks')
        .where('project_id', isEqualTo: projectId)
        .get();

    List<QueryDocumentSnapshot<Object?>> tasksList = querySnapshot.docs;
    List<Map<String, dynamic>> tasks = [];
    tasksList.forEach((json) {
      final task = json.data() as Map<String, dynamic>;
      tasks.add(task);
    });
    return Tasks.fromJson(list: tasks);
  }

  Future<Tasks> getSelectedTasksAPIProvider(List<String> taskIds) async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('tasks').get();

    List<QueryDocumentSnapshot<Object?>> tasksList = querySnapshot.docs;
    List<Map<String, dynamic>> tasks = [];
    tasksList.forEach((element) {
      final Map<String, dynamic> task = element.data() as Map<String, dynamic>;

      if (taskIds.contains(task['task_id'])) {
        tasks.add(task);
      }
    });
    return Tasks.fromJson(list: tasks);
  }

  Future<bool> deleteTaskAPIProvider(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
