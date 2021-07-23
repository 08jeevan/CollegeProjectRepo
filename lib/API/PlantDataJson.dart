class DHT {
  var temp;
  var humidity;
  var moisture;
  var zipcode;
  final String plantimg;
  final String docID;
  final String countryCode;
  final String plantname;
  final String smartDeviceId;

  DHT({
    this.temp,
    this.humidity,
    this.moisture,
    this.plantimg,
    this.docID,
    this.zipcode,
    this.countryCode,
    this.plantname,
    this.smartDeviceId,
  });

  factory DHT.fromJson(Map<dynamic, dynamic> json) {
    return DHT(
      temp: json["temp"],
      humidity: json["hum"],
      moisture: json["moist"],
      plantimg: json["plantimg"],
      docID: json["smartID"],
      zipcode: json["zipcode"],
      countryCode: json["countrycode"],
      plantname: json["plantname"],
      smartDeviceId: json["smartID"],
    );
  }
}
