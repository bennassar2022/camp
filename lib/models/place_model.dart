import 'dart:convert';

PlaceModel placeModelFromJson(String str) => PlaceModel.fromJson(json.decode(str));
String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class PlaceModel {
  PlaceModel({
    required this.message,
    required this.data,
  });
  String message;
  List<Datum> data;
  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
    message: json["message"],
    data: List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
class Datum {
  Datum({
    required this.id,
   required this.userId,
   required this.city,
   required this.name,
   required this.description,
   required this.adresse,
   required this.longitude,
   required this.latitude,
   required this.images,
   required this.v,
  });

  String id;
  String userId;
  String city;
  String name;
  String description;
  String adresse;
  String longitude;
  String latitude;
  List images ;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    userId: json["user_id"],
    city: json["city"],
    name: json["Name"],
    description: json["description"],
    adresse: json["Adresse"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    images: json['images'],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {

    "_id": id,
    "user_id": userId,
    "city": city,
    "Name": name,
    "description": description,
    "Adresse": adresse,
    "longitude": longitude,
    "latitude": latitude,
    "images": List<String>.from(images.map((x) => x)),
    "__v": v,
  };
}
