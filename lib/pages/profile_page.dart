import 'dart:convert';
import 'dart:io';
import 'package:camping/pages/add_place.dart';
import 'package:camping/pages/place_details_page.dart';
import 'package:camping/pages/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        Alignment,
        AnnotatedRegion,
        AppBar,
        AssetImage,
        Axis,
        BorderRadius,
        BottomSheet,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Center,
        CircleAvatar,
        CircularProgressIndicator,
        ClipRRect,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        DecorationImage,
        Drawer,
        DrawerHeader,
        EdgeInsets,
        ElevatedButton,
        FloatingActionButton,
        FontWeight,
        IconButton,
        Icons,
        Image,
        InkWell,
        InputBorder,
        InputDecoration,
        LinearGradient,
        ListTile,
        ListView,
        MainAxisAlignment,
        MaterialButton,
        MaterialPageRoute,
        MediaQuery,
        Padding,
        PreferredSize,
        Radius,
        RaisedButton,
        RoundedRectangleBorder,
        Row,
        Scaffold,
        SingleChildScrollView,
        Size,
        Stack,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextField,
        TextStyle,
        Theme,
        Widget,
        showDialog,
        showModalBottomSheet;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/place_model.dart';
import 'All_programs.dart';
import 'forgat_password_verification_page.dart';
import 'forgot_password_page.dart';
import 'login_page.dart';
import 'my_program_page.dart';
import 'registration_page.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences? sharedPreferences;
  bool _show = false;

  List<PlaceModel>? futureData;
  List<String> imagesPlace = [];
  String placeId = "";
  String placeName = "";
  String placeDescription = "";
  String placeAddress = "";
  bool isAuteur = false;
  List<Datum> citiesNames = [];
  @override
  void initState() {
    super.initState();
    initPlatforme();
  }

  List<Datum> jsonResponse = [];
  Future getPlaceByCity(city) async {
    citiesNames.clear();
    var res = await http.post(
      Uri.parse('https://appcamping.herokuapp.com/api/places'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'city': city,
      }),
    );
    if (res.statusCode == 200) {
      var jsonString = json.decode(res.body);
      final placeModel = placeModelFromJson(res.body);
      print("response placeByCity : " + placeModel.toString());
      jsonResponse.addAll(placeModel.data);
      print("response jsonResponse : " + jsonResponse.toString());
      print("response response.body : " + res.body);
      // return jsonResponse.map((data) => new PlaceModel.fromJson(data)).toList();
      setState(() {
        citiesNames = jsonResponse;
      });
    } else {
      print("Response status : ${res.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> citiesImages = [];

    return Scaffold(
      drawer: Container(
        width: 230,
        height: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle_sharp),
                title: Text('My programs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProgram()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('All programs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllPrograms()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => new AlertDialog(
                            title: new Text('Signout'),
                            content:
                                new Text('Are you sure you want to signout ?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('NO',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('signout',
                                    style: TextStyle(color: Colors.grey)),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  sharedPreferences?.setString("token", "");
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SplashScreen()),
                                      (Route<dynamic> route) => false);
                                },
                              )
                            ],
                          ));
                },
              ),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: AppBar(
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
            child: Container(
              padding: EdgeInsets.all(35.0),
              child: Container(
                margin: EdgeInsets.only(top: 85.0, right: 25, left: 25),
                padding: EdgeInsets.all(3.0),
                //   padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 243, 243, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "       Discover you're city",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/back2.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '24 city founds',
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: Colors.red,
                            size: 18.0,
                          ),
                          Text(
                            ' Tunisie',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                children: [
                  InkWell(
                    onTap: () async {
                      showCities("gabes");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/gabes1.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 6,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gabes',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("mednine");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/mednine.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mednine',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("tatawin");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/tatwin.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 10, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tataouine',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      getPlaceByCity("sfax").then((_) => showCities("sfax"));

                      ;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/sfax.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sfax',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("gafsa");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/gafsa.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gafsa',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("mahdia");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/mahdia.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mahdia',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("benzart");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/bizerte.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Benzart',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("beja");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/beja.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Beja',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("benarous");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/benarous.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Benarous',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await getPlaceByCity("kef")
                          .then((_) => showCities("kef"));
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/kef.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'kef',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("kebili");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/kebili.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'kebili',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("jendouba");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/jendouba.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'jendouba',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("kaoiraouin");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/kaoiraouin.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(2, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'kaoiraouin',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showCities("kasserine");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/city/kasserine.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  right: -15,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: CircleBorder(),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 10, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'kasserine',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.lightGreen,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<PlaceModel>> fetchData() async {
    final response = await http
        .get((Uri.parse('https://jsonplaceholder.typicode.com/albums')));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new PlaceModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  void initPlatforme() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> showCities(
      String state) async {


    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return SingleChildScrollView(
              child: Stack(children: <Widget>[
            Container(
                height: 400,
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPlacePage(
                                    state,
                                    sharedPreferences
                                        ?.getString('token')
                                        .toString())));
                      },
                      child: Container(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Create new place",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 12.0),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recommended place',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                    Expanded(
                        //show image 0 of the city
                        child: Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 20.0, top: 5.0),
                      padding: const EdgeInsets.all(12.0),
                      child: citiesNames.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: citiesNames.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () => {
                                    imagesPlace.clear(),
                                    placeId = citiesNames[index].id.toString(),
                                    placeName =
                                        citiesNames[index].name.toString(),
                                    placeDescription = citiesNames[index]
                                        .description
                                        .toString(),
                                    placeAddress =
                                        citiesNames[index].adresse.toString(),
                                    isAuteur =
                                        citiesNames[index].userId.toString() ==
                                            sharedPreferences
                                                ?.getString('token')
                                                .toString(),
                                    citiesNames[index].images[0]
                                        ['path'] /*split(",")*/,
                                    /*imagesPlace = citiesNames[index]
                                        .images[0],*/
                                    /*  .split(
                                            ",")*/
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PlaceDetailsPage(
                                                  imagesPlace,
                                                  placeName,
                                                  citiesNames[index]
                                                      .id
                                                      .toString(),
                                                  state,
                                                  placeDescription,
                                                  placeAddress,
                                                  isAuteur,
                                                  citiesNames[index]
                                                      .latitude
                                                      .toString(),
                                                  citiesNames[index]
                                                      .longitude
                                                      .toString(),
                                                  citiesNames[index]
                                                      .getFirstImage(),
                                                )))
                                  },
                                  child: Column(children: [
                                    citiesNames[index].getFirstImage() != null
                                        ? Container(
                                            width: 200,
                                            height: 150,
                                            child: Image.network(
                                                //show image 0 of the list
                                                citiesNames[index]
                                                    .getFirstImage()!
                                                /* .substring(0, citiesNames[index]
                                               .images[0]['path'].indexOf(
                                               ","))*/
                                                ))
                                        : SizedBox(),
                                    Center(
                                        child: Text(citiesNames[index].name,
                                            style: TextStyle(
                                                color: Colors.black26,
                                                fontSize: 17.0,
                                                fontWeight:
                                                    FontWeight.normal))),
                                  ]),
                                );
                              })
                          : Text(
                              "No places added in this city..",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                    ))
                  ],
                ))
          ]));
        });
      },
    );
  }
}
