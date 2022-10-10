import 'dart:convert';
import 'dart:io';
import 'package:camping/common/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/services.dart';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPlacePage extends StatefulWidget {
  String city;
  String? userId;

  AddPlacePage(this.city, this.userId);

  @override
  State<StatefulWidget> createState() {
    return _AddPlacePageState();
  }
}

class _AddPlacePageState extends State<AddPlacePage> {
  SharedPreferences? sharedPreferences;
  var fileee;

  double stepZoom = 1;
  double initZoom = 2;
  double minZoomLevel = 2;
  double maxZoomLevel = 18;

  TextEditingController namePlaceController = TextEditingController();
  TextEditingController descriptionPlaceController = TextEditingController();
  TextEditingController locationPlaceController = TextEditingController();

  String placeLatitude = "", placeLongitude = "";
  String _address = 'Unknown Location Found';

  List<Asset> images = <Asset>[];
  List<XFile>? imageFileList = [];
  List<String> imageList = [];
  List<String> imageListBase64 = [];

  @override
  void initState() {
    initPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create place'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: namePlaceController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Place name",
                      hintText: "Enter place name",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: descriptionPlaceController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Place description",
                      hintText: "Enter place description",
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    onTap: () => {pickPlace(context)},
                    controller: locationPlaceController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Place location",
                      hintText: "Pick place location",
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Pick images"),
                  onPressed: () async {
                    // loadAssets();
                    final ImagePicker imagePicker = ImagePicker();
                    // void selectImages() async {
                    final List<XFile>? selectedImages =
                        await imagePicker.pickMultiImage(imageQuality: 25);
                    if (selectedImages!.isNotEmpty) {
                      imageFileList!.addAll(selectedImages);
                    }
                    setState(() {
                      // imageFileList
                    });
                    //  }
                  },
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GridView.builder(
                      itemCount: imageFileList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(File(imageFileList![index].path),
                            fit: BoxFit.cover);
                      }),
                )),
                ElevatedButton(
                    onPressed: () {
                      addPlace(context, namePlaceController.text.toString(),
                          descriptionPlaceController.text.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Background color
                    ),
                    child: Text("Add place"))
              ],
            )));
  }

  void pickPlace(context) async {
    GeoPoint? p = await showSimplePickerLocation(
      // initPosition: GeoPoint(latitude: 33.8442511, longitude: 10.096685),
      context: context,
      isDismissible: true,
      title: "Pick place",
      textConfirmPicker: "pick",
      initCurrentUserPosition: true,
      stepZoom: stepZoom,
      initZoom: initZoom,
      minZoomLevel: minZoomLevel,
      maxZoomLevel: maxZoomLevel,
    );

    print("latitude , lngtidue : ${p?.latitude}, ${p?.longitude}");
    var response = await http.get((Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${p?.latitude}&lon=${p?.longitude}')));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      _address = jsonResponse['display_name'];
    }

    locationPlaceController.text = _address;
    placeLatitude = p!.latitude.toString();
    placeLongitude = p.longitude.toString();

    print(placeLatitude + ", " + placeLongitude);
  }

  List<Asset> imagesList = <Asset>[];
  String _error = 'No Error Detected';
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: imagesList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      imagesList = resultList;
      _error = error;
    });
  }

  void addPlace(context, String namePlace, String descriptionPlace) async {
    if (namePlace != "" &&
        placeLatitude != "" &&
        placeLongitude != "" &&
        _address != "Unknown Location Found") {
      try {
        final url = Uri.parse('https://appcamping.herokuapp.com/api/Addplaces');
        Map<String, dynamic> requestBody = <String, dynamic>{
          "user_id": widget.userId! /*"62ec40d875453df034eccd70"*/,
          "Name": namePlace,
          "Adresse": _address,
          "city": widget.city,
          "longitude": placeLongitude,
          "latitude": placeLatitude,
          "description": descriptionPlace.isEmpty ? "" : descriptionPlace,
        };

        print('requestBody : $requestBody');

        //add list of image

        //    var request = http.MultipartRequest('POST', url)
        //  ..fields.addAll(requestBody);
        List<MultipartFile> newList = <MultipartFile>[];
        for (XFile xfile in imageFileList!) {
          //    File imageFile = File(xfile.path); //convert Path to File
          //    var stream = new http.ByteStream(imageFile.openRead());
          //   var length = await imageFile.length();
          //    var multipartFile = new http.MultipartFile("images", stream, length,
          //       filename: basename(imageFile.path));
          newList.add(await MultipartFile.fromFile(xfile.path,
              contentType: MediaType("image", "jpg")));
        }
        requestBody.addAll({"images": newList});
        FormData formData = FormData.fromMap(requestBody);

        print("newList " + newList.toString());
        //   request.files.addAll(newList);

        final response = await RestClient().dio.post("https://appcamping.herokuapp.com/api/Addplaces", data: formData);


        //       await RestClient().dio.post("/api/Addplaces", data: formData);


        //  var response = await request.send();
        // final respStr = await response.stream.bytesToString();
        print(response.data);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Success adding place!',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              response.data.toString(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ));
        }
      } catch (error) {
        print(error);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Please fill all fields!',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
        ),
      ));
    }
  }

  void initPlatform() async {
    // await controller.currentPosition();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> pickImages2() async {
    final ImagePicker imagePicker = ImagePicker();
    void selectImages() async {
      final List<XFile>? selectedImages =
          await imagePicker.pickMultiImage(imageQuality: 25);
      if (selectedImages!.isNotEmpty) {
        imageFileList!.addAll(selectedImages);
      }
      setState(() {
        // imageFileList
      });
    }
  }

  Future<void> pickImages() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Flutter Camp App",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    setState(() {
      images = resultList;
    });
  }
}
