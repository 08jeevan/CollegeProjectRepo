import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/Auth.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/CommunitySupport/CommunityLandingPage.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String val = "";
  // Form
  final _formKey = GlobalKey<FormState>();

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

  Authentification authentification = Authentification();

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
                  Container(
                    height: 180.0,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                            user.photoURL.toString(),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                          user.displayName.toString(),
                          style: klargetextboldstyle,
                        ),
                        subtitle: Text(
                          user.email.toString(),
                          style: kmediumtextstyle,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    indent: 25.0,
                    endIndent: 25.0,
                    height: 0.0,
                  ),
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
                                  return 'Message is required';
                                }
                                return null;
                              }),
                              maxLines: null,
                              type: TextInputType.multiline,
                            ),
                            ElevatedButton(
                              child: Text("Submit"),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  final Email email = Email(
                                    body: messageController.text,
                                    subject: subjectController.text,
                                    recipients: ["ourproject@gmail.com"],
                                    isHTML: false,
                                  );
                                  await FlutterEmailSender.send(email);
                                } else {
                                  flutterToast(
                                      msg: 'Text feild should not be empty');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                      title: Text(
                        "Ask Community",
                        style: GoogleFonts.redHatDisplay(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading:
                          Icon(Icons.message_outlined, color: Colors.black),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CommunityLandingPage();
                        }));
                      }),
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
                        authentification.signOut();
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
