import 'BlankScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:quiver/strings.dart';
import '../widget/MyTextField.dart';
import '../widget/LoginButton.dart';
import 'HomeRoute.dart';
import 'package:el_tooltip/el_tooltip.dart';

final _formValidateKey = GlobalKey<FormState>(); // Form key
final _studentIDFieldValidateKey = GlobalKey<FormFieldState>();
final _nameFieldValidateKey = GlobalKey<FormFieldState>();
final _passwordFieldValidateKey = GlobalKey<FormFieldState>();
final _studentIDFieldKey = GlobalKey<MyTextFieldState>();
final _nameFieldKey = GlobalKey<MyTextFieldState>();
final _passwordFieldKey = GlobalKey<MyTextFieldState>();
int _currentIndex = 0;
List _backgroundImages = [
  'assets/images/20240326230337.jpg',

  'assets/images/miku02.jpg',
  'assets/images/miku03.jpg',
  'assets/images/miku04.jpg',
  'assets/images/miku05.jpg',
  'assets/images/miku06.jpg',
  'assets/images/miku07.jpg',
  'assets/images/miku08.jpg',
  'assets/images/20240326230235.jpg',
];
late MyTextField _studentIDFormField;
late MyTextField _nameFormField;
late MyTextField _passwordFormField;
late LoginButton _loginButton;

late List<GlobalKey<FormFieldState>> formFieldValidateKeys = [];
late List<MyTextField> formFields = [];

TextEditingController _studentIdController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

late AnimationController _animationController;
late Animation<Offset> _nameOffset;
late Animation<Offset> _studentIdOffset;
late Animation<Offset> _passwordOffset;

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _showWhiteBackground = false;
  // late AnimationController _pageAnimationController;
  // late Animation<Color?> _pageAnimation;
  @override
  void initState() {
    super.initState();
    _loginButton = LoginButton(
      height: 50,
      // width: 180,
      roundLoadingShape: true,
      onTap: (startLoading, stopLoading, btnState) {
        FocusScope.of(context).unfocus();
        if (_formValidateKey.currentState!.validate()) {
          if (btnState == ButtonState.Idle) {
            startLoading();

            Future.delayed(Duration(seconds: 1), () {
              bool isAuth = stopLoading(_studentIdController.text,
                  _nameController.text, _passwordController.text);
              Future.delayed(Duration(milliseconds: 500), () {
                if (!isAuth) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('user not exist!!!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ), // 设置为floating以从顶部出现
                  );
                } else {
                  
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        transitionDuration: Duration(seconds: 3), // 动画持续时间
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return AllWhiteScreen(); // 替换成你要跳转的页面
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
                  
                  _animationController.reverse();
                }
                // _checkmarkAnimationController.forward;
                print("hello");
              });
            });
          } else {}
        } else {
          // 表单校验未通过，执行动画突出显示未通过校验的输入框
          _animateInvalidInputFields();
        }
      },
      loader: Container(
        padding: EdgeInsets.all(10),
        child: const SpinKitHourGlass(
          color: Color.fromARGB(255, 20, 235, 243),
          // size: loaderWidth ,
        ),
      ),
      borderRadius: 5.0,
      color: Colors.black,
      child: const Text('Login',
          style:
              TextStyle(color: Color.fromARGB(255, 7, 250, 238), fontSize: 20)),
    );
    _studentIDFormField = MyTextField(
      keyBoardType: TextInputType.number,
      validateKey: _studentIDFieldValidateKey,
      key: _studentIDFieldKey,
      labelText: 'Student ID',
      hintText: 'e.g. 212511061XX',
      regExp: RegExp(r'^\d+$'),
      invalidHint: 'consists of digits!!!',
      hintStyle: TextStyle(backgroundColor: Colors.amber, fontSize: 11),
      prefixIcon: Icons.person,
      controller: _studentIdController,
    );

    _nameFormField = MyTextField(
      keyBoardType: TextInputType.multiline,
      validateKey: _nameFieldValidateKey,
      key: _nameFieldKey,
      labelText: 'Name',
      prefixIcon: Icons.account_circle,
      controller: _nameController,
    );

    _passwordFormField = MyTextField(
      keyBoardType: TextInputType.visiblePassword,
      validateKey: _passwordFieldValidateKey,
      key: _passwordFieldKey,
      labelText: 'Password',
      prefixIcon: Icons.lock,
      isPassword: true,
      regExp: RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+$'),
      invalidHint: 'consists of digits and letters!!!',
      controller: _passwordController,
    );

    formFields.add(_studentIDFormField);
    formFields.add(_nameFormField);
    formFields.add(_passwordFormField);

    formFieldValidateKeys.add(_studentIDFieldValidateKey);
    formFieldValidateKeys.add(_nameFieldValidateKey);
    formFieldValidateKeys.add(_passwordFieldValidateKey);
    _startBackgroundImageAnimation();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _studentIdOffset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 1.0, curve: Curves.linear),
    ));
    _nameOffset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: Curves.elasticInOut),
    ));

    _passwordOffset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 1.0, curve: Curves.linear),
    ));
    _animationController.addListener(() {
      setState(() {}); // 通知Flutter重建UI
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    _passwordController.dispose();

    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 4),
            child: Image.asset(
              _backgroundImages[_currentIndex % _backgroundImages.length],
              key: ValueKey(
                  _backgroundImages[_currentIndex % _backgroundImages.length]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            transitionBuilder: (child, animation) {
              return Stack(
                children: [
                  FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  if (_showWhiteBackground)
                    AnimatedOpacity(
                      opacity: _showWhiteBackground ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0), // 设置左右间距
            child: Align(
              alignment: Alignment(0.0, -0.5), // 设置屏幕中央偏上的位置
              child: SizedBox(
                width: double.infinity, // 让文字动画撑满屏幕宽度
                child: DefaultTextStyle(
                  
                  textAlign: TextAlign.center, // 让文字居中显示
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 64, 255, 242)),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                          'Hello!Welcome to xxx.Please to sign in',
                          speed: Duration(milliseconds: 150)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _nameOffset,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                child: Form(
                  key: _formValidateKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 300),
                      SizedBox(height: 250.0),
                      Column(
                          children: AnimateList(
                        interval: 300.ms,
                        effects: [
                          FadeEffect(delay: 1500.ms),
                          ShimmerEffect(delay: 1500.ms),
                          SaturateEffect(delay: 1500.ms)
                        ],
                        children: [
                          _studentIDFormField,
                          SizedBox(
                            height: 5,
                          ),
                          _nameFormField,
                          SizedBox(
                            height: 5,
                          ),
                          _passwordFormField,
                        ],
                      )),
                      
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Center(child: _loginButton),
                          ),
                          const ElTooltip(
                            position: ElTooltipPosition.leftEnd,
                            content: Text(
                                'authenticated(已认证信息):\nstudentID:1\nname:a1\npassword:a1'),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _animateInvalidInputFields() {
    // 检查每个表单项的验证结果，如果未通过，则执行动画
    for (var formField in formFields) {
      if (!formField.validateKey!.currentState!.isValid) {
        formField.key!.currentState!.isAnimating = true;
        formField.key!.currentState!.rebuild();
      }
    }
    //在动画结束后重置 _isAnimating 为 false
    Future.delayed(Duration(milliseconds: 5000), () {
      for (var formField in formFields) {
        formField.key!.currentState!.isAnimating = false;
        formField.key!.currentState!.rebuild();
      }
    });
  }

  void _startBackgroundImageAnimation() {
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        _currentIndex++;
      });
      _startBackgroundImageAnimation();
    });
  }

  void rebuild() {
    setState(() {});
  }
}
