import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PlanViewLogs extends StatefulWidget {
  final String docid;
  PlanViewLogs({this.docid});

  @override
  _PlanViewLogsState createState() => _PlanViewLogsState();
}

class _PlanViewLogsState extends State<PlanViewLogs> {
  List lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Logs',
          style: kApptitletextStyle,
        ),
      ),
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
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(lists[index]['date'].toString(),
                              style: kdefaulttextstyleblack),
                          SizedBox(width: 15.0),
                          Text(lists[index]['time'].toString(),
                              style: kdefaulttextstyleblack),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0),
                          Text("Temp : ${lists[index]['temp'].toString()} ",
                              style: kdefaulttextstyleblack),
                          SizedBox(height: 5.0),
                          Text("Humidity : ${lists[index]['hum'].toString()} ",
                              style: kdefaulttextstyleblack),
                          SizedBox(height: 5.0),
                          Text(
                              "Moisture : ${lists[index]['moist'].toString()} ",
                              style: kdefaulttextstyleblack),
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
                child:
                    Text("No Log Availble Yet", style: kdefaulttextstyleblack),
              ),
            ),
          );
        },
      ),
    );
  }
}
