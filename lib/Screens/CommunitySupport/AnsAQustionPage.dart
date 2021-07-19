import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Provider/TextFeild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AnsaQustion extends StatefulWidget {
  String docID, qustitle;
  AnsaQustion({this.docID, this.qustitle});
  @override
  _AnsaQustionState createState() => _AnsaQustionState();
}

class _AnsaQustionState extends State<AnsaQustion> {
  final user = FirebaseAuth.instance.currentUser;

  String currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

  final _formKey = GlobalKey<FormState>();
  bool _enableBotton = false;

  TextEditingController ansaQustion = TextEditingController();

  // Alert Dial
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Thank you for supporting our Community by your small Contrbution'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text('Ask a Qustion'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Text(
                widget.qustitle,
                style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                onChanged: (() {
                  setState(() {
                    _enableBotton = _formKey.currentState.validate();
                  });
                }),
                child: TextFields(
                  maxLines: 20,
                  controller: ansaQustion,
                  name: "Start entering your response here",
                  validator: ((value) {
                    if (value.isEmpty) {
                      setState(() {
                        _enableBotton = true;
                      });
                      return 'You can\'t leave this feild empty';
                    }
                    return null;
                  }),
                ),
              ),
              ElevatedButton(
                child: Text("Submit"),
                onPressed: _enableBotton
                    ? (() async {
                        firebaseFirestore
                            .collection("AllQueries")
                            .doc(widget.docID)
                            .update({
                          "ans": ansaQustion.text,
                          "ansby": user.displayName.toString(),
                          "ansbyprofile": user.photoURL.toString(),
                        });
                        firebaseFirestore
                            .collection("Users")
                            .doc(StorageUtil.getString("uid"))
                            .collection("Queries")
                            .doc(widget.docID)
                            .update({
                          "ans": ansaQustion.text,
                          "ansby": user.displayName.toString(),
                          "ansbyprofile": user.photoURL.toString(),
                        });
                      })
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
