import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllPrograms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllProgramsPage();
  }
}

 class _AllProgramsPage extends State<AllPrograms> {
  getPrograms () async {
    var res = await http.get((Uri.parse("https://appcamping.herokuapp.com/api/getprograms")));
    if (res.statusCode == 200){
      var jsonObj= jsonDecode(res.body);
      return jsonObj['data'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Camping programs"),
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
        body:Center(
       child: FutureBuilder(
         future: getPrograms (), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
           if(snapshot.data != null) {
             return ListView.builder(
               itemCount:snapshot.data.length ,
               itemBuilder: (context, index){
                return Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 8,
                    margin: EdgeInsets.all(10),
                 shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20.0),
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
                                      color: Colors.blue),
                                ),
                                Text(snapshot.data[index]['start'],
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
                                      color: Colors.red),
                                ),
                                Text(snapshot.data[index]['end'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal))
                              ])),
                        ]),
                        SizedBox(height: 15.0),
                        Column(children: [
                          Text(
                              "place  : ${snapshot.data[index]['place_Name']}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black)),
                          Text("City : ${snapshot.data[index]['state']}",
                              style: TextStyle(
                                  fontSize: 13,
                                //  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("the campeur : ${snapshot.data[index]['email']}",
                              style: TextStyle(
                                  fontSize: 13,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ]),
                      ],
                    ),);

               },
             );
           }else{
             return CircularProgressIndicator();
           }
       },
       ),
        ),

    );
  }

}