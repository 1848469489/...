import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ultimatedemo/main.dart';
import 'package:ultimatedemo/screen/HomeRoute.dart';
import 'package:ultimatedemo/widget/CustomTextButton.dart';

import 'BlankScreen.dart';
import '../widget/OutlineGradientButton.dart';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/MyTextField.dart';
import '../widget/AnimatedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:el_tooltip/el_tooltip.dart';

int _currentIndex = 0;
List _backgroundImages = [
  'assets/images/miku02.jpg',
  'assets/images/miku03.jpg',
  'assets/images/miku04.jpg',
  'assets/images/miku05.jpg',
  'assets/images/miku06.jpg',
  'assets/images/miku07.jpg',
  'assets/images/miku08.jpg',
  'assets/images/20240326230235.jpg',
  'assets/images/20240326230337.jpg',
];

class LoginScreen extends StatefulWidget {
  final _formValidateKey = GlobalKey<FormState>(); // Form key
  final _studentIDFieldValidateKey = GlobalKey<FormFieldState>();
  final _nameFieldValidateKey = GlobalKey<FormFieldState>();
  final _passwordFieldValidateKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldValidateKey = GlobalKey<FormFieldState>();

  final _studentIDFieldKey = GlobalKey<MyTextFieldState>();
  final _nameFieldKey = GlobalKey<MyTextFieldState>();
  final _passwordFieldKey = GlobalKey<MyTextFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<MyTextFieldState>();

  late MyTextField _studentIDFormField;
  late MyTextField _nameFormField;
  late MyTextField _passwordFormField;
  late MyTextField _confirmPasswordFormField;

  late List<GlobalKey<FormFieldState>> formFieldValidateKeys = [];
  late List<MyTextField> formFields = [];

  late AnimationController _animationController;
  late Animation<Offset> _nameOffset;
  late Animation<Offset> _studentIdOffset;
  late Animation<Offset> _passwordOffset;

  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool isLogin = true;
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _showWhiteBackground = false;

  @override
  void initState() {
    super.initState();

    widget._studentIDFormField = MyTextField(
      height: 60,
      keyBoardType: TextInputType.number,
      validateKey: widget._studentIDFieldValidateKey,
      key: widget._studentIDFieldKey,
      labelText: 'Student ID',
      hintText: 'e.g. 212511061XX',
      regExp: RegExp(r'^\d+$'),
      invalidHint: 'consists of digits!!!',
      hintStyle: TextStyle(backgroundColor: Colors.amber, fontSize: 11),
      prefixIcon: Icons.person,
      controller: _studentIdController,
    );

    widget._nameFormField = MyTextField(
      keyBoardType: TextInputType.multiline,
      validateKey: widget._nameFieldValidateKey,
      key: widget._nameFieldKey,
      labelText: 'Name',
      prefixIcon: Icons.account_circle,
      controller: _nameController,
    );

    widget._passwordFormField = MyTextField(
      keyBoardType: TextInputType.visiblePassword,
      validateKey: widget._passwordFieldValidateKey,
      key: widget._passwordFieldKey,
      labelText: 'Password',
      prefixIcon: Icons.lock,
      isPassword: true,
      regExp: RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+$'),
      invalidHint: 'consists of digits and letters!!!',
      controller: _passwordController,
    );

    widget._confirmPasswordFormField = MyTextField(
      keyBoardType: TextInputType.visiblePassword,
      validateKey: widget._confirmPasswordFieldValidateKey,
      key: widget._confirmPasswordFieldKey,
      labelText: 'ConfirmPassword',
      prefixIcon: Icons.lock_outline,
      isPassword: true,
      validated: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your password.';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
      invalidHint: 'equal to Password!!!',
      controller: _confirmPasswordController,
    );

    widget.formFields.add(widget._studentIDFormField);
    widget.formFields.add(widget._nameFormField);
    widget.formFields.add(widget._passwordFormField);

    widget.formFieldValidateKeys.add(widget._studentIDFieldValidateKey);
    widget.formFieldValidateKeys.add(widget._nameFieldValidateKey);
    widget.formFieldValidateKeys.add(widget._passwordFieldValidateKey);

    _startBackgroundImageAnimation();

    widget._animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    widget._nameOffset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget._animationController,
      curve: Interval(0.0, 1.0, curve: Curves.elasticInOut),
    ));

    widget._animationController.forward();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    widget._animationController.dispose();
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0), // 设置左右间距
            child: Align(
              alignment: Alignment(0.0, -0.5), // 设置屏幕中央偏上的位置
              child: SizedBox(
                width: double.infinity, // 让文字动画撑满屏幕宽度
                child: DefaultTextStyle(
                  textAlign: TextAlign.center, // 让文字居中显示
                  style: GoogleFonts.aboreto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 10, 202, 212),
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),

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
            position: widget._nameOffset,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                child: Form(
                  key: widget._formValidateKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 300),
                      SizedBox(height: 240.0),
                      Column(
                          children: AnimateList(
                        interval: 200.ms,
                        effects: [
                          FadeEffect(delay: 1500.ms),
                          ShimmerEffect(delay: 1500.ms),
                          SaturateEffect(delay: 1500.ms)
                        ],
                        children: [
                          widget._studentIDFormField,
                          SizedBox(
                            height: 5,
                          ),
                          widget._nameFormField,
                          SizedBox(
                            height: 5,
                          ),
                          widget._passwordFormField,
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 60,
                            child: isLogin
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTextButton(
                                          onTap: () {
                                            widget.formFields.add(widget
                                                ._confirmPasswordFormField);
                                            widget.formFieldValidateKeys.add(widget
                                                ._confirmPasswordFieldValidateKey);
                                            isLogin = false;
                                            rebuild();
                                          },
                                          buttonText: 'Register'),
                                      Text(
                                        ' or ',
                                        style: GoogleFonts.aboreto(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.amberAccent,
                                          ),
                                        ),
                                      ),
                                      CustomTextButton(
                                          onTap: null, buttonText: 'forgot?'),
                                    ],
                                  )
                                : widget._confirmPasswordFormField
                                    .animate()
                                    .saturate()
                                    .scale()
                                    .fadeIn(),
                          )
                          //widget._confirmPasswordFormField,
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
                            child: Center(
                                child: MyButton(
                              height: 40,
                              // width: 180,
                              roundLoadingShape: true,
                              onTap: (startLoading, stopLoading, btnState) {
                                FocusScope.of(context).unfocus();
                                if (widget._formValidateKey.currentState!
                                    .validate()) {
                                  if (btnState == ButtonState.Idle) {
                                    startLoading();

                                    Future.delayed(Duration(seconds: 1), () {
                                      if (isLogin) {
                                        bool isAuth = stopLoading(
                                            _studentIdController.text,
                                            _nameController.text,
                                            _passwordController.text);
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          if (!isAuth) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('user not exist!!!'),
                                                backgroundColor: Colors.red,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ), // 设置为floating以从顶部出现
                                            );
                                          } else {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              PageRouteBuilder(
                                                transitionDuration: Duration(
                                                    seconds: 3), // 动画持续时间
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) {
                                                  return AllWhiteScreen(); // 替换成你要跳转的页面
                                                },
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  return FadeTransition(
                                                    // 使用 FadeTransition 进行淡入淡出动画
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                            widget._animationController
                                                .reverse();
                                          }
                                        });
                                      } else {
                                        // if(_confirmPasswordController.text == _passwordController){
                                        //   Navigator.of(context)
                                        //         .pushReplacement(
                                        //       PageRouteBuilder(
                                        //         transitionDuration: Duration(
                                        //             seconds: 3), // 动画持续时间
                                        //         pageBuilder: (context,
                                        //             animation,
                                        //             secondaryAnimation) {
                                        //           return AllWhiteScreen(); // 替换成你要跳转的页面
                                        //         },
                                        //         transitionsBuilder: (context,
                                        //             animation,
                                        //             secondaryAnimation,
                                        //             child) {
                                        //           return FadeTransition(
                                        //             // 使用 FadeTransition 进行淡入淡出动画
                                        //             opacity: animation,
                                        //             child: child,
                                        //           );
                                        //         },
                                        //       ),
                                        //     );
                                        //     widget._animationController
                                        //         .reverse();
                                        // }
                                      }
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
                              child: Text(isLogin! ? 'Login' : 'SignUp',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 7, 250, 238),
                                      fontSize: 20)),
                            )),
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
          Positioned(
            top: 50,
            left: 0,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: 50,
                  child: OutlineGradientButton(
                    inkWell: true,
                    onTap: () {
                      Future.value(0);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeRoute()),
                      );
                    },
                    gradient: LinearGradient(
                      colors: List.generate(
                          360,
                          (h) => HSLColor.fromAHSL(1, h.toDouble(), 1, 0.5)
                              .toColor()),
                    ),
                    strokeWidth: 2,
                    radius: Radius.circular(40),
                    child: const Center(
                        child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: Color.fromARGB(255, 4, 231, 197),
                    )),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _animateInvalidInputFields() {
    // 检查每个表单项的验证结果，如果未通过，则执行动画
    for (var formField in widget.formFields) {
      if (!formField.validateKey!.currentState!.isValid) {
        formField.key!.currentState!.isAnimating = true;
        formField.key!.currentState!.rebuild();
      }
    }
    //在动画结束后重置 _isAnimating 为 false
    Future.delayed(Duration(milliseconds: 5000), () {
      for (var formField in widget.formFields) {
        formField.key!.currentState!.isAnimating = false;
        formField.key!.currentState!.rebuild();
      }
    });
  }

  void _startBackgroundImageAnimation() async {
    await Future.delayed(Duration(seconds: 8), () {
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
