import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerPage extends StatefulWidget {
  final String docID;
  AnswerPage({this.docID});
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        child: StreamBuilder(
          stream: firebaseFirestore
              .collection("AllQueries")
              .doc(widget.docID)
              .snapshots(),
          builder: (context, snapshot) {
            var plantData = snapshot.data;
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    child: Text(
                      plantData.data()["qus"],
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  plantData.data()["img"] != ""
                      ? Container(
                          height: 200.0,
                          width: 200.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(plantData.data()["img"],
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10.0),
                  Container(
                    child: ListTile(
                      title: Text(
                          "Ans by, " + plantData.data()["ansby"].toString()),
                      minLeadingWidth: 10.0,
                      leading: CircleAvatar(
                        radius: 15.0,
                        backgroundImage: plantData.data()["ansbyprofile"] ==
                                null
                            ? NetworkImage(
                                "https://www.hhcenter.org/wp-content/uploads/2017/02/person-placeholder.jpg")
                            : NetworkImage(
                                plantData.data()["ansbyprofile"].toString()),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(
                    color: Colors.grey,
                    endIndent: 60.0,
                    indent: 60.0,
                    height: 0.0,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                      child: Text(
                    plantData.data()["ans"],
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
