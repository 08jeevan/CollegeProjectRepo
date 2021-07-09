import 'package:collegeproject/Screens/PlantView/Logs.dart';
import 'package:collegeproject/Screens/PlantView/PlantView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetUpCollectionTabs extends StatelessWidget {
  String docid;
  SetUpCollectionTabs({this.docid});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              height: 55.0,
              color: Colors.white,
              child: TabBar(
                labelPadding:
                    EdgeInsets.only(left: 30.0, right: 25.0, top: 2.0),
                unselectedLabelColor: Colors.grey.withOpacity(0.9),
                indicatorColor: Colors.transparent,
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0,
                ),
                labelColor: Colors.black,
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 19.0,
                ),
                tabs: [
                  Tab(text: "Plant Info"),
                  Tab(text: "Logs"),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              PlantView(
                docid: docid,
              ),
              PlanView_Logs(
                docid: docid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
