import 'package:collegeproject/Provider/Auth.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Provider/TextFeild.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String val = "";
  // Form
  final _formKey = GlobalKey<FormState>();
  bool _enableBotton = false;

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  var savedString = '';
  // Dispose
  @override
  void dispose() {
    super.dispose();
    subjectController.dispose();
    messageController.dispose();
  }

  // Signed In user details
  final user = FirebaseAuth.instance.currentUser;

  // Sign Out
  Future<void> signOut() async {
    await Authentification().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 25.0),
                  ExpandablePanel(
                    theme: ExpandableThemeData(
                      hasIcon: false,
                    ),
                    header: ListTile(
                      title: Text(
                        'Contact Us',
                        style: GoogleFonts.redHatDisplay(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(Icons.mail_outline_outlined,
                          color: Colors.black),
                    ),
                    collapsed: Container(),
                    expanded: Form(
                      key: _formKey,
                      onChanged: (() {
                        setState(() {
                          _enableBotton = _formKey.currentState.validate();
                        });
                      }),
                      child: Container(
                        child: Column(
                          children: [
                            TextFields(
                                controller: subjectController,
                                name: "Subject",
                                validator: ((value) {
                                  if (value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                })),
                            TextFields(
                              controller: messageController,
                              name: "Message",
                              validator: ((value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    _enableBotton = true;
                                  });
                                  return 'Message is required';
                                }
                                return null;
                              }),
                              maxLines: null,
                              type: TextInputType.multiline,
                            ),
                            ElevatedButton(
                              child: Text("Submit"),
                              onPressed: _enableBotton
                                  ? (() async {
                                      final Email email = Email(
                                        body: messageController.text,
                                        subject: subjectController.text,
                                        recipients: ["ourproject@gmail.com"],
                                        isHTML: false,
                                      );
                                      await FlutterEmailSender.send(email);
                                    })
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                      title: Text(
                        "Log Out",
                        style: GoogleFonts.redHatDisplay(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(Icons.logout, color: Colors.red),
                      onTap: () {
                        StorageUtil.removeString();
                        signOut();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
