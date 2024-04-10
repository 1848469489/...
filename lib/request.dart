import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ultimatedemo/modelfrombackend/LoginResult.dart';
import 'package:ultimatedemo/modelfrombackend/RegisterResult.dart';
import 'package:ultimatedemo/modelfrombackend/UserNameResult.dart';
import 'package:ultimatedemo/modeltobackend/LoginJson.dart';
import 'package:ultimatedemo/modeltobackend/RegisterJson.dart';

//登录
Future<LoginResult?> login(LoginJson loginJson) async {
  final response = await http.post(
    Uri.parse('http://43.139.215.162:8888/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userName': loginJson.userName,
      'password': loginJson.password,
      'phonenumber': loginJson.phonenumber,
    }),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    return LoginResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return null;
  }
}

//注册
Future<RegisterResult?> register(RegisterJson regitsterJson) async {
  final response = await http.post(
    Uri.parse('http://43.139.215.162:8888/user/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userName': regitsterJson.userName,
      'password': regitsterJson.password,
      'confirmPassword': regitsterJson.confirmPassword,
      'phonenumber': regitsterJson.phonenumber,
    }),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    return RegisterResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return null;
  }
}

//根据手机号查询一个用户
Future<UserNameResult?> getUserNameByPhonenumber(String phonenumber) async {
  final response = await http.post(
    Uri.parse('http://43.139.215.162:8888/user/getUserNameByPhonenumber'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phonenumber': phonenumber,
    }),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return UserNameResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return null;
  }
}

//根据用户名查询一个用户
Future<UserNameResult?> getUserNameByUserName(String userName) async {
  final response = await http.post(
    Uri.parse('http://43.139.215.162:8888/user/getUserNameByUserName'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userName': userName,
    }),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return UserNameResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return null;
  }
}

