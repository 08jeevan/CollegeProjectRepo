import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/CommunitySupport/AnswerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class MyQustions extends StatefulWidget {
  @override
  _MyQustionsState createState() => _MyQustionsState();
}

class _MyQustionsState extends State<MyQustions> {
  String userID;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    this.userID = StorageUtil.getString("uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Qustions',
          style: kApptitletextStyle,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('Users')
              .doc(userID.toString())
              .collection('Queries')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
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
                          document['ans'].toString() == "no_ans_yet"
                              ? Fluttertoast.showToast(msg: 'No answers found')
                              : Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: AnswerPage(
                                      docID: document['docid'].toString(),
                                      qus: document['qus'].toString(),
                                      img: document['img'].toString(),
                                    ),
                                  ),
                                );
                        },
                        child: new ListTile(
                          title: Text(
                            document['qus'].toString(),
                            style: kmediumtextstyle,
                          ),
                          subtitle: document['ans'].toString() == "no_ans_yet"
                              ? Container(
                                  child: Text("No Answer yet",
                                      style: kdefaulttextstyleblack),
                                )
                              : Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text("Answered",
                                            style: kdefaulttextstyleblack),
                                      ),
                                      SizedBox(width: 15.0),
                                      Text(
                                          document['views'].toString() +
                                              " views",
                                          style: kdefaulttextstyleblack)
                                    ],
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
    );
  }
}
