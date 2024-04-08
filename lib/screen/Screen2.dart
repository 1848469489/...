import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Screen2 extends StatefulWidget {
  const Screen2({super.key, required this.title});

  final String title;

  @override
  State<Screen2> createState() => _Screen2State();
}

class user {
  final int id;
  final String username;

  const user({required this.id, required this.username});
  factory user.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'username': String username,
      } =>
        user(
          id: id,
          username: username,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}

Future<user> registerUser(
    String username, String password, String confirm_password) async {
  final response = await http.post(
    Uri.parse('http://192.168.123.23:8000/api/v2/register/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'confirm_password': confirm_password,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return user.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to .');
  }
}

class _Screen2State extends State<Screen2> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();
  // Future<Album>? _futureAlbum;
  Future<user>? _futureUser;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  FutureBuilder<user> buildFutureBuilder() {
    return FutureBuilder<user>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
              snapshot.data!.username + "---" + snapshot.data!.id.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: (_futureUser == null) ? buildColumn() : buildFutureBuilder(),
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureUser = registerUser('abcd', '123456', '123456');
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
