
import 'package:camping/pages/widget/header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../common/theme_helper.dart';
import 'forgat_password_verification_page.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(150),
        child: AppBar(
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/back2.jpg"),
                    fit: BoxFit.fill
                ),),
            ),
          ),
          backgroundColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
          ),
        ),
      ),
      backgroundColor: Colors.white,
                body:SingleChildScrollView(child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      SizedBox(height: 30.0),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 50, 25, 10),
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Forgot Password?',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Text('Enter the email address associated with your account.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),

                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration("Email", "Enter your email"),
                                validator: (val){
                                  if(val!.isEmpty){
                                    return "Email can't be empty";
                                  }
                                  else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),

                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80.0),color: Colors.orangeAccent
                              ),child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10),
                                  child: Text(
                                    "Send".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                              /*    if(_formKey.currentState!.validate()) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ForgotPasswordVerificationPage()),
                                    );
                                  } */
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Remember your password? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginPage()),
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    ));
  }
}
