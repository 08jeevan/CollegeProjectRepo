// import 'package:collegeproject/Constants/FontsAndIcons.dart';
// import 'package:collegeproject/Provider/SharedPref.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class DHTS {
//   var high;
//   var low;
//   var count;

//   DHTS({
//     this.high,
//     this.low,
//     this.count,
//   });

//   factory DHTS.fromJson(Map<dynamic, dynamic> json) {
//     return DHTS(
//       high: json["hightoday"],
//       low: json["lowtoday"],
//       count: json["motorcount"],
//     );
//   }
// }

// class ChartsScreen extends StatefulWidget {
//   @override
//   _ChartsScreenState createState() => _ChartsScreenState();
// }

// class _ChartsScreenState extends State<ChartsScreen> {
//   final databaseReference = FirebaseDatabase.instance.reference();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter Charts Sample")),
//       body: StreamBuilder(
//         stream: databaseReference
//             .child(
//               StorageUtil.getString("uid"),
//             )
//             .child('PlantData')
//             .child('deviceid01')
//             .onValue,
//         builder: (context, snapshot) {
//           if (snapshot.hasData &&
//               !snapshot.hasError &&
//               snapshot.data.snapshot.value != null) {
//             var _dhts = DHTS.fromJson(snapshot.data.snapshot.value['lodData']);

//             return Container(
//               height: 400,
//               padding: EdgeInsets.all(20),
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 width: double.infinity,
//                 child: LineChart(
//                   LineChartData(
//                       borderData: FlBorderData(show: false),
//                       lineBarsData: [
//                         LineChartBarData(spots: [
//                           FlSpot(_dhts.high, 1),
//                           FlSpot(1, 3),
//                           FlSpot(2, 10),
//                           FlSpot(3, 7),
//                           FlSpot(4, 12),
//                           FlSpot(5, 13),
//                           FlSpot(6, 17),
//                           FlSpot(7, 15),
//                           FlSpot(8, 20)
//                         ])
//                       ]),
//                 ),
//               ),
//             );
//           } else {
//             return Center(
//               child: Text("NO DATA FOUND😢", style: kdefaulttextstyleblack),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
