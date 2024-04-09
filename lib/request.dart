
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:ultimatedemo/modelfrombackend/LoginResult.dart';
import 'package:ultimatedemo/modeltobackend/LoginJson.dart';

Future<LoginResult?> login(
   LoginJson loginJson) async {
  final response = await http.post(
    Uri.parse('http://43.139.215.162:8888/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': loginJson.userName,
      'password': loginJson.password,
      'phonenumber': loginJson.phonenumber,
    }),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    
    return LoginResult.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return null;
  }
}