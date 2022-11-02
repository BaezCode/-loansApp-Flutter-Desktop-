
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        color: Colors.blue[700],
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => onPressed());
  }
}
