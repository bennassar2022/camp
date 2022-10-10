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
                        "https://appcamping.herokuapp.com/api/deleteplaces/$placeId";

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
                                        child: /*Image.memory(base64.decode(
                                            widget.imagesPlace![index].trim()
                                            ))*/
                                        Image.network(
                                          //show image 0 of the list
                                            widget.imagesPlace![index]
                                        ),
                                    )
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
                   //  textColor: Colors.white,
                   //   color: Colors.green,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Background color
                      ),

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
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Background color
                          ),
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
          (Uri.parse('https://appcamping.herokuapp.com/api/Addprogram')),
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
              'https://appcamping.herokuapp.com/api/Updateplaces/${widget.placeId!}')),
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
