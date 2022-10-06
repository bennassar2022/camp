import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camping/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlaceDetailsPage extends StatefulWidget {
  List<String>? imagesPlace;
  String? placeName;
  String? placeId;
  String? state;
  String? placeDescription;
  String? placeAddress;
  bool? isAuteur;
  String? latitude;
  String? longitude;
  String? cityImages;

  PlaceDetailsPage(
      this.imagesPlace,
      this.placeName,
      this.placeId,
      this.state,
      this.placeDescription,
      this.placeAddress,
      this.isAuteur,
      this.latitude,
      this.longitude,
      this.cityImages);

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  DateTime startDateSelected = DateTime.now();

  DateTime endDateSelected = DateTime.now();

  TextEditingController startDate = TextEditingController();

  TextEditingController endDate = TextEditingController();

  TextEditingController? namePlaceController = TextEditingController();

  TextEditingController? descriptionPlaceController = TextEditingController();

  TextEditingController? addressPlaceController = TextEditingController();

  deletePlace(String placeId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
              title: new Text('Delete place'),
              content: new Text('are you sure to delete this place ??'),
              actions: <Widget>[
                TextButton(
                  child: const Text('NO', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('delete',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () async {
                    // delete place
                    var url =
                        "https://192.168.1.15:3000/api/deleteplaces/$placeId";

                    var res = await http.delete((Uri.parse(url)));
                    if (res.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          "Success delete place..",
                          style: TextStyle(color: Colors.white),
                        ),
                      ));

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfilePage()),
                          (Route<dynamic> route) => false);
                    }
                  },
                )
              ],
            ));
    // return AlertDialog(
    //   title: const Text('Delete place'),
    //   content: SingleChildScrollView(
    //     child: ListBody(
    //       children: const <Widget>[
    //         Text('are you sure to delete this place ??', style: TextStyle(fontSize: 15.0),),
    //         //   Text('Would you like to approve of this message?'),
    //       ],
    //     ),
    //   ),
    //   actions: <Widget>[
    //     TextButton(
    //       child: const Text('Delete',
    //           style: TextStyle(color: Colors.red)),
    //       onPressed: () async {
    //         // delete place
    //              var url = "http://192.168.100.152:4000/api/deleteplaces/$placeId";
    //
    // var jsonResponse;
    // var res = await http.delete((Uri.parse(url)));
    // if (res.statusCode == 200) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Colors.lightGreen,
    //     content: Text("Success delete place..", style: TextStyle(color: Colors.white),),
    //   ));
    //
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (BuildContext context) => ProfilePage()),
    //           (Route<dynamic> route) => false);
    // }
    //       },
    //     ),
    //     TextButton(
    //       child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    print("imagesPlace ${widget.imagesPlace!.length}");
    return Scaffold(
        appBar: AppBar(
          title: Text('Details place'),backgroundColor: Colors.green,
          actions: [
            widget.isAuteur!
                ? IconButton(
                    icon: Icon(
                      Icons.delete_forever_outlined,
                    ),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) =>
                      deletePlace(widget.placeId!); //),);
                    },
                  )
                : SizedBox(),
          ],
        ),
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
                height: 600,
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 20.0, top: 5.0),
                      padding: const EdgeInsets.all(12.0),
                      child: widget.imagesPlace!.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.imagesPlace!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () => {},
                                  child: Column(children: [
                                    Container(
                                        width: 200,
                                        height: 150,
                                        // margin: const EdgeInsets.all(10),
                                        // padding: const EdgeInsets.all(15),
                                        /* decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/city/gabes.jpg"),
                                            fit: BoxFit.cover),
                                      ),*/
                                        child: Image.memory(base64.decode(
                                            widget.imagesPlace![index].trim()
                                            // "/9j/4QFwRXhpZgAATU0AKgAAAAgABwEAAAQAAAABAAADwAEQAAIAAAAUAAAAYgEBAAQAAAABAAAFAAEPAAIAAAAHAAAAdodpAAQAAAABAAAAkQESAAMAAAABAAEAAAEyAAIAAAAUAAAAfQAAAABzZGtfZ3Bob25lNjRfeDg2XzY0AEdvb2dsZQAyMDIyOjA4OjE1IDA5OjMzOjE0AAAHpAMAAwAAAAEAAAAAkgoABQAAAAEAAADrgpoABQAAAAEAAADziCcAAwAAAAEAZAAAkgkAAwAAAAEAAAAAkggABAAAAAEAAAAAgp0ABQAAAAEAAAD7AAAAAAAAE4gAAAPoAAAAZAAAJxAAAG1gAAAnEAAEARAAAgAAABQAAAE5AQ8AAgAAAAcAAAFNARIAAwAAAAEAAQAAATIAAgAAABQAAAFUAAAAAHNka19ncGhvbmU2NF94ODZfNjQAR29vZ2xlADIwMjI6MDg6MTUgMDk6MzM6MTQA/+AAEEpGSUYAAQEAAAEAAQAA/+ICKElDQ19QUk9GSUxFAAEBAAACGAAAAAACEAAAbW50clJHQiBYWVogAAAAAAAAAAAAAAAAYWNzcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAPbWAAEAAAAA0y0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJZGVzYwAAAPAAAAB0clhZWgAAAWQAAAAUZ1hZWgAAAXgAAAAUYlhZWgAAAYwAAAAUclRSQwAAAaAAAAAoZ1RSQwAAAaAAAAAoYlRSQwAAAaAAAAAod3RwdAAAAcgAAAAUY3BydAAAAdwAAAA8bWx1YwAAAAAAAAABAAAADGVuVVMAAABYAAAAHABzAFIARwBCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9wYXJhAAAAAAAEAAAAAmZmAADypwAADVkAABPQAAAKWwAAAAAAAAAAWFlaIAAAAAAAAPbWAAEAAAAA0y1tbHVjAAAAAAAAAAEAAAAMZW5VUwAAACAAAAAcAEcAbwBvAGcAbABlACAASQBuAGMALgAgADIAMAAxADb/2wBDAKBueIx4ZKCMgoy0qqC+8P//8Nzc8P//////////////////////////////////////////////////////////2wBDAaq0tPDS8P//////////////////////////////////////////////////////////////////////////////wAARCAUAA8ADASIAAhEBAxEB/8QAGAABAQEBAQAAAAAAAAAAAAAAAAECAwT/xAAiEAEAAgICAwEBAQEBAAAAAAAAARECMRJRITJBA2EiQoH/xAAWAQEBAQAAAAAAAAAAAAAAAAAAAQL/xAAWEQEBAQAAAAAAAAAAAAAAAAAAARH/2gAMAwEAAhEDEQA/AKAigAAAAAAAIKAgqAAAAAAAAAAAAAAAAAAAAAAAIoCCgIAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2AAAAAAAAigIKACAKIoIKAgqAAAAAAAAAAAAAAAAAAAAAAAAAgqAAAAAAAAAAAAAAAAAAAAACKCCgIKgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANgAAAAAAAAAAAAAIoCCgIogKgAAoIAAAAAAAAAAAAAAAAAAAAIAqAAAAAAAAAAAAAAAAAAAAACCgIqAKgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2AAAAAAAAAAAAAAAAAAAAAAigIKAgAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAACACgIKgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANioIAAACgAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAigIAAAAAAAAAAAAAAAAAAigIogKIAoigIoCCoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADoigiCoAAKAAAAAAAAAAAAAAAAAAAAAAAgKgAAAAAAAAAAAAAAgKioAAAAAAAAAAAAAAAAAAAAAigIKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANigiKA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ABBAEtRRLAVAAAAVAFAARUB0paUBKFAQAAAAAAEBRCwUQBRAFEAW0soAtFEEKUUSgBQBAAAAAEAUQBUBUAAEUBBQEAAAAAAAAAAAAAAAAAAWJQBpWViUUVAFEUAAEAAAAAAAARQEABBRUQAEFAQAAAAABUUAVEUAEEtZ0igAAAAAAAAACgAAA6oAAWWAIApaAFgIAIAAoKAFLQAAAAlgqFpYKgIAIKogqAAAAAAAAAAAACKAioAqAAAAAAAAKAgoCKAIKAgoABQAtLQIKlIAAoqAAAAAAAAAAAAAIKAiKAgqKgACCgIAAsaRYBQEURUVCUWUAAAAAAAAAABQAEVAdaQ5QlgpaFAWWUAeSgABUVBQEFQBUAUEEWy0FCwAQUBAUEFAQVAAAAAAAAAAQFQAAAAUEFAQUBFAAUBFABAAAABQSliABQAAAASwAsAAQABQAAAAAAAAAAABFAQVAEUUQVBAAAgIBQEVAFQRUAAAAAFAQUBAAFRQEUBoLSwUCkAUFQUBFAAEBUAQAFAFAAAAAAAAQEAAAAAAAAQFsQBUAAAAUBFAAABUUAFQRQBABQEVFQAFQBRAFEsBbLQAsAAAAAFELBQsRQAAAAAAAAAAAAABFAQVAEUUQARQEVAFQAAAAAAAAAAAAAAABQUUVFQAQFEUAQAAAAUAAABAAAEBUAAAAAAACgssBFQAAAFBBQAAAAAAAAAAFLQBbS0AWxFAAAAAAABAVAABQRQABQRGkBBQAsAURUAAUAAAAAAAAAAAARQEAAAAABAVUQVAAAAAAAAAAAAAAAaARVEAVAAAUAAABAAAAEFAQAAAAAAAEABRAFQUEFAAAAAAAAAAAAQFEAVAAAAABRAFEAVAAFARQAAAABQABAFQAAAAAAQFtWQGi0hUUAAAAAAAAAAAAAAABBUBBaRUAAAAAAAAAAAAAAAAaAFAAAAAAAAAQFAEAAAQAAAAAAAAAAAAAAAAAAAAAEBRAFEAVAAFAQVAAAAABQEFAAAAAAAAAAAAAAAAAAAEAAAAABYlEBsZiaaQABQAAAAAAAAAAAASwQAFAAQUEQVFAAAAAAAAAAGgEUBFFEBFQAAAUQAVAAAAAAAAAAAAAAAAAAAAAARQBAAAAAAUAAAAARQAFBBQEFQAAAAAAAEBRAFQAFQBRAFQAAAAABAFEUAAAAFiVZIkGgEUAAAAC0sRUsKAKAAAUAAAAAAAEAAEUBBQEFQABRoAEAAVAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAABQAAAAAAAAAUQBRAFQAAABAAABUAVAAAAAAAAAAEAURQAAAAAAAAAAFiUAaGYlpARQVKUBEUQVUFBBUAAAAAAAAAAAAAAEARQAoGksABFBFAAAAAAAAAAAAAAAAAAABAAAAAAAABQQUAAAAAAAAAAAAAAAAAAABAVAAAAAAAAAAAABAUQBUFBBQAAAAAAAAAAAQAAAABqJVhYkGgEAAVAAURQQVAAAAAAAAAABBFASlAAAABQAAAAAAAAAAAAAAAAAAAARUAFAQUBBQAAAAAAAAAAAAAAAEBRAFQAAAAAAAAAAAAAAAAAAAQAAUAAAAAAAAAABAAAUEAAAAAAABViWQGxmJaARRFQVAAAAURABQAAAAAAAAAAAABUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAFQAAAAAAAAAAAAAAAAAAQFEAVAAVFAAAAAAAAAAAAARUAVAAAFEAVAAAAAAAAAALoAaibVhYkGgEVBQEABUAAUBAAAAAAAAAAAFQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAUQAAAAAAAAAAAAAAAAAEAUQABQQUAAAAAAAAAAAAAAAAARUAAAAAAAAAAAAAAAAAAAAAAA01E2yA2MxLSAigqCoAACiAAqAAAAAAAAKgAAAAAAAAAAAAAAAAAAAAAAAAIAqAAAAAAAAAAAAAAAAAAAAAAgACgAAAAAAAAAAAAAAAAAAAICiAAAAAAAAAAAAAAAAAAAAAAAAAAAAANRNqwsSDQCKgoCAAKgACiIAKAAAKgAAAAAAKAgoCKgCoAAAAgCoKCAAAAAAAAAAAAAAAAAAAAAAAAgoCCgAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALELQEaVFRQABFAQVAAAVAAAAAVAAAAAAFEAVAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQFEAVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFiFBIhaFQRQFAAAAAAAAQUEQAAAUAVAAAAAAAQAAAVAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWIUEpQBRFQABQAAAAAQAFAAAAEUBBUEARRRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEBRAFEAAAAAAAAAAAAAAAAUEAAAAAAAAAAAAAAAAAoAWIUEiFFQRQFAAQVAURRAAUAAAAAEABQAAAAARkBQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKAKWIUEiFFQRQFAAAAAAAAQUBFQBQBAAUAAAEAAABQAGQFQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoApqIASIUEBQFAAAAAAAAAAAAAAEUBFEBQAAAAAAAAAAAf/Z"
                                            )))
                                  ]),
                                );
                              })
                          : Text(
                              "No places added in this city..",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                    )),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        controller: namePlaceController,
                        enabled: widget.isAuteur! ? true : false,
                        decoration: InputDecoration(
                          border:
                              widget.isAuteur! ? OutlineInputBorder() : null,
                          labelText: widget.isAuteur! ? 'Place name' : null,
                          hintText: widget.placeName,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        controller: descriptionPlaceController,
                        enabled: widget.isAuteur! ? true : false,
                        decoration: InputDecoration(
                          border:
                              widget.isAuteur! ? OutlineInputBorder() : null,
                          labelText:
                              widget.isAuteur! ? 'Place description' : null,
                          hintText: widget.placeDescription,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        obscureText: true,
                        enabled: false,
                        decoration: InputDecoration(
                          border:
                              widget.isAuteur! ? OutlineInputBorder() : null,
                          // labelText: widget.isAuteur! ? 'Place address' : null,
                          hintText: widget.placeAddress,
                        ),
                      ),
                    ),
                    ElevatedButton(
                   ///   textColor: Colors.white,
                   //   color: Colors.green,
                      child: const Text('Camp program'),
                      onPressed: () => {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter mystate) {
                              return SingleChildScrollView(
                                  child: Stack(children: <Widget>[
                                Container(
                                    height: 350,
                                    width: double.infinity,
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            _selectDateStart(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(20.0),
                                            padding: EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.grey.shade200,
                                            ),
                                            child: TextField(
                                              enabled: false,
                                              controller: startDate,
                                              decoration: InputDecoration(
                                                border: widget.isAuteur!
                                                    ? OutlineInputBorder()
                                                    : null,
                                                hintText: "start date",
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _selectDateEnd(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(20.0),
                                            padding: EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.grey.shade200,
                                            ),
                                            child: TextField(
                                              enabled: false,
                                              controller: endDate,
                                              decoration: InputDecoration(
                                                border: widget.isAuteur!
                                                    ? OutlineInputBorder()
                                                    : null,
                                                hintText: "end date",
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              int respCode = await addProgram(
                                                  context,
                                                  startDate.text.toString(),
                                                  endDate.text.toString(),
                                                  widget.state!,
                                                  widget.placeName!,
                                                  widget.placeId!);
                                              if (respCode == 200) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    'Success adding program!',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white),
                                                  ),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    'Please choose date start and date end!',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white),
                                                  ),
                                                ));
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child:
                                                const Text("Add to my program"))
                                      ],
                                    ))
                              ]));
                            });
                          },
                        )
                        // displayDialogCampProgram(context)
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Visibility(
                        visible: widget.isAuteur!,
                        child: ElevatedButton(
                       //   textColor: Colors.white,
                      //    color: Colors.blue,
                          child: const Text('Update place'),
                          onPressed: () async {
                            int respCode = await editPlace(
                                context,
                                namePlaceController!.text.toString().trim(),
                                descriptionPlaceController!.text
                                    .toString()
                                    .trim());
                            if (respCode == 200) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  'Place updated successfully..',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'something went wrong!',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ));
                            }
                          },
                        ))
                  ],
                ))
          ]));
        }));
  }

  Widget displayDialogCampProgram(context) {
    return Dialog(
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("start date",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.calendar_today_outlined),
                    color: Colors.white,
                    onPressed: () => {_selectDateStart(context)},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("end date",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.calendar_today_outlined),
                    color: Colors.white,
                    onPressed: () => {_selectDateEnd(context)},
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  //  addProgram(context, startDate, endDate, state, widget.placeName, placeId);
                  Navigator.of(context).pop();
                },
                child: Text("Add to my program"))
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateStart(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
        onChanged: (date) {
      print('change1 $date');
    }, onConfirm: (date) {
      print('confirm1 $date');
      startDateSelected = date;
      startDate.text = "${date.day} - ${date.month} - ${date.year}";
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    /*final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDateSelected,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDateSelected) {
      // setState(() {
      startDateSelected = picked;
      // });
    }*/
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    (startDate.text != "")
        ? DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: startDateSelected,
            maxTime: DateTime(DateTime.now().year + 1, DateTime.now().month,
                DateTime.now().day), onChanged: (date) {
            print('change2 $date');
          }, onConfirm: (date) {
            print('confirm2 $date');
            endDate.text = "${date.day} - ${date.month} - ${date.year}";
          }, currentTime: DateTime.now(), locale: LocaleType.en)
        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Select start date first!',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ));
    /*final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDateSelected,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDateSelected) {
      // setState(() {
      endDateSelected = picked;
      // });
    }*/
  }
  Future<int> addProgram(context, String startDate, String endDate,
      String state, String placeName, String placeId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (startDate != "" && endDate != "") {
      var responseAddProgram = await http.post(
          (Uri.parse('http://192.168.1.110:3000/api/Addprogram')),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'start': startDate,
            'end': endDate,
            'email': sharedPreferences.getString('email').toString(),
            'user_id': sharedPreferences.getString('token').toString(),
            'state': state,
            'place_Name': placeName,
            'place_id': placeId,
          }));

      return responseAddProgram.statusCode;
    } else {
      return 300;
    }
  }

  Future<int> editPlace(context, String name, String description) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print("placeId : ${widget.placeId!}");

    if (name != "" && name.length > 3) {
      var responseEditPlace = await http.put(
          (Uri.parse(
              'http://192.168.1.15:3000/api/Updateplaces/${widget.placeId!}')),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'Name': name,
            'description': description.isEmpty ? "" : description,
            // 'user_id': sharedPreferences.getString('token').toString(),
            // 'city': widget.state!,
            // 'Adresse': widget.placeAddress!,
            // 'latitude': widget.latitude!,
            // 'longitude': widget.longitude!,
            // 'images': widget.cityImages!,
          }));

      return responseEditPlace.statusCode;
    } else {
      return 300;
    }
  }
}

class Carousel extends StatefulWidget {
  List<String>? imagesPlace;

  Carousel(this.imagesPlace, {Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;

  int activePage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: PageView.builder(
              itemCount: widget.imagesPlace!.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return slider(widget.imagesPlace, pagePosition, active);
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(widget.imagesPlace!.length, activePage))
      ],
    );
  }
}

AnimatedContainer slider(images, pagePosition, active) {
  double margin = active ? 10 : 20;

  return AnimatedContainer(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
    margin: EdgeInsets.all(margin),
    decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(images[pagePosition]))),
  );
}

imageAnimation(PageController animation, images, pagePosition) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, widget) {
      print(pagePosition);

      return SizedBox(
        width: 200,
        height: 200,
        child: widget,
      );
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      child: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: images[pagePosition],
      ),
    ),
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
