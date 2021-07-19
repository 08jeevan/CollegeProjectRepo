import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/CommunitySupport/AnsAQustionPage.dart';
import 'package:collegeproject/Screens/CommunitySupport/AnswerPage.dart';
import 'package:collegeproject/Screens/CommunitySupport/AskQustion.dart';
import 'package:collegeproject/Screens/CommunitySupport/MyQustions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class CommunityLandingPage extends StatefulWidget {
  @override
  _CommunityLandingPageState createState() => _CommunityLandingPageState();
}

class _CommunityLandingPageState extends State<CommunityLandingPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.5,
        title: Text("Ask Community",
            style: GoogleFonts.montserrat(
              color: Colors.black,
            )),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyQustions();
              }));
            },
            child: Icon(
              AntDesign.profile,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 15.0),
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('AllQueries').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: Text('Loading...'));
              default:
                return Container(
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return GestureDetector(
                        onTap: () {
                          firestore
                              .collection("AllQueries")
                              .doc(document['docid'])
                              .update({"views": document['views'] + 1});
                          firestore
                              .collection("Users")
                              .doc(StorageUtil.getString("uid"))
                              .collection("Queries")
                              .doc(document['docid'])
                              .update({"views": document['views'] + 1});
                          document['ans'].toString() == "no_ans_yet"
                              ? showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 8.0),
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              document['qus'].toString(),
                                            ),
                                            SizedBox(height: 10.0),
                                            document['img'].toString() == ""
                                                ? Container()
                                                : Container(
                                                    height: 150.0,
                                                    width: 150.0,
                                                    child: Image.network(
                                                      document['img']
                                                          .toString(),
                                                    ),
                                                  ),
                                            ElevatedButton(
                                              child: const Text(
                                                  'Answer this Query'),
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return AnsaQustion(
                                                  docID: document['docid']
                                                      .toString(),
                                                  qustitle: document['qus']
                                                      .toString(),
                                                );
                                              })),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: AnswerPage(
                                        docID: document['docid'].toString(),
                                      )));
                        },
                        child: new ListTile(
                          title: Text(
                            document['qus'].toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          trailing: Icon(
                            MaterialIcons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
            }
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AskQustion();
          }));
        },
        label: Text("Ask a Qustion", style: GoogleFonts.montserrat()),
        icon: Icon(Icons.question_answer_outlined),
      ),
    );
  }
}
