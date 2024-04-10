import 'package:provider/provider.dart';

import '../main.dart';
import 'HomeRoute.dart';
import 'package:flutter/material.dart';

class AllWhiteScreen extends StatefulWidget {
  @override
  _AllWhiteScreenState createState() => _AllWhiteScreenState();
}

class _AllWhiteScreenState extends State<AllWhiteScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<MyAppState>(context).updateAuthStatus(true);
// 在构建完成后立即跳转到另一个页面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 使用 Navigator 进行页面跳转
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 3), // 动画持续时间
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomeRoute(); // 替换成你要跳转的页面
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                // 使用 FadeTransition 进行淡入淡出动画
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      });
    });

    return Scaffold(
      body: Container(
        color: Colors.white, // 设置容器背景颜色为白色
      ),
    );
  }
}

// 创建一个MaterialColor来表示白色

