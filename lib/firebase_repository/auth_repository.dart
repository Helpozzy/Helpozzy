import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpozzy/models/login_response_model.dart';
import 'package:helpozzy/models/response_model.dart';
import 'package:helpozzy/utils/constants.dart';

class AuthRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Sign Up with email and password
  Future<AuthResponseModel> signUp(String email, String password) async {
    try {
      UserCredential auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthResponseModel(
        user: auth.user,
        message: SUCCESSFULL,
        success: true,
      );
    } on FirebaseAuthException catch (e) {
      print('Auth ${e.toString()}');
      return AuthResponseModel(
        user: null,
        error: e.toString().split('] ')[1],
        success: false,
      );
    }
  }

  // Sign In with email and password
  Future<AuthResponseModel> signIn(String email, String password) async {
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
          return AuthResponseModel(user: auth.user, success: true);
        } else {
          return AuthResponseModel(
              success: false, error: 'User not exist. Please retry.');
        }
      } else {
        return AuthResponseModel(
            success: false, error: 'Auth failed. Please retry.');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResponseModel(success: false, error: e.toString());
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
  Future<AuthResponseModel?> getCurrentUser() async {
    if (firebaseAuth.currentUser != null) {
      final CollectionReference collectionReference =
          firestore.collection('users');

      final DocumentSnapshot documentSnapshot =
          await collectionReference.doc(firebaseAuth.currentUser!.uid).get();

      if (documentSnapshot.exists) {
        return AuthResponseModel(
          user: firebaseAuth.currentUser,
          success: true,
        );
      } else {
        return AuthResponseModel(
            success: false, error: 'User not exist. Please retry.');
      }
    } else {
      return AuthResponseModel(
          success: false, error: 'Auth failed. Please retry.');
    }
  }

  Future<ResponseModel> verifyEmail() async {
    final Completer<ResponseModel> c = Completer<ResponseModel>();
    firebaseAuth.authStateChanges().listen((User? user) async {
      if (user != null && !user.emailVerified) {
        try {
          await user
              .sendEmailVerification()
              .then((value) => c.complete(ResponseModel(
                    status: true,
                    message: 'Email is not verified please verify your email.',
                  )));
        } catch (e) {
          c.complete(ResponseModel(status: false, error: e.toString()));
          log(e.toString());
        }
      } else {
        c.complete(ResponseModel(
          status: true,
          message: 'Email is verified',
        ));
      }
    });
    return c.future;
  }

  Future<AuthResponseModel> deleteAccount(User user) async {
    late AuthResponseModel response;
    try {
      await user.delete().then((value) {
        response = AuthResponseModel(
          success: true,
          message: 'Account is deleted',
        );
      });
    } on FirebaseAuthException catch (e) {
      response = AuthResponseModel(
        success: false,
        error: e.message!,
      );
    }
    return response;
  }
}
