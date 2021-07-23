import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Screens/CommunitySupport/AnsAQustionPage.dart';
import 'package:collegeproject/Widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class AnswerPage extends StatefulWidget {
  final String docID, qus, img;
  AnswerPage({this.docID, this.qus, this.img});
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AnsaQustion(
                        docID: widget.docID.toString(),
                        qustitle: widget.qus.toString(),
                      )));
            },
            child: Icon(Entypo.add_to_list, color: Colors.black),
          ),
          SizedBox(width: 15.0),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15.0),
              Container(
                child: Text(
                  widget.qus.toString(),
                  style: klargetextstyle,
                ),
              ),
              SizedBox(height: 20.0),
              widget.img.toString() != ""
                  ? Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          widget.img.toString(),
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: loadingIndicator(
                                text: "Loading",
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 8.0),
              StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore
                    .collection('AllQueries')
                    .doc(widget.docID)
                    .collection('Ans')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: Text('Loading...'));
                    default:
                      return ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey[300],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: ListTile(
                                        title: Text(
                                          "Ans by, " +
                                              document['ansby'].toString(),
                                          style: kdefaulttextstyleblack,
                                        ),
                                        minLeadingWidth: 8.0,
                                        leading: CircleAvatar(
                                          radius: 15.0,
                                          backgroundImage: document[
                                                          'ansbyprofile']
                                                      .toString() ==
                                                  null
                                              ? NetworkImage(
                                                  "https://www.hhcenter.org/wp-content/uploads/2017/02/person-placeholder.jpg")
                                              : NetworkImage(
                                                  document['ansbyprofile']
                                                      .toString(),
                                                ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      endIndent: 60.0,
                                      indent: 60.0,
                                      height: 0.0,
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      child: Text(
                                        document['ans'].toString(),
                                        style: kmediumtextstyle,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
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
