import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/project_sign_up_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/review_model.dart';
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
                .where('city', isEqualTo: city)
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
    final DocumentReference documentRef = firestore
        .collection('users')
        .doc(prefsObject.getString(CURRENT_USER_ID));
    await documentRef.update(json).catchError((onError) {
      print(onError.toString());
    });
    return true;
  }

  Future<Projects> getUserCompltedProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('project_owner',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<Projects> getCategorisedProjectsAPIProvider(int categoryId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('category_id', isEqualTo: categoryId)
        .get();

    return Projects.fromJson(list: querySnapshot.docs);
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
    return Users.fromJson(list: querySnapshot.docs);
  }

  Future<ResponseModel> postProjectSignupProvider(
      ProjectSignUpModel projectSignUpVal) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('project_signed_up')
        .where('owner_id', isEqualTo: projectSignUpVal.signUpUserId)
        .where('project_id', isEqualTo: projectSignUpVal.projectId)
        .get();
    late ResponseModel responseModel;
    if (querySnapshot.docs.isEmpty) {
      responseModel = await projectSignUpAPIProvider(projectSignUpVal);
    } else {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        if (querySnapshot.docs[i].exists) {
          responseModel =
              ResponseModel(message: 'Already enrolled', success: true);
        } else {
          responseModel = await projectSignUpAPIProvider(projectSignUpVal);
        }
      }
    }
    return responseModel;
  }

  Future<ResponseModel> projectSignUpAPIProvider(
      ProjectSignUpModel projectSignUpVal) async {
    try {
      await firestore
          .collection('project_signed_up')
          .doc()
          .set(projectSignUpVal.toJson())
          .whenComplete(() async {
        final DocumentSnapshot documentSnapshot = await firestore
            .collection('projects')
            .doc(projectSignUpVal.projectId)
            .get();

        final ProjectModel projectModel = ProjectModel.fromjson(
            json: documentSnapshot.data() as Map<String, dynamic>);

        await firestore
            .collection('projects')
            .doc(projectSignUpVal.projectId)
            .update(<String, dynamic>{
          'enrollment_count': projectModel.enrollmentCount + 1
        });
      });
      return ResponseModel(message: 'Enrolled successfully', success: true);
    } catch (e) {
      return ResponseModel(error: 'Project enrollment failed', success: false);
    }
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
    final QuerySnapshot querySnapshot = projectTabType == ProjectTabType.OWN_TAB
        ? await firestore
            .collection('projects')
            .where('project_owner',
                isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
            .get()
        : projectTabType == ProjectTabType.MY_ENROLLED_TAB
            ? await firestore
                .collection('projects')
                .where('project_owner',
                    isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
                .get()
            : projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
                ? await firestore
                    .collection('projects')
                    .where('status', isEqualTo: TOGGLE_NOT_STARTED)
                    .where('project_owner',
                        isNotEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
                    .get()
                : projectTabType == ProjectTabType.PROJECT_INPROGRESS_TAB
                    ? await firestore
                        .collection('projects')
                        .where('status', isEqualTo: TOGGLE_INPROGRESS)
                        .where('project_owner',
                            isNotEqualTo:
                                prefsObject.getString(CURRENT_USER_ID)!)
                        .get()
                    : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                        ? await firestore
                            .collection('projects')
                            .where('status', isEqualTo: PROJECT_COMPLETED)
                            .where('project_owner',
                                isNotEqualTo:
                                    prefsObject.getString(CURRENT_USER_ID)!)
                            .get()
                        : projectTabType ==
                                ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                            ? await firestore
                                .collection('projects')
                                .where('project_owner',
                                    isNotEqualTo:
                                        prefsObject.getString(CURRENT_USER_ID)!)
                                .get()
                            : await firestore.collection('projects').get();

    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<Users> otherUserInfoAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('users').get();
    return Users.fromJson(list: querySnapshot.docs);
  }

  Future<ResponseModel> postTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('tasks').doc();
      task.enrollTaskId = documentReference.id;
      await documentReference.set(task.toJson());
      return ResponseModel(success: true, message: 'Task created');
    } catch (e) {
      return ResponseModel(success: false, error: 'Task is not created');
    }
  }

  Future<ResponseModel> updateTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('tasks').doc(task.enrollTaskId);
      await documentReference.update(task.toJson());
      return ResponseModel(success: true, message: 'Task is updated');
    } catch (e) {
      return ResponseModel(success: false, error: 'Fail! Task is not updated');
    }
  }

  Future<ResponseModel> deleteTaskAPIProvider(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
      return ResponseModel(success: true, message: 'Task is deleted');
    } catch (e) {
      return ResponseModel(success: false, error: 'Fail, Task is not deleted');
    }
  }

  Future<ResponseModel> updateEnrollTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_tasks').doc(task.enrollTaskId);
      await documentReference.update(task.toJson());
      return ResponseModel(success: true, message: 'Task Updated');
    } catch (e) {
      return ResponseModel(success: false, error: 'Task not updated');
    }
  }

  Future<Tasks> getProjectTasksAPIProvider(String projectId, bool isOwn) async {
    final QuerySnapshot querySnapshot = isOwn
        ? await firestore
            .collection('tasks')
            .where('project_id', isEqualTo: projectId)
            .where('owner_id',
                isEqualTo: prefsObject.getString(CURRENT_USER_ID))
            .get()
        : await firestore
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

  Future<Tasks> getProjectEnrolledTasksAPIProvider(
      String projectId, bool isOwn) async {
    final QuerySnapshot querySnapshot = isOwn
        ? await firestore
            .collection('signed_up_tasks')
            .where('project_id', isEqualTo: projectId)
            .where('sign_up_uid',
                isEqualTo: prefsObject.getString(CURRENT_USER_ID))
            .where('is_approved_from_admin', isEqualTo: true)
            .get()
        : await firestore
            .collection('signed_up_tasks')
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

  Future<ResponseModel> postEnrolledTasksAPIProvider(
      TaskModel enrolledTaskModel) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_tasks').doc();
      enrolledTaskModel.enrollTaskId = documentReference.id;
      await documentReference.set(enrolledTaskModel.toJson());
      return ResponseModel(
          success: true, message: 'Task signed up wait for admin approval');
    } catch (e) {
      return ResponseModel(success: false, error: 'Fail! Task not enrolled');
    }
  }

  Future<Tasks> getEnrolledTasksAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_tasks')
        .where('sign_up_uid', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .where('is_approved_from_admin', isEqualTo: true)
        .get();

    List<QueryDocumentSnapshot<Object?>> tasksList = querySnapshot.docs;
    List<Map<String, dynamic>> tasks = [];
    tasksList.forEach((json) {
      final task = json.data() as Map<String, dynamic>;
      tasks.add(task);
    });
    return Tasks.fromJson(list: tasks);
  }

  Future<TaskModel> getTaskInfoAPIProvider(String taskId) async {
    final DocumentSnapshot documentSnapshot =
        await firestore.collection('tasks').doc(taskId).get();

    return TaskModel.fromjson(
        json: documentSnapshot.data() as Map<String, dynamic>);
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

  Future<bool> postReviewAPIProvider(ReviewModel reviewModel) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('reviews').doc();
      await documentReference.set(reviewModel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Reviews> getProjectReviewsAPIProvider(String projectId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('reviews')
        .where('project_id', isEqualTo: projectId)
        .get();

    List<QueryDocumentSnapshot<Object?>> reviewsList = querySnapshot.docs;
    List<Map<String, dynamic>> reviews = [];
    reviewsList.forEach((json) {
      final review = json.data() as Map<String, dynamic>;
      reviews.add(review);
    });
    return Reviews.fromSnapshot(list: reviews);
  }

  //Notification API Provider
  Future<ResponseModel> postNotificationAPIProvider(
      NotificationModel notification) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('notifications').doc();
      notification.id = documentReference.id;
      await documentReference.set(notification.toJson());
      return ResponseModel(success: true);
    } catch (e) {
      return ResponseModel(success: false, error: 'Fail to sent');
    }
  }

  Future<ResponseModel> updateNotificationAPIProvider(
      NotificationModel notification) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('notifications').doc(notification.id);
      await documentReference.update(notification.toJson());
      return ResponseModel(success: true);
    } catch (e) {
      return ResponseModel(success: false, error: 'Failed');
    }
  }

  Future<ResponseModel> removeNotificationAPIProvider(String id) async {
    try {
      await firestore.collection('notifications').doc(id).delete();
      return ResponseModel(success: true);
    } catch (e) {
      return ResponseModel(success: false, error: 'Fail to update');
    }
  }

  Future<Notifications> getNotificationsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('notifications')
        .where('user_to', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .get();

    List<QueryDocumentSnapshot<Object?>> notificationsList = querySnapshot.docs;
    List<Map<String, dynamic>> notifications = [];
    notificationsList.forEach((json) {
      final notification = json.data() as Map<String, dynamic>;
      notifications.add(notification);
    });
    return Notifications.fromSnapshot(list: notifications);
  }
}
