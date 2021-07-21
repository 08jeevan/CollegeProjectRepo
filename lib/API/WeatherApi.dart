import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Weather> fetchPost({String zipcode, String countrycode}) async {
  String apiKey = "1370b1cf0e3475f1d6aa834f5449535c";
  String units = "metric";

  var url =
      "http://api.openweathermap.org/data/2.5/weather?zip=$zipcode,$countrycode&appid=$apiKey&units=$units";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Weather {
  final String main;
  final double feelsLike;
  final String description;
  final String place;
  final String icon;

  Weather({this.main, this.feelsLike, this.description, this.place, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['weather'][0]['main'].toString(),
      feelsLike: json['main']['feels_like'].toDouble(),
      description: json['weather'][0]['description'],
      place: json['name'],
      icon: json['weather'][0]['icon'].toString(),
    );
  }
}
