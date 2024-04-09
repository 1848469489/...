import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ultimatedemo/screen/LoginScreen.dart';

import '../main.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Provider.of<MyAppState>(context).isAuth == true
        ? Scaffold(
            appBar: AppBar(
              title: Text('User Profile'),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'userName: ${Provider.of<MyAppState>(context).userName}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'token: ${Provider.of<MyAppState>(context).token}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )
        : LoginScreen();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
