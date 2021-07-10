import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Authentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );

        // Save User Data into Realtime DB
        final databaseRef = FirebaseDatabase.instance
            .reference()
            .child(userCredential.user.uid.toString())
            .child("Personal_Info");
        var data = userCredential.user;
        databaseRef.set({
          'Name': data.displayName.toString(),
          'EmailID': data.email.toString(),
          'Image': data.photoURL.toString(),
        });

        // Shared Pref UID
        StorageUtil.putString("uid", userCredential.user.uid.toString());
        print(".....................................................");
        print(userCredential.user.uid.toString());

        return userCredential.user;
      }
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
    await _firebaseAuth.signOut();
  }
}
