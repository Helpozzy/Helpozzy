import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/chat_list_model.dart';
import 'package:helpozzy/models/message_model.dart';
import 'package:helpozzy/models/notification_model.dart';
import 'package:helpozzy/models/task_model.dart';
import 'package:helpozzy/models/project_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/models/review_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/utils/constants.dart';

class ApiProvider {
  Future<VolunteerTypes> volunteerListAPIProvider() async {
    final DocumentReference documentRefVolunteer =
        firestore.collection('volunteers_types').doc('volunteers_types');

    final DocumentSnapshot volunteersJsonData =
        await documentRefVolunteer.get();

    final Map<String, dynamic> volunteers =
        volunteersJsonData.data() as Map<String, dynamic>;

    return VolunteerTypes.fromJson(volunteers['volunteer']);
  }

  Future<ResponseModel> postSignUpAPIProvider(
      SignUpAndUserModel signupAndUserModel) async {
    try {
      final DocumentReference documentRef =
          firestore.collection('users').doc(signupAndUserModel.userId);
      await documentRef.set(signupAndUserModel.toJson());
      return ResponseModel(status: true);
    } catch (e) {
      return ResponseModel(status: false);
    }
  }

  Future<ResponseModel> editProfileAPIProvider(
      Map<String, dynamic> json) async {
    try {
      final DocumentReference documentRef = firestore
          .collection('users')
          .doc(prefsObject.getString(CURRENT_USER_ID));
      await documentRef.update(json).catchError((onError) {
        print(onError.toString());
      });
      return ResponseModel(status: true, message: PROFILE_UPDATED_POPUP_MSG);
    } catch (e) {
      return ResponseModel(status: false, error: PROFILE_NOT_UPDATED_POPUP_MSG);
    }
  }

  Future<ResponseModel> updateTotalSpentHrsAPIProvider(
      String signUpUserId, int hrs) async {
    try {
      await firestore
          .collection('users')
          .doc(signUpUserId)
          .get()
          .then((value) async {
        SignUpAndUserModel user = SignUpAndUserModel.fromJson(
            json: value.data() as Map<String, dynamic>);

        await firestore
            .collection('users')
            .doc(signUpUserId)
            .update({'total_spent_hrs': user.totalSpentHrs! + hrs}).catchError(
                (onError) {
          print(onError.toString());
        });
      });
      return ResponseModel(status: true, message: 'Total hours updated');
    } catch (e) {
      return ResponseModel(status: false, error: 'Total hrs not updated');
    }
  }

  Future<Projects> getUserCompltedProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_projects')
        .where('signup_uid', isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
        .where('is_approved_from_admin', isEqualTo: true)
        .get();

    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<Projects> getCategorisedProjectsAPIProvider(int categoryId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('category_id', isEqualTo: categoryId)
        .where('owner_id', isNotEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .get();

    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<Projects> getCategorisedSignedUpProjectsAPIProvider(
      int categoryId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_projects')
        .where('signup_uid', isEqualTo: prefsObject.getString(CURRENT_USER_ID)!)
        .where('is_approved_from_admin', isEqualTo: true)
        .where('category_id', isEqualTo: categoryId)
        .get();

    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<SignUpAndUserModel> userInfoAPIProvider(String uId) async {
    final DocumentReference documentRef =
        firestore.collection('users').doc(uId);
    final DocumentSnapshot doc = await documentRef.get();
    if (doc.exists) {
      return SignUpAndUserModel.fromJson(
          json: doc.data() as Map<String, dynamic>);
    } else {
      return SignUpAndUserModel.fromJson(json: {});
    }
  }

  Future<ResponseModel> updateUserPresenceAPIProvider(
      String timeStamp, bool presence) async {
    try {
      final DocumentReference documentReference = firestore
          .collection('users')
          .doc(prefsObject.getString(CURRENT_USER_ID));
      await documentReference.update({
        'presence': presence,
        'last_seen': timeStamp,
      });
      return ResponseModel(
        status: true,
        message: 'Activity is updated',
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        error: 'Failed! Activity is not updated',
      );
    }
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
        status: true,
        message: 'Project created',
        returnValue: documentReference.id,
      );
    } catch (e) {
      return ResponseModel(status: false, error: 'Failed project not created');
    }
  }

  Future<ResponseModel> updateProjectAPIProvider(ProjectModel project) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('projects').doc(project.projectId);
      await documentReference.update(project.toJson());
      return ResponseModel(
        status: true,
        message: 'Project is updated',
        returnValue: documentReference.id,
      );
    } catch (e) {
      return ResponseModel(
          status: false, error: 'Fail! Project is not updated');
    }
  }

  Future<ResponseModel> updateEnrolledProjectHrsAPIProvider(
      String signupUserId, String projectId, int hrs) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('signed_up_projects')
          .where('project_id', isEqualTo: projectId)
          .where('signup_uid', isEqualTo: signupUserId)
          .get();

      final DocumentSnapshot documentSnapshot = await firestore
          .collection('signed_up_projects')
          .doc(querySnapshot.docs.first.id)
          .get();

      documentSnapshot.reference.update({'total_tasks_hrs': hrs});

      return ResponseModel(status: true, message: 'Project is updated');
    } catch (e) {
      return ResponseModel(
          status: false, error: 'Failed! Project is not updated');
    }
  }

  Future<ResponseModel> deleteProjectAPIProvider(String projectId) async {
    try {
      await firestore.collection('projects').doc(projectId).delete();
      return ResponseModel(status: true, message: 'Project is deleted');
    } catch (e) {
      return ResponseModel(
          status: false, error: 'Failed, Project is not deleted');
    }
  }

  Future<Projects> getProjectsAPIProvider(
      {ProjectTabType? projectTabType}) async {
    if (projectTabType == ProjectTabType.EXPLORE_SCREEN) {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> filterdQuery =
          await firestore
              .collection('projects')
              .where('owner_id',
                  isNotEqualTo: prefsObject.getString(CURRENT_USER_ID))
              .get()
              .then((snapshot) => snapshot.docs
                  .where((doc) =>
                      int.parse(doc['end_date']) >=
                      DateTime.now().millisecondsSinceEpoch)
                  .toList());

      return Projects.fromJson(list: filterdQuery);
    } else {
      final QuerySnapshot querySnapshot = projectTabType ==
              ProjectTabType.OWN_TAB
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
                              .collection('signed_up_projects')
                              .where('signup_uid',
                                  isEqualTo:
                                      prefsObject.getString(CURRENT_USER_ID)!)
                              .where('is_approved_from_admin', isEqualTo: true)
                              .get()
                          : projectTabType ==
                                  ProjectTabType
                                      .PROJECT_CONTRIBUTION_TRACKER_TAB
                              ? await firestore
                                  .collection('signed_up_projects')
                                  .where('owner_id',
                                      isNotEqualTo: prefsObject
                                          .getString(CURRENT_USER_ID)!)
                                  .where('signup_uid',
                                      isEqualTo: prefsObject
                                          .getString(CURRENT_USER_ID)!)
                                  .where('is_approved_from_admin',
                                      isEqualTo: true)
                                  .get()
                              : await firestore.collection('projects').get();
      return Projects.fromJson(list: querySnapshot.docs);
    }
  }

  Future<ProjectModel> getSignedUpProjectByProjectIdAPIProvider(
      String projectId, String signUpUserId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_projects')
        .where('signup_uid', isEqualTo: signUpUserId)
        .where('project_id', isEqualTo: projectId)
        .get();
    return ProjectModel.fromjson(
        json: querySnapshot.docs.first.data() as Map<String, dynamic>);
  }

  Future<ProjectModel> getProjectByProjectIdAPIProvider(
      String projectId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('projects')
        .where('project_id', isEqualTo: projectId)
        .get();
    return ProjectModel.fromjson(
        json: querySnapshot.docs.first.data() as Map<String, dynamic>);
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
      task.taskId = documentReference.id;
      await documentReference.set(task.toJson());
      return ResponseModel(status: true, message: 'Task created');
    } catch (e) {
      return ResponseModel(status: false, error: 'Task is not created');
    }
  }

  Future<ResponseModel> updateTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('tasks').doc(task.taskId);
      await documentReference.update(task.toJson());
      return ResponseModel(status: true, message: 'Task is updated');
    } catch (e) {
      return ResponseModel(status: false, error: 'Failed! Task is not updated');
    }
  }

  Future<ResponseModel> deleteTaskAPIProvider(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
      return ResponseModel(status: true, message: 'Task is deleted');
    } catch (e) {
      return ResponseModel(status: false, error: 'Failed! Task is not deleted');
    }
  }

  Future<ResponseModel> updateEnrollTaskAPIProvider(TaskModel task) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_tasks').doc(task.enrollTaskId);
      await documentReference.update(task.toJson());
      return ResponseModel(status: true, message: 'Task Updated');
    } catch (e) {
      return ResponseModel(status: false, error: 'Task not updated');
    }
  }

  Future<ResponseModel> removeEnrollTaskAPIProvider(String enrollTaskId) async {
    try {
      await firestore.collection('signed_up_tasks').doc(enrollTaskId).delete();
      return ResponseModel(status: true, message: 'Task declined');
    } catch (e) {
      return ResponseModel(status: false, error: 'Task not declined');
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
                .where('project_id', isNull: true)
                .where('owner_id',
                    isEqualTo: prefsObject.getString(CURRENT_USER_ID))
                .get();

    return Tasks.fromJson(list: querySnapshot.docs);
  }

  Future<Tasks> getSignedUpProjectCompletedTasksAPIProvider(
      String projectId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_tasks')
        .where('project_id', isEqualTo: projectId)
        .where('status', isEqualTo: LOG_HRS_APPROVED)
        .where('sign_up_uid', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .where('is_approved_from_admin', isEqualTo: true)
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
          status: false,
          error: 'You have already signed up for this task',
        );
      } else {
        final DocumentReference documentReference =
            firestore.collection('signed_up_tasks').doc();

        enrolledTaskModel.enrollTaskId = documentReference.id;
        await documentReference.set(enrolledTaskModel.toJson());
        return ResponseModel(
          status: true,
          message: 'Task signed up wait for admin approval',
        );
      }
    } catch (e) {
      return ResponseModel(status: false, error: 'Failed! Task not enrolled');
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
              ResponseModel(message: 'Already enrolled', status: true);
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
          status: false,
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
          status: true,
        );
      }
    } catch (e) {
      return ResponseModel(error: 'Project enrollment failed', status: false);
    }
  }

  Future<Projects> getEnrolledProjectsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('signed_up_projects')
        .where('is_approved_from_admin', isEqualTo: true)
        .where('signup_uid', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .get();
    return Projects.fromJson(list: querySnapshot.docs);
  }

  Future<ResponseModel> updateEnrolledProjectAPIProvider(
      ProjectModel project) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_projects').doc(project.enrolledId);
      await documentReference.update(project.toJson());
      return ResponseModel(status: true, message: 'Task Updated');
    } catch (e) {
      return ResponseModel(status: false, error: 'Task not updated');
    }
  }

  Future<ResponseModel> removeEnrolledProjectAPIProvider(
      String enrollesProjectId) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_projects').doc(enrollesProjectId);
      await documentReference.delete();
      return ResponseModel(status: true, message: 'Project request Declined');
    } catch (e) {
      return ResponseModel(
          status: false, error: 'Project request not declined');
    }
  }

  Future<ResponseModel> removeEnrolledTaskAPIProvider(
      String enrolledTaskId) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('signed_up_tasks').doc(enrolledTaskId);
      await documentReference.delete();
      return ResponseModel(status: true, message: 'Task request Declined');
    } catch (e) {
      return ResponseModel(status: false, error: 'Task request not declined');
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

  Future<ResponseModel> postReviewAPIProvider(ReviewModel reviewModel) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('reviews')
          .where('project_id', isEqualTo: reviewModel.projectId)
          .where('reviewer_id', isEqualTo: reviewModel.reviewerId)
          .get();
      if (querySnapshot.docs.isNotEmpty && querySnapshot.docs.first.exists) {
        querySnapshot.docs.first.reference.update(reviewModel.toJson());
        return ResponseModel(
          status: true,
          message: 'Review updated',
        );
      } else {
        final DocumentReference documentReference =
            firestore.collection('reviews').doc();
        reviewModel.reviewId = documentReference.id;
        await documentReference.set(reviewModel.toJson());
        return ResponseModel(
          status: true,
          message: 'Review posted',
        );
      }
    } catch (e) {
      return ResponseModel(
        status: false,
        error: 'Failed!',
      );
    }
  }

  Future<Reviews> getProjectReviewsAPIProvider(String projectId) async {
    print(projectId);
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
      return ResponseModel(status: true);
    } catch (e) {
      return ResponseModel(status: false, error: 'Fail to sent');
    }
  }

  Future<ResponseModel> updateNotificationAPIProvider(
      NotificationModel notification) async {
    try {
      final DocumentReference documentReference =
          firestore.collection('notifications').doc(notification.id);
      await documentReference.update(notification.toJson());
      return ResponseModel(status: true);
    } catch (e) {
      return ResponseModel(status: false, error: 'Failed');
    }
  }

  Future<ResponseModel> removeNotificationAPIProvider(String id) async {
    try {
      await firestore.collection('notifications').doc(id).delete();
      return ResponseModel(status: true);
    } catch (e) {
      return ResponseModel(status: false, error: 'Failed');
    }
  }

  Future<Notifications> getNotificationsAPIProvider() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('notifications')
        .where('user_to', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
        .get();

    return Notifications.fromSnapshot(list: querySnapshot.docs);
  }

  //Chat API provider
  Future<ChatList> getProjectChatHistory(String projectId) async {
    final Query query = FirebaseFirestore.instance
        .collection('project_chat_list')
        .doc(projectId)
        .collection(prefsObject.getString(CURRENT_USER_ID)!);
    final QuerySnapshot querySnapshot =
        await query.orderBy('timestamp', descending: true).get();
    return ChatList.fromSnapshot(list: querySnapshot.docs);
  }

  Future<Chats> getProjectMessages(
      String projectId, String groupChatId, int limit) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('project_messages')
        .doc(projectId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    return Chats.fromJson(list: querySnapshot.docs);
  }

  //Group chat

  Future<Chats> getGroupMessages(String groupChatId, int limit) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('group_messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    return Chats.fromJson(list: querySnapshot.docs);
  }

  //Delete user account and all data

  Future<ResponseModel> deleteUserRefrencesAPI() async {
    try {
      await firestore
          .collection('users')
          .doc(prefsObject.getString(CURRENT_USER_ID))
          .delete();

      await firestore
          .collection('projects')
          .where('owner_id', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get()
          .then((querySnapshot) async => querySnapshot.docs
              .forEach((doc) async => await doc.reference.delete()));

      await firestore
          .collection('tasks')
          .where('owner_id', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get()
          .then((querySnapshot) async => querySnapshot.docs
              .forEach((doc) async => await doc.reference.delete()));

      await firestore
          .collection('signed_up_projects')
          .where('owner_id', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get()
          .then((querySnapshot) async => querySnapshot.docs
              .forEach((doc) async => await doc.reference.delete()));

      await firestore
          .collection('signed_up_tasks')
          .where('owner_id', isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get()
          .then((querySnapshot) async => querySnapshot.docs
              .forEach((doc) async => await doc.reference.delete()));

      await firestore
          .collection('reviews')
          .where('reviewer_id',
              isEqualTo: prefsObject.getString(CURRENT_USER_ID))
          .get()
          .then((querySnapshot) async => querySnapshot.docs
              .forEach((doc) async => await doc.reference.delete()));

      return ResponseModel(status: true, message: 'User refrences are cleared');
    } catch (e) {
      return ResponseModel(status: false, error: e.toString());
    }
  }
}
