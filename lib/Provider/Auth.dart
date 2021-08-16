import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Authentification {
  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final token = await FirebaseMessaging.instance.getToken();

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user;

      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child(user.uid.toString())
          .child("Personal_Info");
      var data = user;
      databaseRef.set({
        'Name': data.displayName.toString(),
        'EmailID': data.email.toString(),
        'Image': data.photoURL.toString(),
        'token': token,
      });
      // Cloud
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid.toString())
          .collection('personalInfo')
          .add({
        'Name': data.displayName.toString(),
        'EmailID': data.email.toString(),
        'Image': data.photoURL.toString(),
      });

      // Shared Pref UID
      StorageUtil.putString("uid", user.uid.toString());
      print(user.uid.toString());
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborded by user",
        code: "ERROR_ABORDER_BY_USER",
      );
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
