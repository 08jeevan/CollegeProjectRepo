import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:flutter/material.dart';

Widget loadingIndicator({String text}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 18.0,
        width: 18.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
      SizedBox(width: 8.0),
      Text(
        text,
        style: kdefaulttextstyleblack,
      ),
    ],
  );
}
