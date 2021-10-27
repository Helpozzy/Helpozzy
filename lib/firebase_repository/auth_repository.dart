import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpozzy/models/login_response_model.dart';
import 'package:helpozzy/utils/constants.dart';

class AuthRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthRepository();

  // Sign Up with email and password

  Future<User?> signUp(String email, String password) async {
    try {
      var auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return auth.user;
    } on FirebaseAuthException catch (e) {
      print('Auth ${e.toString()}');
    }
  }

  // Sign In with email and password
  Future<LoginResponseModel> signIn(
      String email, String password, String type) async {
    UserCredential auth;
    try {
      auth = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (auth.user != null) {
        final CollectionReference collectionReference =
            firestore.collection('users');

        final DocumentSnapshot documentSnapshot =
            await collectionReference.doc(auth.user!.uid).get();

        if (documentSnapshot.exists) {
          final Map<String, dynamic> userData =
              documentSnapshot.data() as Map<String, dynamic>;
          if (userData['login_type'] == type) {
            return LoginResponseModel(
                user: auth.user, success: true, type: userData['login_type']);
          } else {
            return LoginResponseModel(
                success: false, error: "You can't access $type account.");
          }
        } else {
          return LoginResponseModel(
              success: false, error: "User not exist. Please retry.");
        }
      } else {
        return LoginResponseModel(
            success: false, error: "Auth failed. Please retry.");
      }
    } on FirebaseAuthException catch (e) {
      return LoginResponseModel(success: false, error: e.toString());
    }
  }

  Future<bool> sentResetPassLink(String email) async {
    try {
      firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed ${e.toString()}');
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // check Sign In
  Future<bool> isSignedIn() async {
    var currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  //get current user
  Future<LoginResponseModel?> getCurrentUser() async {
    if (firebaseAuth.currentUser != null) {
      final CollectionReference collectionReference =
          firestore.collection('users');

      final DocumentSnapshot documentSnapshot =
          await collectionReference.doc(firebaseAuth.currentUser!.uid).get();

      if (documentSnapshot.exists) {
        final Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        return LoginResponseModel(
            user: firebaseAuth.currentUser,
            success: true,
            type: userData['login_type']);
      } else {
        return LoginResponseModel(
            success: false, error: "User not exist. Please retry.");
      }
    } else {
      return LoginResponseModel(
          success: false, error: "Auth failed. Please retry.");
    }
  }
}
