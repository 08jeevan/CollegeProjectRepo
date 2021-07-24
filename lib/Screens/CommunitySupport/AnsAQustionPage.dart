import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/FirebaseHelper.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/CommunitySupport/CommunityLandingPage.dart';
import 'package:collegeproject/Widgets/LoadingIndicator.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseHelper firebaseHelper = FirebaseHelper();

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

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: AlertDialog(
                          content: loadingIndicator(
                            text: 'Uploading Answer',
                          ),
                        ),
                      ),
                    );
                    setState(() {
                      firebaseHelper.ansaqustion(
                        context: context,
                        docID: widget.docID,
                        ans: ansaQustion.text,
                        username: user.displayName.toString(),
                        userprofile: user.photoURL.toString(),
                      );
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
