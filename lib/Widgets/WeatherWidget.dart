import 'package:collegeproject/API/WeatherApi.dart';
import 'package:collegeproject/Constants/FontsAndIcons.dart';
import 'package:flutter/material.dart';

Widget weatherBox(Weather _weather, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.purple[200],
      ),
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(_weather.main, style: klargetextboldwhitestyle),
                ),
                Container(
                  child: Text("at " + _weather.place,
                      style: kdefaulttextstylewhite),
                ),
              ],
            ),
          ),
          Container(
            child: Container(
              height: 50.0,
              width: 50.0,
              child: Image.network(
                'http://openweathermap.org/img/wn/' + _weather.icon + '@2x.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
