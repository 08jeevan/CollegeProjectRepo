import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/BottomNavBar.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseHelper {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Delete a plant and diviceID

  void deleteaPlant({String plantdeviceID, context}) {
    databaseReference
        .child(StorageUtil.getString('uid'))
        .child('PlantData')
        .child(plantdeviceID)
        .remove()
        .whenComplete(() => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return MyNavBar();
            })));
    databaseReference.child('devices').child(plantdeviceID).remove();
  }

  // Answer a qustion
  void ansaqustion({
    context,
    String docID,
    String ans,
    String username,
    String userprofile,
  }) {
    firebaseFirestore
        .collection("AllQueries")
        .doc(docID)
        .collection("Ans")
        .add({
      "ans": ans,
      "ansby": username,
      "ansbyprofile": userprofile,
    }).then((value) =>
            firebaseFirestore.collection("AllQueries").doc(docID).update({
              "ans": "ans_found",
            }));
    firebaseFirestore
        .collection("Users")
        .doc(StorageUtil.getString("uid"))
        .collection("Queries")
        .doc(docID)
        .update({
          "ans": "ans_found",
        })
        .then((value) => firebaseFirestore
                .collection("Users")
                .doc(StorageUtil.getString("uid"))
                .collection("Queries")
                .doc(docID)
                .collection("Ans")
                .add({
              "ans": ans,
              "ansby": username,
              "ansbyprofile": userprofile,
            }))
        .whenComplete(() {
          Navigator.pop(context);
          Navigator.pop(context);
        });
  }

  // Ask a Qustion Helper
  void askaQustion({
    context,
    String uniquedocid,
    String qus,
    String image,
  }) {
    firebaseFirestore
        .collection("Users")
        .doc(
          StorageUtil.getString("uid"),
        )
        .collection("Queries")
        .doc(uniquedocid)
        .set({
      "qus": qus.toString(),
      "img": image,
      "docid": uniquedocid.toString(),
      "views": 0,
      "ans": "no_ans_yet",
    });
    firebaseFirestore.collection("AllQueries").doc(uniquedocid).set({
      "qus": qus.toString(),
      "img": image,
      "docid": uniquedocid.toString(),
      "views": 0,
      "ans": "no_ans_yet",
    }).whenComplete(() {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
