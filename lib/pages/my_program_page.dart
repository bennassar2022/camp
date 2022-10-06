import 'dart:convert';

import 'package:camping/pages/splash_screen.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        Align,
        Alignment,
        AnnotatedRegion,
        AppBar,
        AssetImage,
        Axis,
        BorderRadius,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Card,
        Center,
        CircleAvatar,
        Clip,
        ClipRRect,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        DecorationImage,
        Drawer,
        DrawerHeader,
        EdgeInsets,
        Expanded,
        FloatingActionButton,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        Image,
        InkWell,
        LinearGradient,
        ListBody,
        ListView,
        MaterialPageRoute,
        MediaQuery,
        Navigator,
        PreferredSize,
        Radius,
        RichText,
        RoundedRectangleBorder,
        Route,
        Row,
        Scaffold,
        ScaffoldMessenger,
        SingleChildScrollView,
        Size,
        SizedBox,
        SnackBar,
        Stack,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextSpan,
        TextStyle,
        Theme,
        Widget,
        showDialog;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/program_model.dart';
import 'forgat_password_verification_page.dart';
import 'forgot_password_page.dart';
import 'login_page.dart';
import 'registration_page.dart';

class MyProgram extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyProgramPage();
  }
}

class _MyProgramPage extends State<MyProgram> {
  List<Program> programUser = [];

  @override
  void initState() {
    initPlateforme();
  }

  void initPlateforme() async {
    await getProgramUser();
  }

  getProgramUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<Program> jsonResponse = [];

    var res = await http.post(
      Uri.parse('http://192.168.1.15:3000/api/userprogram'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': sharedPreferences.getString("token").toString(),
      }),
    );

    if (res.statusCode == 200) {
      final programModel = programModelFromJson(res.body);
      jsonResponse.addAll(programModel.data);
      print("campResp ${jsonResponse[0].placeName}");
      setState(() {
        programUser = [];
        programUser.addAll(programModel.data);
      });
    } else {
      print("Response status : ${res.body}");
    }

    // return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    initPlateforme();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My programs"),
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/back2.jpg"),
                  fit: BoxFit.fill),
            ),
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
        ),
      ),
      body: programUser.length > 0
          ? ListView.builder(
              itemCount: programUser.length,
              itemBuilder: (BuildContext context, int index) {
                return
                    //Card(
                    //           semanticContainer: true,
                    //           clipBehavior: Clip.antiAliasWithSaveLayer,
                    //           child: Image.network(
                    //             'https://placeimg.com/640/480/any',
                    //             fit: BoxFit.fill,
                    //           ),
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10.0),
                    //           ),
                    //           elevation: 5,
                    //           margin: EdgeInsets.all(10),
                    //         ),
                    InkWell(
                        onTap: () {},
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Row(children: [
                                  Expanded(
                                      child: Column(children: [
                                    Text(
                                      "start camp : ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(programUser[index].start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                  ])),
                                  Expanded(
                                      child: Column(children: [
                                    Text(
                                      "end camp : ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(programUser[index].end,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                  ])),
                                ]),
                                SizedBox(height: 15.0),
                                Column(children: [
                                  Text(
                                      "place name : ${programUser[index].placeName}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54)),
                                  Text("state : ${programUser[index].state}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54)),
                                  Text("email : ${programUser[index].email}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54)),
                                ]),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        deleteProgram(programUser[index].id);
                                      },
                                    ))
                              ],
                            )));
              })
          : Center(
              child: Text(
              "You have no program right now..",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )),
    );
  }

  deleteProgram(String programId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
              title: const Text('Delete program'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                      'are you sure to delete this program ??',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    //   Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    print("programId : $programId");
                    // delete place
                    var url =
                        "https://api-camp.herokuapp.com/api/deleteprograms/$programId";

                    var jsonResponse;
                    var res = await http.delete((Uri.parse(url)));
                    if (res.statusCode == 200) {
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          "Success delete program..",
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    }
                  },
                ),
                TextButton(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
