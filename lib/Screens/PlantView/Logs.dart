import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/PlantView/plantView_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PlanView_Logs extends StatefulWidget {
  String docid;
  PlanView_Logs({this.docid});
  @override
  _PlanView_LogsState createState() => _PlanView_LogsState();
}

class _PlanView_LogsState extends State<PlanView_Logs> {
  List lists = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child(
              StorageUtil.getString("uid"),
            )
            .child('PlantData')
            .child(widget.docid.toString())
            .child('logs')
            .onValue,
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
            return new ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: lists.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400])),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Row(
                        children: [
                          Text(lists[index]['date'].toString()),
                          SizedBox(width: 15.0),
                          Text(lists[index]['time'].toString()),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0),
                          Text("Temp : ${lists[index]['temp'].toString()} "),
                          SizedBox(height: 5.0),
                          Text("Humidity : ${lists[index]['hum'].toString()} "),
                          SizedBox(height: 5.0),
                          Text(
                              "Moisture : ${lists[index]['moist'].toString()} "),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Container(
              child: Center(
                child: Text("No Log Availble Yet"),
              ),
            ),
          );
        },
      ),
    );
  }
}
