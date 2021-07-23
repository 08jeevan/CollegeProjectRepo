import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeproject/Provider/FirebaseHelper.dart';
import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Widgets/Toastandtextfeilds.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

FirebaseHelper firebaseHelper = FirebaseHelper();

class AskQustion extends StatefulWidget {
  @override
  _AskQustionState createState() => _AskQustionState();
}

class _AskQustionState extends State<AskQustion> {
  final _formKey = GlobalKey<FormState>();
  bool _enableBotton = false;
  String uniqudocid;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  randomgen() {
    String uid = randomAlphaNumeric(10);
    setState(() {
      uniqudocid = uid;
    });
  }

  @override
  void initState() {
    super.initState();
    randomgen();
  }

  File _image;
  String imageUrl;
  var displayUrl;
  final picker = ImagePicker();

  // DB Rederence
  Reference reference = FirebaseStorage.instance
      .ref()
      .child(
        StorageUtil.getString("uid"),
      )
      .child("Qusimage" + DateTime.now().toString());

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
    );
    uploadTask.whenComplete(() async {
      // When Image Upload is secussful the rest of the data will be pushed to
      // DB Including image URL from Storage
      try {
        imageUrl = await reference.getDownloadURL();
        setState(() {
          displayUrl = imageUrl;
          firebaseHelper.askaQustion(
              uniquedocid: uniqudocid,
              qus: qustitle.text,
              image: displayUrl.toString());
        });
      } catch (onError) {
        print("Error");
      }
    });
  }

  TextEditingController qustitle = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    qustitle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ask a Qustion"),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: (() {
            setState(() {
              _enableBotton = _formKey.currentState.validate();
            });
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Column(
              children: [
                TextFields(
                  maxLines: 10,
                  controller: qustitle,
                  name: "Enter your Qustion here",
                  validator: ((value) {
                    if (value.isEmpty) {
                      setState(() {
                        _enableBotton = true;
                      });
                      return 'Qustion is required';
                    }
                    return null;
                  }),
                ),
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
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: _enableBotton
                      ? (() async {
                          if (_image == null) {
                            firebaseHelper.askaQustion(
                              uniquedocid: uniqudocid,
                              qus: qustitle.text,
                              image: '',
                            );
                          }
                          upload();
                        })
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
