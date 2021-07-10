import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/PlantView/ChangeWifi.dart';
import 'package:collegeproject/Screens/PlantView/plantView_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantView extends StatefulWidget {
  String docid;
  PlantView({this.docid});
  @override
  _PlantViewState createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> {
  bool activatemotor = false;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: databaseReference
              .child(
                StorageUtil.getString("uid"),
              )
              .child('PlantData')
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              print(
                  "Snapshot data: ${snapshot.data.snapshot.value.toString()}");
              //
              var _dht = DHT.fromJson(
                  snapshot.data.snapshot.value[widget.docid.toString()]);

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Container(
                        height: 150.0,
                        width: 150.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            _dht.plantimg.toString(),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Text('Some errors occurred!'),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      // Change accordingly
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Info(
                            dht: _dht,
                            label: "Moisture",
                            sublabel: _dht.moisture.toString(),
                          ),
                          Info(
                            dht: _dht,
                            label: "Humidity",
                            sublabel: _dht.humidity.toString(),
                          ),
                        ],
                      ),
                      Info(
                        dht: _dht,
                        label: "Temprature",
                        sublabel: _dht.temp.toString(),
                      ),
                      SizedBox(height: 15.0),
                      activatemotor == false
                          ? Container(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ChangeWifi(
                                          plantID: _dht.docID.toString(),
                                        );
                                      });
                                },
                                child: Text(
                                  "Change WIFI",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[300],
                                ),
                                child: Text(
                                  "Change WIFI",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      SizedBox(height: 10.0),
                      activatemotor == false
                          ? Container(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  databaseReference
                                      .child(StorageUtil.getString("uid"))
                                      .child('PlantData')
                                      .child(widget.docid.toString())
                                      .update({
                                    "motoractiv": true,
                                  }).then(
                                    (value) => Fluttertoast.showToast(
                                      msg: "Motor activated",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  );
                                  setState(() {
                                    activatemotor = true;
                                  });
                                },
                                child: Text(
                                  "Activate Motor",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  databaseReference
                                      .child(StorageUtil.getString("uid"))
                                      .child('PlantData')
                                      .child(widget.docid.toString())
                                      .update({
                                    "motoractiv": false,
                                  }).then(
                                    (value) => Fluttertoast.showToast(
                                      msg: "Motor Deactivated",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  );
                                  setState(() {
                                    activatemotor = false;
                                  });
                                },
                                child: Text(
                                  "Deactivate Motor",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text("NO DATA FOUND😢"),
              );
            }
          },
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key key,
    @required DHT dht,
    this.label,
    this.sublabel,
  })  : _dht = dht,
        super(key: key);

  final DHT _dht;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 13.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              sublabel,
              style: GoogleFonts.montserrat(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
