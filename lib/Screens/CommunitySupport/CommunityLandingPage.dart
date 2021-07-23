import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/CommunitySupport/AnsAQustionPage.dart';
import 'package:collegeproject/Screens/CommunitySupport/AnswerPage.dart';
import 'package:collegeproject/Screens/CommunitySupport/AskQustion.dart';
import 'package:collegeproject/Screens/CommunitySupport/MyQustions.dart';
import 'package:collegeproject/Widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
        title: Text(
          "Ask Community",
          style: kApptitletextStyle,
        ),
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
            if (snapshot.hasError)
              return Center(
                child: Text(
                  'No Data Found',
                  style: kdefaulttextstyleblack,
                ),
              );
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: loadingIndicator(
                    text: "Loading",
                  ),
                );
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
                          //
                          document['ans'].toString() == "no_ans_yet"
                              ? showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 15.0),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          SizedBox(height: 15.0),
                                          Text(
                                            document['qus'].toString(),
                                            style: klargetextstyle,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 15.0),
                                          document['img'].toString() == ""
                                              ? Container()
                                              : Container(
                                                  height: 150.0,
                                                  width: 150.0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    child: Image.network(
                                                      document['img']
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                          child:
                                                              loadingIndicator(
                                                            text: "Loading",
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                          document['img'].toString() == ""
                                              ? Container()
                                              : SizedBox(height: 12.0),
                                          ElevatedButton(
                                              child: Text(
                                                'Answer this Qustion',
                                                style: kdefaulttextstylewhite,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return AnsaQustion(
                                                    docID: document['docid']
                                                        .toString(),
                                                    qustitle: document['qus']
                                                        .toString(),
                                                  );
                                                }));
                                              }),
                                          SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
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
        label: Text("Ask a Qustion", style: kdefaulttextstylewhite),
        icon: Icon(Icons.question_answer_outlined),
      ),
    );
  }
}
