import 'package:collegeproject/API/PlantDataJson.dart';
import 'package:collegeproject/API/WeatherApi.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/FirebaseHelper.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/PlantView/Logs.dart';
import 'package:collegeproject/Widgets/AlertDialog.dart';
import 'package:collegeproject/Widgets/LoadingIndicator.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:collegeproject/Widgets/WeatherWidget.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:collegeproject/Screens/PlantView/ChangeWifi.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

FirebaseHelper firebaseHelper = FirebaseHelper();

class PlantView extends StatefulWidget {
  final String docid, img;
  PlantView({this.docid, this.img});
  @override
  _PlantViewState createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> {
  var temp;

  // Weather
  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  bool activatemotor = false;

  final databaseReference = FirebaseDatabase.instance.reference();

  Weather _weather;

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
              var _dht = DHT.fromJson(
                  snapshot.data.snapshot.value[widget.docid.toString()]);

              return Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 300.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Image.network(
                            widget.img.toString(),
                            fit: BoxFit.cover,
                            cacheHeight: 500,
                            cacheWidth: 500,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return loadingIndicator(text: 'Loading Image');
                            },
                            errorBuilder: (context, error, stackTrace) => Text(
                                'Errors occurred!',
                                style: kdefaulttextstyleblack),
                          ),
                        ),
                        Positioned(
                          top: 35.0,
                          left: 30.0,
                          child: Icon(
                            AntDesign.arrowleft,
                            color: Colors.black,
                          ),
                        ),
                        Positioned(
                          bottom: 30.0,
                          left: 30.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_dht.plantname.toString(),
                                  style: klargetextboldstyle),
                              SizedBox(height: 5.0),
                              Text(_dht.smartDeviceId.toString(),
                                  style: kmediumtextstyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Temprature', style: kmediumtextstyle),
                            subtitle: Text(
                              _dht.temp.toString() + "° c",
                              style: klargetextboldstyle,
                            ),
                          ),
                          SizedBox(
                            height: 0.0,
                          ),
                          ListTile(
                            title: Text('Moisture', style: kmediumtextstyle),
                            subtitle: Text(
                              _dht.moisture.toString(),
                              style: klargetextboldstyle,
                            ),
                          ),
                          SizedBox(
                            height: 0.0,
                          ),
                          ListTile(
                            title: Text('Humidity', style: kmediumtextstyle),
                            subtitle: Text(
                              _dht.humidity.toString(),
                              style: klargetextboldstyle,
                            ),
                          ),
                          FutureBuilder(
                            future: fetchPost(
                              zipcode: _dht.zipcode.toString(),
                              countrycode: _dht.countryCode.toString(),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot != null) {
                                this._weather = snapshot.data;
                                if (this._weather == null) {
                                  return loadingIndicator(text: 'Loading');
                                } else {
                                  return weatherBox(_weather, context);
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          SizedBox(height: 10.0),
                          Divider(
                            color: Colors.grey[300],
                            indent: 25.0,
                            endIndent: 25.0,
                          ),
                          ListTile(
                            title: Text('Change Wifi Password',
                                style: kmediumtextstyle),
                            trailing: Icon(
                              AntDesign.arrowright,
                              color: Colors.black,
                            ),
                            onTap: () {
                              databaseReference
                                  .child(
                                    StorageUtil.getString("uid"),
                                  )
                                  .child('PlantData')
                                  .child(_dht.docID.toString())
                                  .update({
                                "changepass": true,
                              }).whenComplete(
                                () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    isDismissible: false,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return ChangeWifi(
                                        plantID: _dht.docID.toString(),
                                      );
                                    }),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Logs', style: kmediumtextstyle),
                            trailing: Icon(
                              AntDesign.arrowright,
                              color: Colors.black,
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PlanViewLogs(
                                  docid: _dht.docID.toString(),
                                );
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Divider(
                      color: Colors.grey[300],
                      indent: 35.0,
                      endIndent: 35.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: ListTile(
                        title: Text('Delete Plant', style: kmediumredtextstyle),
                        leading: Icon(MaterialCommunityIcons.delete_outline,
                            color: Colors.red),
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Deleteafile(
                              context: context,
                              text:
                                  'Once you delete this plant from Database, you cannot retrive it back',
                              imagepath: 'Images/deleteafile.gif',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                firebaseHelper.deleteaPlant(
                                  plantdeviceID: _dht.docID.toString(),
                                  context: context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 65.0),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text("NO DATA FOUND😢", style: kdefaulttextstyleblack),
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: activatemotor == false
          ? FloatingActionButton.extended(
              label: Text('Activate Motor', style: kdefaulttextstylewhite),
              onPressed: () {
                if (_weather.main == 'Rain') {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => Deleteafile(
                      context: context,
                      text:
                          'It may rain today! Are you sure you want to water now?',
                      imagepath: 'Images/itmayrain.gif',
                      onTap: () {
                        Navigator.of(context).pop();
                        databaseReference
                            .child(StorageUtil.getString("uid"))
                            .child('PlantData')
                            .child(widget.docid.toString())
                            .update({
                          "motoractiv": true,
                        }).then((value) =>
                                flutterToast(msg: 'Motor Activated'));
                        setState(() {
                          activatemotor = true;
                        });
                      },
                    ),
                  );
                } else {
                  databaseReference
                      .child(StorageUtil.getString("uid"))
                      .child('PlantData')
                      .child(widget.docid.toString())
                      .update({
                    "motoractiv": true,
                  }).then((value) => flutterToast(msg: 'Motor Activated'));
                  setState(() {
                    activatemotor = true;
                  });
                }
              },
            )
          : FloatingActionButton.extended(
              label: Text('Deactivate Motor', style: kdefaulttextstylewhite),
              onPressed: () {
                databaseReference
                    .child(StorageUtil.getString("uid"))
                    .child('PlantData')
                    .child(widget.docid.toString())
                    .update({
                  "motoractiv": false,
                }).then(
                  (value) => flutterToast(msg: 'Motor Deactivated'),
                );
                setState(() {
                  activatemotor = false;
                });
              },
            ),
    );
  }
}
