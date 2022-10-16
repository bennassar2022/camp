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
  }

  @override
  Widget build(BuildContext context) {
    print("imagesPlace ${widget.imagesPlace!.length}");
    return Scaffold(
        appBar: AppBar(
          title: Text('Details place'),
          backgroundColor: Colors.green,
          actions: [
            widget.isAuteur!
                ? IconButton(
                    icon: Icon(Icons.delete_forever_sharp),
                    onPressed: () {
                      deletePlace(widget.placeId!);
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
                          left: 15.0, right: 20.0, top: 15.0),
                      padding: const EdgeInsets.all(10.0),
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
                                      width: 240,
                                      height: 150,
                                      child: Image.network(widget.imagesPlace![
                                          index]), // display list of images of cities
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
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        obscureText: true,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.cabin),
                          border: InputBorder.none,
                          hintText: widget.placeName,
                           hintStyle: TextStyle(color: Colors.black),

                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        obscureText: true,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.place ),
                          border: InputBorder.none,
                          hintText: widget.placeAddress,
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 15,color: Colors.black),
                        children: <TextSpan>[
                          
                             TextSpan(text: 'description : ', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15) ),
                             
                              TextSpan(text: " ${widget.placeDescription}"),

  
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "if you like this place can you add in your program",
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                    //   SizedBox(height:5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Background color
                      ),
                      child: const Text('program'),
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
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .green, // Background color
                                            ),
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
                      },
                    ),
                    const SizedBox(height: 20.0),
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
