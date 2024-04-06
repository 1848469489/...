//validate animation

import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:ultimatedemo/screen/HomeRoute.dart';
import 'screen/LoginScreen.dart';
import 'package:get/get.dart';
void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      // 定义路由表
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeRoute.routeName: (context) => HomeRoute(),
      },
      home: SplashScreen(),
      title: 'Login Form',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeRoute()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image.asset(
              'assets/images/miku01.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ));
  }
}
