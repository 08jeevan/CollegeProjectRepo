import 'package:collegeproject/API/WeatherApi.dart';
import 'package:flutter/material.dart';

Widget weatherBox(Weather _weather, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.red,
      ),
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          // Expanded(
          //   child: Container(
          //     child: Text("The Weather is too" +
          //         _weather.main +
          //         ". It may ...... toady"),
          //   ),
          // ),
          Container(
            width: 50.0,
            color: Colors.green,
            child: Container(
              height: 30.0,
              width: 30.0,

              //   child: Image.network('http://openweathermap.org/img/wn/' +
              //       _weather.icon +
              //       '@2x.png'),
            ),
          ),
        ],
      ),
    ),
  );
}


// Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//     Container(
//         margin: const EdgeInsets.all(10.0),
//         child: Text(
//           "${_weather.temp}°C",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
//         )),
//     Container(
//         margin: const EdgeInsets.all(5.0),
//         child: Text("${_weather.description}")),
//     Container(
//         margin: const EdgeInsets.all(5.0), child: Text("${_weather.place}")),
//     Container(
//         margin: const EdgeInsets.all(5.0),
//         child: Text("Feels:${_weather.feelsLike}°C")),
//     Container(
//         margin: const EdgeInsets.all(5.0),
//         child: Text("H:${_weather.high}°C L:${_weather.low}°C")),
//   ]);

