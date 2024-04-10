import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ultimatedemo/main.dart';
import 'package:ultimatedemo/modelfrombackend/LoginResult.dart';
import 'package:ultimatedemo/modelfrombackend/UserNameResult.dart';
import 'package:ultimatedemo/modeltobackend/LoginJson.dart';
import 'package:ultimatedemo/modeltobackend/RegisterJson.dart';
import 'package:ultimatedemo/request.dart';

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

class LoginScreen extends StatefulWidget {
  final _formValidateKey = GlobalKey<FormState>(); // Form key

  //用于formfield,单独获取各个输入框的校验结果
  final _phonenumberFieldValidateKey = GlobalKey<FormFieldState>();
  final _userNameFieldValidateKey = GlobalKey<FormFieldState>();
  final _passwordFieldValidateKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldValidateKey = GlobalKey<FormFieldState>();

  //用于自定义输入框组件，用于使用自定义输入框组件的状态变量
  final _phonenumberFieldKey = GlobalKey<MyTextFieldState>();
  final _userNameFieldKey = GlobalKey<MyTextFieldState>();
  final _passwordFieldKey = GlobalKey<MyTextFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<MyTextFieldState>();
  final _myButtonKey = GlobalKey<MyButtonState>();

  late MyTextField _phonenumberFormField;
  late MyTextField _userNameFormField;
  late MyTextField _passwordFormField;
  late MyTextField _confirmPasswordFormField;
  late MyButton myButton;

  late List<GlobalKey<FormFieldState>> formFieldValidateKeys = [];
  late List<MyTextField> formFields = [];

  late Animation<Offset> _userNameOffset;

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

  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  bool isLogin = true;

  late AnimationController _animationController;

  TextEditingController _phonenumberController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.myButton = MyButton(
      key: widget._myButtonKey,
      height: 40,
      // width: 180,
      roundLoadingShape: true,
      onTap: (startLoading, success, fail, btnState) {
        FocusScope.of(context).unfocus();

        //校验全部输入框，校验未通过的输入框执行动画
        if (widget._formValidateKey.currentState!.validate()) {
          //按钮若处于繁忙状态，则再次按下无效
          if (btnState == ButtonState.Idle) {
            //执行加载动画
            startLoading();

            Future.delayed(Duration(seconds: 1), () async {
              //若此时按钮功能为登录
              if (isLogin) {
                LoginJson loginJson = LoginJson(
                    password: _passwordController.text,
                    userName: _userNameController.text,
                    phonenumber: _phonenumberController.text);
                //发送登录请求
                LoginResult? loginResult = await login(loginJson);
                //若返回令牌,则表示存在该用户,成功
                if (loginResult!.token != '') {
                  //保存令牌等常用信息在widget树根
                  MyAppState myAppState =
                      Provider.of<MyAppState>(context, listen: false);
                  myAppState.token = loginResult.token;
                  myAppState.userName = _userNameController.text;
                  //按钮成功动画
                  success();
                  //页面跳转动画
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        transitionDuration: Duration(seconds: 3), // 动画持续时间
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return isLogin
                              ? AllWhiteScreen()
                              : LoginScreen(); // 替换成你要跳转的页面
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
                  });
                } else {
                  //若未返回令牌，则登录失败，按钮的失败动画
                  fail();
                  //展示提示条告知失败原因
                  Future.delayed(Duration(milliseconds: 500), () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 1500),
                        content: Text(
                            'login fail !phonenumber not register or incorrect userName or password !!!'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ), // 设置为floating以从顶部出现
                    );
                  });
                }
              } else {
                //若按钮功能为注册
                UserNameResult? phonenumberUsed =
                    await getUserNameByPhonenumber(
                        _phonenumberController.text); //查询手机号是否被注册
                UserNameResult? userNameUsed = await getUserNameByUserName(
                    _userNameController.text); //查询用户名是否被使用
                bool pu = phonenumberUsed!.userName != '';
                bool uu = userNameUsed!.userName != '';
                //若手机号或用户名被使用，则失败，消息条展示原因
                if (pu || uu) {
                  //按钮失败动画
                  fail();
                  Future.delayed(Duration(milliseconds: 500), () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(milliseconds: 1500),
                        content: pu
                            ? const Text(
                                'register fail !phonenumber is used !!!')
                            : const Text('register fail !userName is used !!!'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ), // 设置为floating以从顶部出现
                    );
                  });
                } else {
                  //若信息未使用，则成功
                  RegisterJson registerJson = RegisterJson(
                      password: _passwordController.text,
                      userName: _userNameController.text,
                      confirmPassword: _confirmPasswordController.text,
                      phonenumber: _phonenumberController.text);
                  //将注册用户信息存入数据库
                  register(registerJson);
                  //按钮成功动画
                  success();
                  //执行页面跳转动画，换一个新的登录界面
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        transitionDuration: Duration(seconds: 3), // 动画持续时间
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return LoginScreen(); // 替换成你要跳转的页面
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
                  });
                }
              }
            });
          } else {} //按钮繁忙时按按钮什么也不做，
        } else {
          // 表单校验未通过，执行动画突出显示未通过校验的输入框
          _animateInvalidInputFields();
        }
      },
      loader: Container(
        padding: EdgeInsets.all(10),
        child: const SpinKitHourGlass(
          color: Color.fromARGB(255, 20, 235, 243),
        ),
      ),
      borderRadius: 5.0,
      color: Colors.black,

      switchChild: Text('Register',
          style: const TextStyle(
              color: Color.fromARGB(255, 7, 250, 238), fontSize: 20)),
      //TODO
      child: Text('Login',
          style: const TextStyle(
              color: Color.fromARGB(255, 7, 250, 238), fontSize: 20)),
    );

    widget._phonenumberFormField = MyTextField(
      height: 60,
      keyBoardType: TextInputType.number,
      validateKey: widget._phonenumberFieldValidateKey,
      key: widget._phonenumberFieldKey,
      labelText: 'Phonenumber',
      hintText: 'e.g. 1xxxxxxxxxx',
      regExp: RegExp(r'^\d{11}$'),
      invalidHint: 'consists of eleven digits!!!',
      hintStyle: TextStyle(backgroundColor: Colors.amber, fontSize: 11),
      prefixIcon: Icons.person,
      controller: _phonenumberController,
    );

    widget._userNameFormField = MyTextField(
      keyBoardType: TextInputType.multiline,
      validateKey: widget._userNameFieldValidateKey,
      key: widget._userNameFieldKey,
      labelText: 'userName',
      prefixIcon: Icons.account_circle,
      controller: _userNameController,
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

    widget.formFields.add(widget._phonenumberFormField);
    widget.formFields.add(widget._userNameFormField);
    widget.formFields.add(widget._passwordFormField);

    widget.formFieldValidateKeys.add(widget._phonenumberFieldValidateKey);
    widget.formFieldValidateKeys.add(widget._userNameFieldValidateKey);
    widget.formFieldValidateKeys.add(widget._passwordFieldValidateKey);

    _startBackgroundImageAnimation();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    widget._userNameOffset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: Curves.elasticInOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _phonenumberController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              widget._backgroundImages[
                  _currentIndex % widget._backgroundImages.length],
              key: ValueKey(widget._backgroundImages[
                  _currentIndex % widget._backgroundImages.length]),
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
            position: widget._userNameOffset,
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
                        interval: 100.ms,
                        effects: [
                          FadeEffect(delay: 1500.ms),
                          ShimmerEffect(delay: 1500.ms),
                          SaturateEffect(delay: 1500.ms)
                        ],
                        children: [
                          widget._phonenumberFormField,
                          SizedBox(
                            height: 5,
                          ),
                          widget._userNameFormField,
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
                                            widget.myButton.key!.currentState!
                                                .textSwitch();
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
                            child: Center(child: widget.myButton),
                          ),
                          const ElTooltip(
                            position: ElTooltipPosition.leftEnd,
                            content: Text(
                                'authenticated(已认证信息):\nphonenumber:78978978978\nuserName:qwe\npassword:123q\n不用看了可以注册'),
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
    Future.delayed(Duration(milliseconds: 4000), () {
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
