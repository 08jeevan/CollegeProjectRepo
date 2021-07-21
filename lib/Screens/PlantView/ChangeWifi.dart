import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeWifi extends StatefulWidget {
  final String plantID;
  ChangeWifi({this.plantID});

  @override
  _ChangeWifiState createState() => _ChangeWifiState();
}

class _ChangeWifiState extends State<ChangeWifi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text feild
  TextEditingController changewifiid = TextEditingController();
  TextEditingController changewifipass = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 25.0),
              Text("Change Wifi Settings"),
              SizedBox(height: 25.0),
              TextFields(
                controller: changewifiid,
                name: 'Enter Wifi ID',
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter new Wifi ID';
                  }
                  return null;
                },
              ),
              TextFields(
                controller: changewifipass,
                name: 'Enter Wifi Pass',
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter new Wifi Password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: Text('Change Wifi', style: kdefaulttextstylewhite),
                onPressed: () {
                  if (changewifipass.text.isEmpty &&
                      changewifiid.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please fill out the form",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }

                  databaseReference
                      .child(
                        StorageUtil.getString("uid"),
                      )
                      .child('PlantData')
                      .child(widget.plantID.toString())
                      .update({
                    "changepass": true,
                    "ssid": changewifiid.text,
                    "pass": changewifipass.text
                  }).then((value) => flutterToast(msg: "Wifi Reset secussful"));
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
