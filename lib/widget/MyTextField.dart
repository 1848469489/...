//自定义输入框
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  GlobalKey<FormFieldState>? validateKey;
  GlobalKey<MyTextFieldState>? key;
  Color? prefixIconColor;
  double? height;
  double? width;
  String? labelText;
  RegExp? regExp;
  String? invalidHint;
  TextStyle? labelStyle;
  String? hintText;
  TextStyle? hintStyle;
  TextStyle? textStyle;
  IconData? prefixIcon;
  bool isPassword = false;
  String? Function(String?)? validated;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputType? keyBoardType;
  MyTextField({
    this.keyBoardType,
    this.validateKey,
    this.key,
    this.prefixIconColor,
    this.height,
    this.width,
    this.labelText,
    this.regExp,
    this.invalidHint,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.isPassword = false,
    this.validated,
    this.controller,
    this.focusNode,
  });

  @override
  State<MyTextField> createState() => MyTextFieldState();
}

  class MyTextFieldState extends State<MyTextField> {
  bool isAnimating = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      //动画执行时间
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInBack,
      width: (isAnimating
          ? 300.0
          : widget.width ?? MediaQuery.of(context).size.width / 2),
      height: widget.height ?? 60,

      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          TextFormField(
            keyboardType: widget.keyBoardType ?? TextInputType.text,
            key: widget.validateKey,
            controller: widget.controller,
            onTap: () {
              widget.validateKey!.currentState!.reset();
              widget.controller?.clear();
            },
            style: widget.textStyle ?? TextStyle(color: Colors.white),
            decoration: InputDecoration(
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // 设置验证失败时下划线的颜色为红色
              ),
              errorStyle: TextStyle(
                  color: Color.fromARGB(255, 64, 255, 242)), // 设置验证失败时的字体颜色为红色
              labelStyle: widget.labelStyle ??
                  TextStyle(color: Color.fromARGB(255, 64, 255, 242)),
              labelText: widget.labelText,
              prefixIconColor: widget.prefixIconColor ?? Colors.white,
              prefixIcon:
                  widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
              hintText: widget.hintText ?? '',
              hintStyle:
                  widget.hintStyle ?? TextStyle(backgroundColor: Colors.red),
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            obscureText: widget.isPassword && _isPasswordVisible,
            validator: (value) {
              if ((value?.isEmpty ?? true) ||
                  (widget.regExp == null
                      ? !RegExp(r'^\S+$').hasMatch(value!)
                      : !widget.regExp!.hasMatch(value!))) {
                return widget.invalidHint ?? '  Invalid input!!!';
              }
              return null; // 返回null表示验证通过
            },
          ),
          if (widget.isPassword)
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: IconButton(
                style: ButtonStyle(
                    iconColor: MaterialStateProperty.all<Color?>(Colors.white)),
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: _onTogglePasswordVisibility,
              ),
            ),
        ],
      ),
    );
  }

  void _onTogglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void rebuild() {
    setState(() {});
  }
}

