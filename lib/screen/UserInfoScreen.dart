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
  String _username = "John Doe";
  String _email = "john.doe@example.com";
  String _phone = "123-456-7890";

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
                    'Username: $_username',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email: $_email',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Phone: $_phone',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _editProfile,
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          )
        : LoginScreen();
  }

  void _editProfile() {
    // 在这里处理编辑用户信息的逻辑
    // 例如打开一个编辑页面或者弹出对话框
    setState(() {
      _username = "Updated Username";
      _email = "updated.email@example.com";
      _phone = "987-654-3210";
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
