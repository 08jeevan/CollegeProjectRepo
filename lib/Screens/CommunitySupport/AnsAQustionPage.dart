import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/CommunitySupport/CommunityLandingPage.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AnsaQustion extends StatefulWidget {
  final String docID, qustitle;
  AnsaQustion({this.docID, this.qustitle});
  @override
  _AnsaQustionState createState() => _AnsaQustionState();
}

class _AnsaQustionState extends State<AnsaQustion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  TextEditingController ansaQustion = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    ansaQustion.dispose();
  }

  // Alert Dial
  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Saving response."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return CommunityLandingPage();
                }));
              },
            ),
          ],
        );
      },
    );
  }
//

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Text(
                widget.qustitle,
                style: klargetextstyle,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: TextFields(
                  maxLines: 20,
                  controller: ansaQustion,
                  name: "Start entering your response here",
                  validator: ((value) {
                    if (value.isEmpty) {
                      return 'You can\'t leave this feild empty';
                    }
                    return null;
                  }),
                ),
              ),
              ElevatedButton(
                child: Text("Submit", style: kdefaulttextstylewhite),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
//
                      firebaseFirestore
                          .collection("AllQueries")
                          .doc(widget.docID)
                          .collection("Ans")
                          .add({
                        "ans": ansaQustion.text,
                        "ansby": user.displayName.toString(),
                        "ansbyprofile": user.photoURL.toString(),
                      }).then((value) => firebaseFirestore
                                  .collection("AllQueries")
                                  .doc(widget.docID)
                                  .update({
                                "ans": "ans_found",
                              }));
                      firebaseFirestore
                          .collection("Users")
                          .doc(StorageUtil.getString("uid"))
                          .collection("Queries")
                          .doc(widget.docID)
                          .update({
                            "ans": "ans_found",
                          })
                          .then((value) => firebaseFirestore
                                  .collection("Users")
                                  .doc(StorageUtil.getString("uid"))
                                  .collection("Queries")
                                  .doc(widget.docID)
                                  .collection("Ans")
                                  .add({
                                "ans": ansaQustion.text,
                                "ansby": user.displayName.toString(),
                                "ansbyprofile": user.photoURL.toString(),
                              }))
                          .then((value) => _showMyDialog());
//
                    });
                  } else {
                    Fluttertoast.showToast(msg: 'Please enter a valid answer');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
