class DHT {
  final double temp;
  final int humidity;
  final int moisture;
  final String plantimg;
  final String docID;

  DHT({this.temp, this.humidity, this.moisture, this.plantimg, this.docID});

  factory DHT.fromJson(Map<dynamic, dynamic> json) {
    return DHT(
      temp: json["temp"],
      humidity: json["hum"],
      moisture: json["moist"],
      plantimg: json["plantimg"],
      docID: json["smartID"],
    );
  }

  // factory DHT.fromJson(Map<dynamic, dynamic> json) {
  //   double parser(dynamic source) {
  //     try {
  //       return double.parse(source.toString());
  //     } on FormatException {
  //       return null;
  //     }
  //   }

  //   return DHT(
  //     temp: parser(json['tem']),
  //     humidity: parser(json['hum']),
  //     moisture: parser(json['mois']),
  //   );
}
