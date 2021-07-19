// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collegeproject/Provider/SharedPref.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';

// class Authentification {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   Future<void> signInWithGoogle() async {
//     final googleSignIn = GoogleSignIn();
//     final googleUser = await googleSignIn.signIn();
//     if (googleUser != null) {
//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken != null) {
//         final userCredential = await _firebaseAuth.signInWithCredential(
//           GoogleAuthProvider.credential(
//               idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
//         );

//         // Save User Data into Realtime DB
//         final databaseRef = FirebaseDatabase.instance
//             .reference()
//             .child(userCredential.user.uid.toString())
//             .child("Personal_Info");
//         var data = userCredential.user;
//         databaseRef.set({
//           'Name': data.displayName.toString(),
//           'EmailID': data.email.toString(),
//           'Image': data.photoURL.toString(),
//         });
//         // Cloud
//         FirebaseFirestore.instance
//             .collection('Users')
//             .doc(userCredential.user.uid.toString())
//             .collection('personalInfo')
//             .add({
//           'Name': data.displayName.toString(),
//           'EmailID': data.email.toString(),
//           'Image': data.photoURL.toString(),
//         });

//         // Shared Pref UID
//         StorageUtil.putString("uid", userCredential.user.uid.toString());
//         print(".....................................................");
//         print(userCredential.user.uid.toString());

//         return userCredential.user;
//       }
//     } else {
//       throw FirebaseAuthException(
//         message: "Sign in aborded by user",
//         code: "ERROR_ABORDER_BY_USER",
//       );
//     }
//   }

//   Future<void> signOut() async {
//     final googleSignIn = GoogleSignIn();
//     await googleSignIn.signOut();
//     await _firebaseAuth.signOut();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
      print(".....................................................");
      print(user.uid.toString());

      // if (result != null) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => HomePage()));
      // } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
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
