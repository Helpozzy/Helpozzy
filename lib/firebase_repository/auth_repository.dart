import 'package:firebase_auth/firebase_auth.dart';

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
  Future<dynamic> signIn(String email, String password) async {
    var auth;
    try {
      auth = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return auth.user;
    } on FirebaseAuthException catch (e) {
      print('Auth ${e.toString()}');
      return e.toString();
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
  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }
}
