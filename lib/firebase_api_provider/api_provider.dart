import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/event_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteers_model.dart';
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
}
