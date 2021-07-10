import 'package:collegeproject/Provider/Auth.dart';
import 'package:collegeproject/Provider/Notification.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/PlantView/Tababar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Authentification authentification = Authentification();
Notifiation notifiation = Notifiation();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Google Auth Credintal
  final user = FirebaseAuth.instance.currentUser;

  String uid = '';
  // Notification
  @override
  void initState() {
    super.initState();
    notifiation.noti(context);
  }

  final dbRef = FirebaseDatabase.instance
      .reference()
      // TODO:
      .child(
        StorageUtil.getString("uid"),
      )
      .child("PlantData");

  List lists = List();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                Container(
                  height: 100.0,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Welcome Back 👋",
                              style: GoogleFonts.redHatDisplay(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: Text(
                              user.displayName.toString(),
                              style: GoogleFonts.redHatDisplay(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Let's Start\nWatering Plants",
                    style: GoogleFonts.redHatDisplay(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                StreamBuilder(
                  stream: dbRef.onValue,
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data.snapshot.value != null) {
                      lists.clear();
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;
                      values.forEach((key, values) {
                        lists.add(values);
                      });
                      return new GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 7 / 10,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SetUpCollectionTabs(
                                    docid: lists[index]["smartID"].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25.0),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      lists[index]["plantname"],
                                      maxLines: 1,
                                      style: GoogleFonts.redHatDisplay(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.0),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      lists[index]["smartID"],
                                      style: GoogleFonts.redHatDisplay(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          lists[index]["plantimg"].toString(),
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;

                                            return Container(
                                              height: 15.0,
                                              width: 15.0,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Text('Some errors occurred!'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Container(
                        child: Center(
                          child: Text("Add Plants"),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
