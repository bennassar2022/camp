import 'dart:convert';
import 'package:camping/pages/registration_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../common/theme_helper.dart';
import '../rest/rest_api.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*Future<void> login() async {
   if (passController.text.isNotEmpty && emailController.text.isNotEmpty){
     var response = await http.post(Uri.parse("https://api-camp.herokuapp.com/auth/login"),
         body: ({
         "email": emailController.text ,
         "password": passController.text
         }));
     if (response.statusCode == 200 ){
       Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage() ) );
     } else {
       ScaffoldMessenger.of(context)
           .showSnackBar(SnackBar(content: Text("invalid value")));
     }
   }else{
     ScaffoldMessenger.of(context)
         .showSnackBar(SnackBar(content: Text("blank value fond")));
   }
  }*/

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  var emailController = TextEditingController();
  var passController = TextEditingController();

  //API
  signIn(String email, String pass) async {
    // don't use setState inside build method or inside onTap,
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "email": email,
      "password": pass
    }; // we put here default values, its wrong, try please!
    // var url = 'https://api-camp.herokuapp.com/auth/login';
    var url = 'http://10.0.2.2:3000/auth/login';
    var jsonResponse = null;
    if (passController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var res = await http.post((Uri.parse(url)), body: body);
      if (res.statusCode == 200) {
        jsonResponse = json.decode(res.body);
        print("Response1 : $jsonResponse");
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          SharedPreferences? shared = await SharedPreferences.getInstance();
          shared.setString('token', jsonResponse['_id']);
          shared.setString('email', jsonResponse['email']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage()),
              (Route<dynamic> route) => false);
        }
      } else {
        print("Response1 status : ${res.body}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res.body)));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("blank value fond")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 50, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'LET\'S CAMP',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SizedBox(height: 30.0),
                        Form(
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  controller: emailController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'User Name', 'Enter your user name'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextField(
                                  obscureText: true,
                                  controller: passController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Password', 'Enter your password'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.orangeAccent),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    print('email: ${emailController.text}');
                                    print('email: ${passController.text}');
                                    signIn(emailController.text,
                                        passController.text);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Don\'t have an account? "),
                                      TextSpan(
                                        text: 'Sign up',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegistrationPage()));
                                          },
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
