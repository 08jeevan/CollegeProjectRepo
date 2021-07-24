import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:flutter/material.dart';

class Deleteafile extends StatelessWidget {
  final String text;
  final String imagepath;
  final Function onTap;

  Deleteafile({context, this.text, this.onTap, this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 85.0,
              width: 85.0,
              child: Image.asset(imagepath, fit: BoxFit.contain),
            ),
            SizedBox(height: 15.0),
            Text(
              text,
              style: kmediumtextstyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close", style: kdefaulttextstyleblack),
          ),
          ElevatedButton(
            onPressed: onTap,
            child: Text("Yes", style: kdefaulttextstylewhite),
          ),
        ],
      ),
    );
  }
}
