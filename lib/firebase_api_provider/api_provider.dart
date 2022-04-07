import 'package:cloud_firestore/cloud_firestore.dart';
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

class ApiProvider {
  Future<States> getStatesAPIProvider() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('states').get();

    return States.fromJson(list: querySnapshot.docs);
  }

  Future<Cities> getCitiesByStateNameAPIProvider(String stateName) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('cities_info')
        .where('state_name', isEqualTo: stateName)
        .get();

    return Cities.fromJson(list: querySnapshot.docs);
  }

  Future<Schools> getSchoolsAPIProvider({String? state, String? city}) async {
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

    return Schools.fromJson(list: querySnapshot.docs);
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

  Future<bool> updateTotalSpentHrsAPIProvider(int hrs) async {
    await firestore
        .collection('users')
        .doc(prefsObject.getString(CURRENT_USER_ID))
        .get()
        .then((value) async {
      SignUpAndUserModel user = SignUpAndUserModel.fromJson(
          json: value.data() as Map<String, dynamic>);

      await firestore
          .collection('users')
          .doc(prefsObject.getString(CURRENT_USER_ID))
          .update({'total_spent_hrs': user.totalSpentHrs! + hrs}).catchError(
              (onError) {
        print(onError.toString());
      });
    });
    return true;
  }

  Future<Projects> getUserCompltedProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('owner_id', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
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

  Future<ResponseModel> postProjectAPIProvider(ProjectModel project) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('projects').doc();
      project.projectId = documentReference.id;
      await documentReference.set(project.toJson());
      return ResponseModel(
        success: true,
        message: 'Project created',
        returnValue: documentReference.id,
      );
    } catch (e) {
      return ResponseModel(success: false, error: 'Failed project not created');
    }
  }

  Future<ResponseModel> updateProjectAPIProvider(ProjectModel project) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('projects').doc(project.projectId);
      await documentReference.update(project.toJson());
      return ResponseModel(success: true, message: 'Project is updated');
    } catch (e) {
      return ResponseModel(
          success: false, error: 'Fail! Project is not updated');
    }
  }

  Future<ResponseModel> deleteProjectAPIProvider(String projectId) async {
    try {
      await firestore.collection('projects').doc(projectId).delete();
      return ResponseModel(success: true, message: 'Project is deleted');
    } catch (e) {
      return ResponseModel(
          success: false, error: 'Fail, Project is not deleted');
    }
  }

  Future<Projects> getProjectsAPIProvider(
      {ProjectTabType? projectTabType}) async {
    final QuerySnapshot signedUpQuerySnapshot = await firestore
        .collection('signed_up_projects')
        .where('owner_id', isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
        .get();

    final QuerySnapshot querySnapshot = projectTabType == ProjectTabType.OWN_TAB
        ? await firestore
            .collection('projects')
            .where('owner_id',
                isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
            .get()
        : projectTabType == ProjectTabType.MY_ENROLLED_TAB
            ? await firestore
                .collection('signed_up_projects')
                .where('signup_uid',
                    isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
                .where('is_approved_from_admin', isEqualTo: true)
                .get()
            : projectTabType == ProjectTabType.PROJECT_UPCOMING_TAB
                ? await firestore
                    .collection('projects')
                    .where('status', isEqualTo: TOGGLE_NOT_STARTED)
                    .where('owner_id',
                        isNotEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
                    .get()
                : projectTabType == ProjectTabType.PROJECT_OPEN_TAB
                    ? await firestore
                        .collection('projects')
                        .where('status', isEqualTo: TOGGLE_INPROGRESS)
                        .where('owner_id',
                            isNotEqualTo:
                                prefsObject.getString(CURRENT_USER_ID)!)
                        .get()
                    : projectTabType == ProjectTabType.PROJECT_COMPLETED_TAB
                        ? await firestore
                            .collection('projects')
                            .where('status', isEqualTo: PROJECT_COMPLETED)
                            .where('owner_id',
                                isNotEqualTo:
                                    prefsObject.getString(CURRENT_USER_ID)!)
                            .get()
                        : projectTabType ==
                                ProjectTabType.PROJECT_CONTRIBUTION_TRACKER_TAB
                            ? await firestore
                                .collection('signed_up_projects')
                                .where('signup_uid',
                                    isNotEqualTo:
                                        prefsObject.getString(CURRENT_USER_ID)!)
                                .where('is_approved_from_admin',
                                    isEqualTo: true)
                                .get()
                            : await firestore.collection('projects').get();

    return Projects.fromJson(
      list: querySnapshot.docs,
      signedUpList: signedUpQuerySnapshot.docs,
    );
  }

  Future<ProjectModel> getProjectByProjectIdAPIProvider(
      String projectId) async {
    final DocumentSnapshot documentSnapshot =
        await firestore.collection('projects').doc(projectId).get();
    return ProjectModel.fromjson(
        json: documentSnapshot.data() as Map<String, dynamic>);
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
        : projectId.isNotEmpty
            ? await firestore
                .collection('tasks')
                .where('project_id', isEqualTo: projectId)
                .get()
            : await firestore
                .collection('tasks')
                .where('task_id', isEqualTo: null)
                .where('owner_id',
                    isEqualTo: prefsObject.getString(CURRENT_USER_ID))
                .get();

    return Tasks.fromJson(list: querySnapshot.docs);
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

    return Tasks.fromJson(list: querySnapshot.docs);
  }

  Future<ResponseModel> postEnrolledTasksAPIProvider(
      TaskModel enrolledTaskModel) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('signed_up_tasks')
          .where('task_id', isEqualTo: enrolledTaskModel.taskId)
          .where('sign_up_uid',
              isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return ResponseModel(
          success: false,
          error: 'You have already signed up for this task',
        );
      } else {
        final DocumentReference documentReference =
            firestore.collection('signed_up_tasks').doc();

        enrolledTaskModel.enrollTaskId = documentReference.id;
        await documentReference.set(enrolledTaskModel.toJson());
        return ResponseModel(
          success: true,
          message: 'Task signed up wait for admin approval',
        );
      }
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

    return Tasks.fromJson(list: querySnapshot.docs);
  }

  Future<ResponseModel> postProjectSignupAPIProvider(
      ProjectModel projectSignUpVal) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_projects')
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
      ProjectModel projectSignUpVal) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('signed_up_projects').doc().get();

      final QuerySnapshot querySnapshot = await firestore
          .collection('signed_up_projects')
          .where('project_id', isEqualTo: projectSignUpVal.projectId)
          .where('signup_uid',
              isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ResponseModel(
          success: false,
          error: 'You have already signed up for this project',
        );
      } else {
        projectSignUpVal.enrolledId = documentSnapshot.id;

        documentSnapshot.reference
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
            'enrollment_count': projectModel.enrollmentCount! + 1
          });
        });
        return ResponseModel(
          message: 'Project signed up wait for admin approval',
          success: true,
        );
      }
    } catch (e) {
      return ResponseModel(error: 'Project enrollment failed', success: false);
    }
  }

  Future<Projects> getEnrolledProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_projects')
        .where('sign_up_uid', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .where('is_approved_from_admin', isEqualTo: true)
        .get();

    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<ResponseModel> updateEnrolledProjectAPIProvider(
      ProjectModel project) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_projects').doc(project.enrolledId);
      await documentReference.update(project.toJson());
      return ResponseModel(success: true, message: 'Task Updated');
    } catch (e) {
      return ResponseModel(success: false, error: 'Task not updated');
    }
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
    List<QueryDocumentSnapshot<Object?>> tasks = [];
    tasksList.forEach((element) {
      final Map<String, dynamic> task = element.data() as Map<String, dynamic>;
      if (taskIds.contains(task['task_id'])) {
        tasks.add(element);
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

    return Reviews.fromSnapshot(list: querySnapshot.docs);
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

    return Notifications.fromSnapshot(list: querySnapshot.docs);
  }
}
