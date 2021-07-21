import 'dart:io';
import 'package:collegeproject/BottomNavBar.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddSmartDevice extends StatefulWidget {
  @override
  _AddSmartDeviceState createState() => _AddSmartDeviceState();
}

class _AddSmartDeviceState extends State<AddSmartDevice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String imageUrl;

  bool uploading = false;

  var displayUrl;

  var url;

  File _image;

  String countryCode;

  final picker = ImagePicker();

  var _chosenValue;

  final databaseReference = FirebaseDatabase.instance.reference();

  // DB Rederence
  Reference reference = FirebaseStorage.instance
      .ref()
      .child(
        StorageUtil.getString("uid"),
      )
      .child("image" + DateTime.now().toString());

  // TextFeild
  TextEditingController uniquedeviceid = TextEditingController();
  TextEditingController zipcode = TextEditingController();

  List<String> plantList = [
    "AFRICAN VIOLET",
    "ALGAONEMA",
    "APHELANDRA",
    "ARALIA",
    "ARDISIA",
    "AZALEA",
    "BABY'S TEARS",
    "BEGONIA",
    "BROMELIAD",
    "CACTUS",
    "CALADIUM",
    "CHRISTMAS CACTUS",
    "COFFEE",
    "COLEUS",
    "CRASSULA",
    "CROTON",
    "CRYPTANTHUS",
    "DIEFFENBACHIA",
    "DRACAENA",
  ];

  // Picking Image
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Uploading Images and Other info to Storage & DB
  upload() async {
    UploadTask uploadTask = reference.putFile(
      _image,
      SettableMetadata(
        customMetadata: {
          'plant_name': _chosenValue,
        },
      ),
    );
    uploadTask.whenComplete(() async {
      // When Image Upload is secussful the rest of the data will be pushed to
      // DB Including image URL from Storage
      try {
        imageUrl = await reference.getDownloadURL();
        setState(() {
          displayUrl = imageUrl;
          final ref = databaseReference
              .child(
                StorageUtil.getString("uid"),
              )
              .child("PlantData")
              .child(uniquedeviceid.text);
          ref.child("plantname").set(
                _chosenValue.substring(0, _chosenValue.length - 2),
              );

          ref.child("smartID").set(uniquedeviceid.text);
          ref.child('moist').set(0);
          ref.child("hum").set(0);
          ref.child('temp').set(0.01);
          ref.child('zipcode').set(zipcode.text);
          ref.child('countrycode').set(countryCode);
          ref.child("changepass").set(false);
          ref
              .child("plantimg")
              .set(
                displayUrl.toString(),
              )
              .whenComplete(
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyNavBar();
                    },
                  ),
                ),
              );
          // This is for IOT Devices reference
          final deviceref =
              databaseReference.child('devices').child(uniquedeviceid.text);
          deviceref.child('plantname').set(_chosenValue);
          //TOD0: Chanage UID
          deviceref.child('uid').set(
                StorageUtil.getString("uid"),
              );
        });
      } catch (onError) {
        print("Error");
      }
      print("image URL is for this image : $imageUrl");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 35.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60.0),
                Text(
                  "Add your plant",
                  style: klargetextboldstyle,
                ),
                SizedBox(height: 40.0),
                _image == null
                    ? GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 150.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey.shade300,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera),
                              SizedBox(height: 5.0),
                              Text("Capture Image",
                                  style: GoogleFonts.redHatDisplay()),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: 150.0,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                // Text Feild
                SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.only(left: 3.0),
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonFormField<String>(
                    value: _chosenValue,
                    style: TextStyle(color: Colors.black),
                    items:
                        plantList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.substring(0, value.length - 2)),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose a Plant",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true,
                      focusedErrorBorder: kborder,
                      focusedBorder: kborder,
                      enabledBorder: kborder,
                      errorBorder: kborder,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please Select a Plant name' : null,
                  ),
                ),
                SizedBox(height: 12.0),
                // Device Unique ID Feild
                TextFields(
                  controller: uniquedeviceid,
                  name: 'Enter Unique ID',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter your IOT Unique ID';
                    }
                    return null;
                  },
                ),
                TextFields(
                  controller: zipcode,
                  name: 'Enter your Zipcode',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter your IOT Unique ID';
                    }
                    return null;
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[200],
                  ),
                  child: CountryListPick(
                    theme: CountryTheme(
                      isShowCode: false,
                      isDownIcon: false,
                      isShowTitle: true,
                      alphabetTextColor: Colors.black,
                      labelColor: Colors.black,
                      alphabetSelectedTextColor: Colors.black,
                      alphabetSelectedBackgroundColor: Colors.transparent,
                      showEnglishName: true,
                      isShowFlag: false,
                    ),
                    initialSelection: '+91',
                    onChanged: (CountryCode code) {
                      print(code.code);
                      setState(() {
                        countryCode = code.code;
                      });
                    },
                  ),
                ),
                SizedBox(height: 25.0),

                ElevatedButton(
                  child: Text("Submit", style: kdefaulttextstylewhite),
                  onPressed: () {
                    if (_formKey.currentState.validate() && _image != null) {
                      _formKey.currentState.save();
                      setState(() {
                        uploading = true;
                        if (uploading = true) {
                          //
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Container(
                                            height: 20.0,
                                            width: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5.0,
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Text('Hold on! Uploading'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        // All the data get Uploaded
                        upload();
                      });
                      uploading = false;
                    } else if (_image == null) {
                      flutterToast(
                          msg:
                              'Please Capture an Image Using your Phone Camera');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
