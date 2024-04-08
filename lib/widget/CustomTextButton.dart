import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String buttonText;

  const CustomTextButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  _CustomTextButtonState createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Center(
        child: Text(
          widget.buttonText,
          style: GoogleFonts.aboreto(
            textStyle: TextStyle(
              fontWeight: isPressed ? FontWeight.w900 :FontWeight.w100,
              fontSize: 16,
              color: Colors.amberAccent,
              decoration:
                  isPressed ? TextDecoration.underline : TextDecoration.none,
              decorationColor: isPressed ? Colors.amberAccent : null,
            ),
          ),
        ),
      ),
    );
  }
}
