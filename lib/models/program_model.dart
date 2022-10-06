import 'dart:convert';

ProgramModel programModelFromJson(String str) => ProgramModel.fromJson(json.decode(str));

String programModelToJson(ProgramModel data) => json.encode(data.toJson());

class ProgramModel {
  ProgramModel({
    required this.message,
    required this.data,
  });

  String message;
  List<Program> data;

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
    message: json["message"],
    data: List<Program>.from(json["data"].map((x) => Program.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Program {
  Program({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.start,
    required this.end,
    required this.state,
    required this.email,
    required this.v,
  });

  String id;
  String userId;
  String placeId;
  String placeName;
  String start;
  String end;
  String state;
  String email;
  int v;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    id: json["_id"],
    userId: json["user_id"],
    placeId: json["place_id"],
    placeName: json["place_Name"],
    start: json["start"],
    end: json["end"],
    state: json["state"],
    email: json["email"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "place_id": placeId,
    "place_Name": placeName,
    "start": start,
    "end": end,
    "state": state,
    "email": email,
    "__v": v,
  };
}
