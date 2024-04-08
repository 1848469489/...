//validate animation

import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:ultimatedemo/screen/HomeRoute.dart';
import 'screen/LoginScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

// class LoginApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       color: Colors.white,
//       debugShowCheckedModeBanner: false,
//       // 定义路由表
//       routes: {
//         LoginScreen.routeName: (context) => LoginScreen(),
//         HomeRoute.routeName: (context) => HomeRoute(),
//       },
//       home: SplashScreen(),
//       title: 'Login Form',
//       theme: ThemeData(primarySwatch: Colors.blue),
//     );
//   }
// }
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with ChangeNotifier {
  late bool isAuth = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyAppState>.value(
      value: this,
      child: MaterialApp(
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
      ),
    );
  }

  void updateAuthStatus(bool status) {
    isAuth = status;
    notifyListeners(); // 通知所有监听者进行重建
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
    Future.delayed(Duration(seconds: 2), () {
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
