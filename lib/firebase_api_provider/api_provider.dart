import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/admin_model/project_model.dart';
import 'package:helpozzy/models/admin_model/task_model.dart';
import 'package:helpozzy/models/admin_selection_model.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/utils/constants.dart';

class ApiProvider {
  Future<VolunteerTypes> volunteerListAPIProvider() async {
    final DocumentReference documentRefVolunteer =
        firestore.collection('volunteers').doc('volunteers');

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

  Future<bool> postCategoriesAPIProvider(List list) async {
    final DocumentReference documentRef =
        firestore.collection('eventCategories').doc('categories');
    await documentRef.set({'categories': list}).catchError((onError) {
      print(onError.toString());
    });
    return true;
  }

  Future<Categories> getCategoriesAPIProvider() async {
    final DocumentReference documentRef =
        firestore.collection('eventCategories').doc('categories');

    final DocumentSnapshot categoriesDoc = await documentRef.get();

    final Map<String, dynamic> categories =
        categoriesDoc.data() as Map<String, dynamic>;

    return Categories.fromJson(items: categories['categories']);
  }

  Future<bool> postEventAPIProvider(List list) async {
    list.forEach((event) async {
      await firestore.collection('events').add(event);
    });
    return true;
  }

  Future<Events> getEventsAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('events').get();

    List<QueryDocumentSnapshot<Object?>> eventList = querySnapshot.docs;
    List<Map<String, dynamic>> events = [];
    eventList.forEach((element) {
      final event = element.data() as Map<String, dynamic>;
      events.add(event);
    });
    return Events.fromJson(list: events);
  }

  Future<Events> getCategorisedEventsAPIProvider(int categoryId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('events')
        .where('category_id', isEqualTo: categoryId)
        .get();

    List<QueryDocumentSnapshot<Object?>> eventList = querySnapshot.docs;
    List<Map<String, dynamic>> events = [];
    eventList.forEach((element) {
      final event = element.data() as Map<String, dynamic>;
      events.add(event);
    });
    return Events.fromJson(list: events);
  }

  Future<UserModel> userInfoAPIProvider(String uId) async {
    final DocumentReference documentRef =
        firestore.collection('users').doc(uId);
    final DocumentSnapshot doc = await documentRef.get();
    final json = doc.data() as Map<String, dynamic>;
    return UserModel.fromjson(json: json);
  }

  //Admin API Provider

  Future<AdminTypes> getAdminTypesAPIProvider() async {
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
          firestore.collection('project').doc();
      project.projectId = documentReference.id;
      await documentReference.set(project.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Projects> getProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('project').get();

    List<QueryDocumentSnapshot<Object?>> projectsList = querySnapshot.docs;
    List<Map<String, dynamic>> projects = [];
    projectsList.forEach((element) {
      final task = element.data() as Map<String, dynamic>;
      projects.add(task);
    });
    return Projects.fromJson(list: projects);
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

  Future<Tasks> getTasksAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('tasks').get();

    List<QueryDocumentSnapshot<Object?>> tasksList = querySnapshot.docs;
    List<Map<String, dynamic>> tasks = [];
    tasksList.forEach((element) {
      final task = element.data() as Map<String, dynamic>;
      tasks.add(task);
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
