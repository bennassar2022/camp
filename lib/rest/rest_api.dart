
import 'dart:convert';

import 'package:http/http.dart' as http;

Future Login (String email,String password) async{
  final url = "https://api-camp.herokuapp.com/auth/login";
  final response = await http.post((Uri.parse(url)),
    headers: {"Accept": "Application/json"},
      body: {'email':email,'password': password}
  );

  var encodeFirst = json.encode(response.body);
  var decodedData=jsonDecode(encodeFirst);
  return decodedData;

}