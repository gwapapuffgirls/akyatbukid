import 'package:akyatbukid/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString);
      return null;
    }
  }

   static Future signUp(
      String email,
      String password,
      String fname,
      String lname,
      String address,
      String contact,
      String birthday,
      String usertype) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'email': email,
          'fname': fname,
          'lname': lname,
          'address': address,
          'contact': contact,
          'birthday': birthday,
          'usertype': usertype,
          'profilePicture': '',
          'bio': ''
        });
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      // showDialog(context: context, builder: builder)
      return false;
    }
  }

   Future login(String email, String password) async {
    try {

      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
 User user = authResult.user;

      return _userFromFirebaseUser(user);
    }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }
    // }
    catch (e) {
      print(e);
      return false;
    }
  }

 static Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
